
import 'package:flutter/material.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final _title = TextEditingController();
  final _sum = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Приход')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(decoration: const InputDecoration(labelText: 'Поставщик/позиция'), controller: _title),
            const SizedBox(height: 12),
            TextField(decoration: const InputDecoration(labelText: 'Сумма, ₽'), controller: _sum, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            ElevatedButton.icon(onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Приход сохранён (локально).')));
              _title.clear(); _sum.clear();
            }, icon: const Icon(Icons.check), label: const Text('Сохранить'))
          ],
        ),
      ),
    );
  }
}
