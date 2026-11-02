// Ship Info: лёгкий сервер. Принимает AIS-поток aisstream.io и отдаёт данные приложению.
// Запуск: npm install ws && AISSTREAM_API_KEY=ваш_ключ node server.js
const http = require("http"), fs = require("fs"), path = require("path");
const WebSocket = require("ws");
const community = require("./community");

const KEY = process.env.AISSTREAM_API_KEY;
const PORT = process.env.PORT || 3000;
// Область подписки: по умолчанию весь мир. Пример: BBOX='[[54,5],[62,25]]' (Балтика)
const BOX = process.env.BBOX ? JSON.parse(process.env.BBOX) : [[-90, -180], [90, 180]];
if (!KEY) { console.error("Задайте переменную AISSTREAM_API_KEY"); process.exit(1); }

const ships = new Map();
const MAX_AGE = 30 * 60 * 1000;
const MAX_SHIPS = 60000;

function typeName(t) {
  if (t >= 70 && t <= 79) return "Грузовое";
  if (t >= 80 && t <= 89) return "Танкер";
  if (t >= 60 && t <= 69) return "Пассажирское";
  if (t === 30) return "Рыболовное";
  if (t === 31 || t === 32 || t === 52) return "Буксир";
  if (t === 36 || t === 37) return "Яхта";
  return "Другое";
}
const NAV = { 0: "Идёт своим ходом", 1: "На якоре", 2: "Без управления", 3: "Ограничено в маневре", 5: "У причала", 7: "Лов рыбы", 8: "Идёт под парусом" };

function pub(s) {
  return {
    mmsi: s.mmsi, imo: s.imo || null, name: s.name || "Без названия", type: typeName(s.type),
    lat: s.lat, lon: s.lon, speed: s.sog, course: s.cog, heading: s.hdg,
    status: NAV[s.nav] || "Нет данных", dest: s.dest || null, length: s.len || null,
    width: s.wid || null, draught: s.draught || null, eta: s.eta || null, seen: s.seen
  };
}

function connect() {
  const ws = new WebSocket("wss://stream.aisstream.io/v0/stream");
  ws.on("open", () => {
    console.log("Подключено к aisstream.io");
    ws.send(JSON.stringify({ APIKey: KEY, BoundingBoxes: [BOX], FilterMessageTypes: ["PositionReport", "ShipStaticData"] }));
  });
  ws.on("message", (data) => {
    let m; try { m = JSON.parse(data); } catch { return; }
    const meta = m.MetaData; if (!meta) return;
    const s = ships.get(meta.MMSI) || { mmsi: meta.MMSI };
    s.seen = Date.now();
    if (m.MessageType === "PositionReport") {
      const p = m.Message.PositionReport;
      s.lat = p.Latitude; s.lon = p.Longitude; s.sog = p.Sog; s.cog = p.Cog; s.hdg = p.TrueHeading; s.nav = p.NavigationalStatus;
      if (meta.ShipName && meta.ShipName.trim()) s.name = meta.ShipName.trim();
    } else if (m.MessageType === "ShipStaticData") {
      const p = m.Message.ShipStaticData;
      s.imo = p.ImoNumber || s.imo; s.type = p.Type; s.dest = (p.Destination || "").trim();
      if (p.Name && p.Name.trim()) s.name = p.Name.trim();
      if (p.Dimension) { s.len = p.Dimension.A + p.Dimension.B; s.wid = p.Dimension.C + p.Dimension.D; }
      s.draught = p.MaximumStaticDraught; s.eta = p.Eta;
    }
    if (ships.has(meta.MMSI) || ships.size < MAX_SHIPS) ships.set(meta.MMSI, s);
  });
  ws.on("close", () => { console.log("Соединение закрыто, повтор через 5 с"); setTimeout(connect, 5000); });
  ws.on("error", (e) => console.error("Ошибка:", e.message));
}
connect();
setInterval(() => { const t = Date.now() - MAX_AGE; for (const [k, s] of ships) if (s.seen < t) ships.delete(k); }, 60000);

