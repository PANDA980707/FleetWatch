import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Политика конфиденциальности', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'FleetWatch',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text(
            '1. Какие данные мы собираем\n'
            'При регистрации: email, имя, роль (моряк / крюинг). '
            'При заполнении анкеты: должность, опыт, тип судна, гражданство, телефон. '
            'При загрузке фото: изображение профиля.\n\n'
            '2. Как используем\n'
            'Данные используются для работы сервиса: публикация вакансий, отклики, отзывы, отображение профиля.\n\n'
            '3. Хранение\n'
            'Данные хранятся на сервере FleetWatch. Мы не продаём и не передаём их третьим лицам.\n\n'
            '4. Удаление\n'
            'Вы можете удалить аккаунт, написав на support@fleetwatch.app.\n\n'
            '5. Контакты\n'
            'По вопросам конфиденциальности: support@fleetwatch.app',
            style: TextStyle(color: Colors.white70, height: 1.5),
          ),
        ],
      ),
    );
  }
}
