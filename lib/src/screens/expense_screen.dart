
import 'package:flutter/material.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final _title = TextEditingController();
  final _sum = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Расход')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(decoration: const InputDecoration(labelText: 'Статья расхода'), controller: _title),
            const SizedBox(height: 12),
            TextField(decoration: const InputDecoration(labelText: 'Сумма, ₽'), controller: _sum, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            ElevatedButton.icon(onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Расход сохранён (локально).')));
              _title.clear(); _sum.clear();
            }, icon: const Icon(Icons.check), label: const Text('Сохранить'))
          ],
        ),
      ),
    );
  }
}
