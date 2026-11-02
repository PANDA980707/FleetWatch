import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

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
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('Калькулятор плавцена'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.panel,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Расчёт стажа для повышения диплома',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Укажите должность и суммарный наплаванный стаж в месяцах.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.panel,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButton<String>(
                  value: _selectedRank,
                  isExpanded: true,
                  underline: const SizedBox(),
                  dropdownColor: AppColors.panelAlt,
                  style: const TextStyle(color: AppColors.textPrimary),
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
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.panel,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Наплаванный стаж: ${_monthsInService.toStringAsFixed(0)} месяцев',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.emerald,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Slider(
                      value: _monthsInService,
                      min: 0,
                      max: 36,
                      divisions: 36,
                      activeColor: AppColors.emerald,
                      inactiveColor: AppColors.border,
                      label: '${_monthsInService.round()} мес.',
                      onChanged: (value) {
                        setState(() => _monthsInService = value);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: metRequirement ? AppColors.emerald.withOpacity(0.08) : AppColors.amber.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: metRequirement ? AppColors.emerald : AppColors.amber,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      metRequirement ? '✅ Требование выполнено' : '⚠️ Не хватает стажа',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: metRequirement ? AppColors.emerald : AppColors.amber,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      metRequirement
                          ? 'Ценз достаточен для подачи документов на подтверждение диплома.'
                          : 'Не хватает $missing месяцев до необходимого минимума для $_selectedRank.',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Требуется: ${requirement.toInt()} мес.',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
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
