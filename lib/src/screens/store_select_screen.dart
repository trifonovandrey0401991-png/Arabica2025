
import 'package:flutter/material.dart';
import '../services/api.dart';

class StoreSelectScreen extends StatefulWidget {
  final void Function(String id, String name) onSelected;
  const StoreSelectScreen({super.key, required this.onSelected});

  @override
  State<StoreSelectScreen> createState() => _StoreSelectScreenState();
}

class _StoreSelectScreenState extends State<StoreSelectScreen> {
  List<Map<String, dynamic>> rows = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    TabachkiApi.listStores().then((r){ setState((){ rows=r; loading=false; }); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Выберите магазин')),
      body: loading ? const Center(child: CircularProgressIndicator()) :
        ListView.separated(
          itemCount: rows.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (c, i){
            final r = rows[i];
            return ListTile(
              title: Text(r['name'] ?? 'Магазин'),
              subtitle: Text('ID: ${r['id']}  •  ${r['city'] ?? ''}'),
              onTap: () => widget.onSelected('${r['id']}', r['name'] ?? 'Магазин'),
            );
          },
        ),
    );
  }
}
