
import 'package:flutter/material.dart';
import '../services/api.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  List<Map<String, dynamic>> rows = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    TabachkiApi.fetchEmployees().then((r){ setState((){ rows=r; loading=false; }); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сотрудники')),
      body: loading ? const Center(child: CircularProgressIndicator()) :
        ListView.separated(
          itemCount: rows.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (c, i){
            final r = rows[i];
            return ListTile(
              leading: CircleAvatar(child: Text(((r['name'] ?? ' ')[0]))),
              title: Text(r['name'] ?? ''),
              subtitle: Text('Роль: ${r['role'] ?? ''}  •  Магазин: ${r['storeId'] ?? ''}'),
              trailing: Text('Баллы: ${r['score'] ?? 0}'),
            );
          },
        ),
    );
  }
}
