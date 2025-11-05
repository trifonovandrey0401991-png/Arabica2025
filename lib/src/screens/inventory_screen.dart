
import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Инвентаризация')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Проверьте остатки и прикрепите фото подтверждения.', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            LinearProgressIndicator(value: null),
            const SizedBox(height: 8),
            const Text('Идёт сверка...'),
            const SizedBox(height: 16),
            FilledButton.icon(onPressed: (){}, icon: const Icon(Icons.send), label: const Text('Отправить отчёт')),
          ],
        ),
      ),
    );
  }
}
