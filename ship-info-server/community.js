"use strict";
// Аккаунты, отзывы о судах, вакансии крюинга. SQLite встроен в Node 22.13+, без внешних пакетов.
const { DatabaseSync } = require("node:sqlite");
const crypto = require("crypto"), path = require("path");
const db = new DatabaseSync(process.env.DB_PATH || path.join(__dirname, "data.db"));
db.exec(`PRAGMA journal_mode=WAL;
CREATE TABLE IF NOT EXISTS users(id INTEGER PRIMARY KEY, email TEXT UNIQUE, name TEXT, role TEXT, pass TEXT, avatar TEXT, created INTEGER);
CREATE TABLE IF NOT EXISTS sessions(token TEXT PRIMARY KEY, user INTEGER, exp INTEGER);
CREATE TABLE IF NOT EXISTS reviews(id INTEGER PRIMARY KEY, mmsi INTEGER, ship TEXT, user INTEGER, rating INTEGER, text TEXT, created INTEGER, hidden INTEGER DEFAULT 0, reports INTEGER DEFAULT 0, UNIQUE(mmsi,user));
CREATE TABLE IF NOT EXISTS reports(review INTEGER, user INTEGER, PRIMARY KEY(review,user));
CREATE TABLE IF NOT EXISTS jobs(id INTEGER PRIMARY KEY, user INTEGER, title TEXT, rank TEXT, ship_type TEXT, salary TEXT, contact TEXT, descr TEXT, status TEXT DEFAULT 'approved', created INTEGER);`);
const Q = (sql) => db.prepare(sql);
db.exec(`CREATE TABLE IF NOT EXISTS agency_reviews(id INTEGER PRIMARY KEY, agency INTEGER, user INTEGER, rating INTEGER, text TEXT, created INTEGER, UNIQUE(agency,user));
CREATE TABLE IF NOT EXISTS applications(id INTEGER PRIMARY KEY, job INTEGER, user INTEGER, message TEXT, status TEXT DEFAULT 'new', created INTEGER, UNIQUE(job,user))`);
const ADMIN = (process.env.ADMIN_EMAIL || "").toLowerCase();
const sha = (s) => crypto.createHash("sha256").update(s).digest("hex");
const hash = (p) => { const s = crypto.randomBytes(16).toString("hex"); return s + ":" + crypto.scryptSync(p, s, 64).toString("hex"); };
const check = (p, h) => { const [s, k] = h.split(":"); const a = crypto.scryptSync(p, s, 64), b = Buffer.from(k, "hex"); return a.length === b.length && crypto.timingSafeEqual(a, b); };
const str = (v, max) => String(v == null ? "" : v).trim().slice(0, max);
setInterval(() => Q("DELETE FROM sessions WHERE exp<?").run(Date.now()), 3600000);

const tries = new Map(); setInterval(() => tries.clear(), 60000);
const authLimited = (req) => { const ip = (req.headers["x-forwarded-for"] || req.socket.remoteAddress || "").split(",")[0].trim(); const n = (tries.get(ip) || 0) + 1; tries.set(ip, n); return n > 10; };

function readBody(req) {
  return new Promise((ok, no) => {
    let d = ""; req.on("data", (c) => { d += c; if (d.length > 20000) { req.destroy(); no(new Error("big")); } });
    req.on("end", () => { try { ok(d ? JSON.parse(d) : {}); } catch (e) { no(e); } }); req.on("error", no);
  });
}
function userOf(req) {
  const m = /^Bearer ([a-f0-9]{64})$/.exec(req.headers.authorization || "") || /(?:^|; )sid=([a-f0-9]{64})/.exec(req.headers.cookie || ""); if (!m) return null;
  return Q("SELECT u.id,u.email,u.name,u.role FROM sessions s JOIN users u ON u.id=s.user WHERE s.token=? AND s.exp>?").get(sha(m[1]), Date.now()) || null;
}
function startSession(req, res, id) {
  const t = crypto.randomBytes(32).toString("hex"), age = 30 * 86400;
  Q("INSERT INTO sessions(token,user,exp) VALUES(?,?,?)").run(sha(t), id, Date.now() + age * 1000);
  const secure = req.headers["x-forwarded-proto"] === "https" ? "; Secure" : "";
  res.setHeader("Set-Cookie", "sid=" + t + "; HttpOnly; SameSite=Lax; Path=/; Max-Age=" + age + secure); return t;
}

