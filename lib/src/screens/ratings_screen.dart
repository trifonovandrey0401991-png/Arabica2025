
import 'package:flutter/material.dart';
import '../services/api.dart';

class RatingsScreen extends StatefulWidget {
  const RatingsScreen({super.key});

  @override
  State<RatingsScreen> createState() => _RatingsScreenState();
}

class _RatingsScreenState extends State<RatingsScreen> {
  List<Map<String, dynamic>> rows = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    TabachkiApi.listRatings().then((r){ setState((){ rows=r; loading=false; }); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Рейтинг сотрудников')),
      body: loading ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
          itemCount: rows.length,
          itemBuilder: (c, i){
            final r = rows[i];
            return ListTile(
              leading: CircleAvatar(child: Text('${i+1}')),
              title: Text(r['user'] ?? ''),
              subtitle: Text('Магазин: ${r['storeId'] ?? ''}'),
              trailing: Text('${r['score'] ?? 0} баллов'),
            );
          },
        ),
    );
  }
}
