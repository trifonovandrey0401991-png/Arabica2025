
import 'package:flutter/material.dart';
import 'photo_screen.dart';
import 'z_report_screen.dart';
import 'stock_screen.dart';
import 'expense_screen.dart';
import 'income_screen.dart';
import 'employees_screen.dart';
import 'inventory_screen.dart';
import 'store_select_screen.dart';
import 'shift_screen.dart';
import 'ratings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? storeId;
  String storeName = '—';
  String userName = 'Продавец';

  void _pickStore() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) =>
      StoreSelectScreen(onSelected: (id, name){
        setState(() { storeId = id; storeName = name; });
        Navigator.pop(context);
      })));
  }

  void _openShift(){
    if (storeId==null) return _pickStore();
    Navigator.push(context, MaterialPageRoute(builder: (_) => ShiftScreen(storeId: storeId!, user: userName)));
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      _I('Выбрать магазин', Icons.store, _pickStore),
      _I('Смена', Icons.schedule, _openShift),
      _I('Фото витрины', Icons.photo_camera, ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const PhotoScreen()))),
      _I('Z-отчёт', Icons.receipt_long, ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const ZReportScreen()))),
      _I('Приход', Icons.move_to_inbox, ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const IncomeScreen()))),
      _I('Расход', Icons.outbox, ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const ExpenseScreen()))),
      _I('Остатки', Icons.inventory_2, ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const StockScreen()))),
      _I('Сотрудники', Icons.group, ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const EmployeesScreen()))),
      _I('Рейтинг', Icons.emoji_events, ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const RatingsScreen()))),
      _I('Инвентаризация', Icons.checklist, ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const InventoryScreen()))),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Табачки 2.0')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 1.2, crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemCount: items.length,
        itemBuilder: (c,i){
          final it = items[i];
          return InkWell(
            onTap: it.onTap,
            child: Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(it.icon, size: 36), const SizedBox(height: 8), Text(it.title, textAlign: TextAlign.center),
              ])),
            ),
          );
        },
      ),
    );
  }
}
class _I { final String title; final IconData icon; final VoidCallback onTap;
  _I(this.title, this.icon, this.onTap); }
