
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api.dart';

class ZReportScreen extends StatefulWidget {
  const ZReportScreen({super.key});

  @override
  State<ZReportScreen> createState() => _ZReportScreenState();
}

class _ZReportScreenState extends State<ZReportScreen> {
  final _rev = TextEditingController();
  final _exp = TextEditingController();
  String? _lastSent;
  String storeId = 'S1';
  String user = 'Продавец';

  Future<void> _send() async {
    final ok = await TabachkiApi.sendZReport(
      user: user, storeId: storeId, shift: 'Дневная',
      revenue: _rev.text, expense: _exp.text, comment: '',
    );
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final summary = 'OK:$ok | Выручка: ${_rev.text} / Расходы: ${_exp.text} / ${now.toString()}';
    await prefs.setString('z_report_last', summary);
    setState(() => _lastSent = summary);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ok ? 'Z-отчёт отправлен' : 'Ошибка отправки')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((p) {
      setState(() => _lastSent = p.getString('z_report_last'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Z-отчёт')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _rev, decoration: const InputDecoration(labelText: 'Выручка, ₽', prefixIcon: Icon(Icons.attach_money)), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            TextField(controller: _exp, decoration: const InputDecoration(labelText: 'Расходы, ₽', prefixIcon: Icon(Icons.money_off)), keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            ElevatedButton.icon(onPressed: _send, icon: const Icon(Icons.check), label: const Text('Отправить')),
            const SizedBox(height: 24),
            Align(alignment: Alignment.centerLeft, child: Text('Последний отчёт:\n${_lastSent ?? '—'}')),
          ],
        ),
      ),
    );
  }
}
