import 'package:flutter/material.dart';

class SeaTimeScreen extends StatefulWidget {
  const SeaTimeScreen({super.key});

  @override
  State<SeaTimeScreen> createState() => _SeaTimeScreenState();
}

class _SeaTimeScreenState extends State<SeaTimeScreen> {
  final Map<String, double> _requirements = {
    'Chief Officer / Капитан': 18,
    'Second Officer / Старший помощник': 12,
    'Chief Engineer / Старший механик': 18,
    'ETO / Электромеханик': 12,
  };

  double _monthsInService = 18;
  String _selectedRank = 'Chief Officer / Капитан';

  @override
  Widget build(BuildContext context) {
    final requirement = _requirements[_selectedRank] ?? 12;
    final metRequirement = _monthsInService >= requirement;
    final missing = (requirement - _monthsInService).clamp(0, 100).toInt();

    return Scaffold(
      backgroundColor: const Color(0xFF0B132B),
      appBar: AppBar(
        title: const Text(
          'Калькулятор Плавценза',
          style: TextStyle(
            color: Color(0xFF00FF87),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1C2541),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Расчет стажа для повышения диплома',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Укажите должность и суммарный наплаванный стаж в месяцах.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C2541),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF00FF87).withOpacity(0.3)),
                ),
                child: DropdownButton<String>(
                  value: _selectedRank,
                  isExpanded: true,
                  underline: const SizedBox(),
                  dropdownColor: const Color(0xFF1C2541),
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  items: _requirements.keys.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() => _selectedRank = newValue);
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Наплаванный стаж: ${_monthsInService.toStringAsFixed(0)} месяцев',
                style: const TextStyle(
                  color: Color(0xFF00FF87),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Slider(
                value: _monthsInService,
                min: 0,
                max: 36,
                divisions: 36,
                activeColor: const Color(0xFF00FF87),
                inactiveColor: Colors.white24,
                label: '${_monthsInService.round()} мес.',
                onChanged: (value) {
                  setState(() => _monthsInService = value);
                },
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C2541),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: metRequirement
                        ? const Color(0xFF00FF87)
                        : const Color(0xFFFFB703),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📊 Статус соответствия требований',
                      style: TextStyle(
                        color: Color(0xFF00F2FE),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      metRequirement
                          ? '✅ Ценз достаточен для подачи документов на подтверждение диплома.'
                          : '⚠️ Не хватает $missing месяцев до необходимого минимума для ${_selectedRank}.',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Требуется: ${requirement.toInt()} мес.',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