const PUB = path.join(__dirname, "public");
const FILES = { "/": "index.html", "/index.html": "index.html", "/manifest.webmanifest": "manifest.webmanifest", "/sw.js": "sw.js", "/icon-192.png": "icon-192.png", "/icon-512.png": "icon-512.png" };
const TYPES = { html: "text/html; charset=utf-8", webmanifest: "application/manifest+json", js: "text/javascript", png: "image/png" };
const cache = {};
// Карта: для публичного приложения замените тайлы OSM на коммерческий провайдер (см. README)
const TILE_URL = process.env.TILE_URL || "https://tile.openstreetmap.org/{z}/{x}/{y}.png";
const TILE_ATTR = process.env.TILE_ATTR || "© OpenStreetMap";
const hits = new Map();
setInterval(() => hits.clear(), 60000);
const limited = (req) => {
  const ip = (req.headers["x-forwarded-for"] || req.socket.remoteAddress || "").split(",")[0].trim();
  const n = (hits.get(ip) || 0) + 1; hits.set(ip, n); return n > 120; // 120 запросов в минуту с одного адреса
};
const json = (res, code, body, maxAge) => {
  res.writeHead(code, { "Content-Type": "application/json; charset=utf-8", "Access-Control-Allow-Origin": "*", "Cache-Control": "public, max-age=" + (maxAge || 0), "X-Content-Type-Options": "nosniff" });
  res.end(JSON.stringify(body));
};

http.createServer((req, res) => {
  try {
    const u = new URL(req.url, "http://x");
    if (u.pathname === "/health") return json(res, 200, { ok: true, ships: ships.size });
    if (u.pathname === "/config.json") return json(res, 200, { tileUrl: TILE_URL, attr: TILE_ATTR }, 3600);
    if (u.pathname.startsWith("/api/")) {
      if (limited(req)) return json(res, 429, { error: "Слишком много запросов. Подождите минуту." });
      if (u.pathname === "/api/ships") { // ?bbox=minLat,minLon,maxLat,maxLon
        const b = (u.searchParams.get("bbox") || "-90,-180,90,180").split(",").map(Number);
        if (b.length !== 4 || b.some(isNaN)) return json(res, 400, { error: "Неверный bbox" });
        const out = [];
        for (const s of ships.values()) {
          if (s.lat == null || s.lat < b[0] || s.lat > b[2] || s.lon < b[1] || s.lon > b[3]) continue;
          out.push(pub(s)); if (out.length >= 1500) break;
        }
        return json(res, 200, out, 5);
      }
      if (u.pathname === "/api/search") { // ?q=название|IMO|MMSI
        const q = (u.searchParams.get("q") || "").trim().toLowerCase().slice(0, 40);
        if (q.length < 3) return json(res, 200, []);
        const out = [];
        for (const s of ships.values()) {
          if (s.lat == null) continue;
          if ((s.name || "").toLowerCase().includes(q) || String(s.mmsi).includes(q) || String(s.imo || "").includes(q)) out.push(pub(s));
          if (out.length >= 20) break;
        }
        return json(res, 200, out, 5);
      }
      return community(req, res, u, json);
    }
    const f = FILES[u.pathname];
    if (f) {
      if (!cache[f]) cache[f] = fs.readFileSync(path.join(PUB, f));
      res.writeHead(200, { "Content-Type": TYPES[f.split(".").pop()], "X-Content-Type-Options": "nosniff", "Referrer-Policy": "no-referrer", "Cache-Control": f === "sw.js" ? "no-cache" : "public, max-age=3600" });
      return res.end(cache[f]);
    }
    json(res, 404, { error: "Не найдено" });
  } catch (e) { console.error(e); json(res, 500, { error: "Ошибка сервера" }); }
}).listen(PORT, () => console.log("Ship Info: http://localhost:" + PORT));
process.on("uncaughtException", (e) => console.error("uncaught:", e));
process.on("unhandledRejection", (e) => console.error("unhandled:", e));