module.exports = async function (req, res, u, json) {
  try {
    const p = u.pathname, m = req.method, me = userOf(req), admin = !!(me && ADMIN && me.email === ADMIN);
    if (m !== "GET" && !(req.headers["content-type"] || "").includes("application/json")) return json(res, 415, { error: "Нужен JSON" });
    const b = m === "GET" ? {} : await readBody(req);
    const need = () => json(res, 401, { error: "Войдите в аккаунт" });

    if (p === "/api/me") return json(res, 200, { user: me ? { name: me.name, email: me.email, role: me.role, admin } : null });
    if (p === "/api/register" && m === "POST") {
      if (authLimited(req)) return json(res, 429, { error: "Слишком много попыток. Подождите минуту." });
      const email = str(b.email, 100).toLowerCase(), name = str(b.name, 50), pw = String(b.password || ""), role = b.role === "agency" ? "agency" : "seaman";
      if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email)) return json(res, 400, { error: "Введите корректный email" });
      if (name.length < 2) return json(res, 400, { error: "Введите имя (от 2 символов)" });
      if (pw.length < 8 || pw.length > 100) return json(res, 400, { error: "Пароль должен быть от 8 символов" });
      if (Q("SELECT 1 FROM users WHERE email=?").get(email)) return json(res, 409, { error: "Этот email уже зарегистрирован" });
      const r = Q("INSERT INTO users(email,name,role,pass,created) VALUES(?,?,?,?,?)").run(email, name, role, hash(pw), Date.now());
      return json(res, 200, { ok: true, token: startSession(req, res, Number(r.lastInsertRowid)) });
    }
    if (p === "/api/login" && m === "POST") {
      if (authLimited(req)) return json(res, 429, { error: "Слишком много попыток. Подождите минуту." });
      const row = Q("SELECT id,pass FROM users WHERE email=?").get(str(b.email, 100).toLowerCase());
      if (!row || !check(String(b.password || ""), row.pass)) return json(res, 401, { error: "Неверный email или пароль" });
      return json(res, 200, { ok: true, token: startSession(req, res, row.id) });
    }
    if (p === "/api/logout" && m === "POST") {
      const c = /(?:^|; )sid=([a-f0-9]{64})/.exec(req.headers.cookie || ""); if (c) Q("DELETE FROM sessions WHERE token=?").run(sha(c[1]));
      res.setHeader("Set-Cookie", "sid=; HttpOnly; Path=/; Max-Age=0"); return json(res, 200, { ok: true });
    }
    // Отзывы
    if (p === "/api/reviews" && m === "GET") {
      const mmsi = parseInt(u.searchParams.get("mmsi")); if (!mmsi) return json(res, 400, { error: "Нужен mmsi" });
      const st = Q("SELECT AVG(rating) a, COUNT(*) c FROM reviews WHERE mmsi=? AND hidden=0").get(mmsi);
      const items = Q("SELECT r.id,r.rating,r.text,r.created,u.name FROM reviews r JOIN users u ON u.id=r.user WHERE r.mmsi=? AND r.hidden=0 ORDER BY r.created DESC LIMIT 50").all(mmsi);
      return json(res, 200, { avg: st.a || 0, count: st.c, items });
    }
    if (p === "/api/reviews" && m === "POST") {
      if (!me) return need();
      const mmsi = parseInt(b.mmsi), rating = parseInt(b.rating), text = str(b.text, 1000);
      if (!mmsi || !(rating >= 1 && rating <= 5)) return json(res, 400, { error: "Выберите оценку от 1 до 5" });
      if (text.length < 10) return json(res, 400, { error: "Напишите отзыв хотя бы из 10 символов" });
      Q("INSERT INTO reviews(mmsi,ship,user,rating,text,created) VALUES(?,?,?,?,?,?) ON CONFLICT(mmsi,user) DO UPDATE SET rating=excluded.rating,text=excluded.text,created=excluded.created")
        .run(mmsi, str(b.ship, 80), me.id, rating, text, Date.now());
      return json(res, 200, { ok: true });
    }
    let x = /^\/api\/reviews\/(\d+)\/report$/.exec(p);
    if (x && m === "POST") {
      if (!me) return need();
      Q("INSERT OR IGNORE INTO reports(review,user) VALUES(?,?)").run(+x[1], me.id);
      const n = Q("SELECT COUNT(*) c FROM reports WHERE review=?").get(+x[1]).c;
      Q("UPDATE reviews SET reports=?, hidden=CASE WHEN ?>=3 THEN 1 ELSE hidden END WHERE id=?").run(n, n, +x[1]);
      return json(res, 200, { ok: true });
    }
    // Вакансии
    if (p === "/api/jobs" && m === "GET")
      return json(res, 200, Q("SELECT j.id,j.title,j.rank,j.ship_type,j.salary,j.contact,j.descr,j.created,u.name agency FROM jobs j JOIN users u ON u.id=j.user WHERE j.status='approved' ORDER BY j.created DESC LIMIT 100").all());
    if (p === "/api/jobs" && m === "POST") {
      if (!me) return need();
      if (me.role !== "agency") return json(res, 403, { error: "Объявления могут публиковать только агентства" });
      const j = { title: str(b.title, 100), rank: str(b.rank, 60), st: str(b.shipType, 60), salary: str(b.salary, 60), contact: str(b.contact, 100), descr: str(b.description, 2000) };
      if (j.title.length < 5 || j.descr.length < 20 || j.contact.length < 5) return json(res, 400, { error: "Заполните название, описание (от 20 символов) и контакт" });
      if (Q("SELECT COUNT(*) c FROM jobs WHERE user=? AND status='pending'").get(me.id).c >= 5) return json(res, 429, { error: "Слишком много объявлений на проверке" });
      Q("INSERT INTO jobs(user,title,rank,ship_type,salary,contact,descr,created) VALUES(?,?,?,?,?,?,?,?)").run(me.id, j.title, j.rank, j.st, j.salary, j.contact, j.descr, Date.now());
      return json(res, 200, { ok: true });
    }
    if (p === "/api/apply" && m === "POST") {
      if (!me) return need();
      if (me.role !== "seaman") return json(res, 403, { error: "Откликаться могут только моряки" });
      const jid = parseInt(b.job), msg = str(b.message, 500);
      if (!Q("SELECT 1 FROM jobs WHERE id=? AND status='approved'").get(jid)) return json(res, 404, { error: "Вакансия не найдена" });
      Q("INSERT OR IGNORE INTO applications(job,user,message,created) VALUES(?,?,?,?)").run(jid, me.id, msg, Date.now());
      return json(res, 200, { ok: true });
    }
    if (p === "/api/my/applications" && m === "GET") {
      if (!me) return need();
      return json(res, 200, Q("SELECT a.id,a.status,a.created,j.title FROM applications a JOIN jobs j ON j.id=a.job WHERE a.user=? ORDER BY a.created DESC").all(me.id));
    }
    if (p === "/api/my/applicants" && m === "GET") {
      if (!me) return need();
      if (me.role !== "agency") return json(res, 403, { error: "Только для агентств" });
      return json(res, 200, Q("SELECT a.id,a.status,a.message,a.created,j.title,u.name,u.email FROM applications a JOIN jobs j ON j.id=a.job JOIN users u ON u.id=a.user WHERE j.user=? ORDER BY a.created DESC LIMIT 100").all(me.id));
    }
    // Модерация
    if (p.startsWith("/api/admin/")) {
      if (!admin) return json(res, 403, { error: "Нет доступа" });
      if (p === "/api/admin/queue") return json(res, 200, {
        jobs: Q("SELECT j.id,j.title,j.descr,j.contact,u.name agency,u.email FROM jobs j JOIN users u ON u.id=j.user WHERE j.status='pending' ORDER BY j.created").all(),
        reviews: Q("SELECT id,ship,text,reports,hidden FROM reviews WHERE reports>0 OR hidden=1 ORDER BY reports DESC LIMIT 50").all() });
      x = /^\/api\/admin\/jobs\/(\d+)$/.exec(p);
      if (x && m === "POST") { Q("UPDATE jobs SET status=? WHERE id=?").run(b.action === "approve" ? "approved" : "rejected", +x[1]); return json(res, 200, { ok: true }); }
      x = /^\/api\/admin\/reviews\/(\d+)$/.exec(p);
      if (x && m === "POST") { Q("UPDATE reviews SET hidden=?, reports=CASE WHEN ?=0 THEN 0 ELSE reports END WHERE id=?").run(b.action === "hide" ? 1 : 0, b.action === "hide" ? 1 : 0, +x[1]); return json(res, 200, { ok: true }); }
    }
    // Список крюингов
    if (p === "/api/agencies" && m === "GET")
      return json(res, 200, Q("SELECT id,name,email,created FROM users WHERE role='agency' ORDER BY created DESC LIMIT 100").all());

    // Отзывы о крюингах
    if (p === "/api/agency/reviews" && m === "GET") {
      const agency = parseInt(u.searchParams.get("agency"));
      if (!agency) return json(res, 400, { error: "Нужен id агентства" });
      const st = Q("SELECT AVG(rating) a, COUNT(*) c FROM agency_reviews WHERE agency=?").get(agency);
      const items = Q("SELECT r.id,r.rating,r.text,r.created,u.name FROM agency_reviews r JOIN users u ON u.id=r.user WHERE r.agency=? ORDER BY r.created DESC LIMIT 50").all(agency);
      return json(res, 200, { avg: st.a || 0, count: st.c, items });
    }
    if (p === "/api/agency/reviews" && m === "POST") {
      if (!me) return need();
      if (me.role !== "seaman") return json(res, 403, { error: "Отзывы могут оставлять только моряки" });
      const agency = parseInt(b.agency), rating = parseInt(b.rating), text = str(b.text, 1000);
      if (!agency || !(rating >= 1 && rating <= 5)) return json(res, 400, { error: "Выберите оценку от 1 до 5" });
      if (text.length < 10) return json(res, 400, { error: "Текст от 10 символов" });
      Q("INSERT INTO agency_reviews(agency,user,rating,text,created) VALUES(?,?,?,?,?) ON CONFLICT(agency,user) DO UPDATE SET rating=excluded.rating,text=excluded.text,created=excluded.created")
        .run(agency, me.id, rating, text, Date.now());
      return json(res, 200, { ok: true });
    }

    if (p === "/api/me/avatar" && m === "POST") {
      if (!me) return need();
      const data = str(b.avatar, 500000);
      if (!data.startsWith("data:image/")) return json(res, 400, { error: "Нужно изображение" });
      Q("UPDATE users SET avatar=? WHERE id=?").run(data, me.id);
      return json(res, 200, { ok: true });
    }
    if (p === "/api/me" && m === "GET") {
      if (!me) return need();
      const u = Q("SELECT id,email,name,role,avatar FROM users WHERE id=?").get(me.id);
      return json(res, 200, u);
    }

    if (p === "/api/me/profile" && m === "POST") {
      if (!me) return need();
      Q("UPDATE users SET seaman_rank=?, experience=?, vessel_type=?, nationality=?, phone=? WHERE id=?")
        .run(str(b.rank,100), str(b.experience,200), str(b.vessel_type,100), str(b.nationality,50), str(b.phone,30), me.id);
      return json(res, 200, { ok: true });
    }
    return json(res, 404, { error: "Не найдено" });
  } catch (e) { console.error(e); return json(res, 400, { error: "Некорректный запрос" }); }
};
