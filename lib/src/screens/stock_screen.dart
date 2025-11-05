
import 'package:flutter/material.dart';
import '../services/api.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  List<Map<String, dynamic>> rows = [];
  bool loading = true;

  Future<void> _load() async {
    final data = await TabachkiApi.fetchStock();
    setState(() { rows = data; loading = false; });
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Остатки')),
      body: loading ? const Center(child: CircularProgressIndicator()) :
        ListView.separated(
          itemCount: rows.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (c, i){
            final r = rows[i];
            final zero = (r['qty'] ?? 0) == 0;
            return ListTile(
              title: Text(r['name'] ?? ''),
              subtitle: Text('Штрихкод: ${r['barcode'] ?? ''}'),
              trailing: Text('${r['qty']} шт', style: TextStyle(color: zero ? Colors.red : null)),
            );
          },
        ),
    );
  }
}
