import 'package:flutter/material.dart';

class SeaTimeScreen extends StatefulWidget {
  const SeaTimeScreen({Key? key}) : super(key: key);

  @override
  _SeaTimeScreenState createState() => _SeaTimeScreenState();
}

class _SeaTimeScreenState extends State<SeaTimeScreen> {
  double _monthsInService = 18.0;
  String _selectedRank = 'Chief Officer / Капитан';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Калькулятор Плавценза', style: TextStyle(color: Color(0xFF00FF87))),
        backgroundColor: const Color(0xFF1C2541),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Расчет стажа для повышения диплома',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Укажите текущую должность и суммарный наплаванный контрактный срок в месяцах.',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1C2541),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF00FF87).withOpacity(0.3)),
              ),
              child: DropdownButton<String>(
                value: _selectedRank,
                isExpanded: true,
                dropdownColor: const Color(0xFF1C2541),
                underline: const SizedBox(),
                style: const TextStyle(color: Colors.white, fontSize: 16),
                items: <String>[
                  'Chief Officer / Капитан',
                  'Second Officer / Помощник',
                  'Chief Engineer / Стармех',
                  'ETO / Электромеханик',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRank = newValue!;
                  });
                },
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Наплаванный стаж: ${_monthsInService.toStringAsFixed(0)} месяцев',
              style: const TextStyle(color: Color(0xFF00FF87), fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _monthsInService,
              min: 1,
              max: 36,
              divisions: 35,
              activeColor: const Color(0xFF00FF87),
              inactiveColor: Colors.white24,
              label: '${_monthsInService.round()} мес.',
              onChanged: (double value) {
                setState(() {
                  _monthsInService = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1C2541).withOpacity(0.6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF00F2FE).withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📊 Статус соответствия требованиям:',
                    style: TextStyle(color: Color(0xFF00F2FE), fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _monthsInService >= 12
                        ? '✅ Ценз достаточен для подачи документов на подтверждение высшего рабочего диплома.'
                        : '⚠️ Требуется еще ${(12 - _monthsInService).toStringAsFixed(0)} мес. ценза для подачи в капитанцию.',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
