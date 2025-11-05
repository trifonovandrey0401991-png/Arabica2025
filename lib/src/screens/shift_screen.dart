
import 'package:flutter/material.dart';
import '../services/api.dart';

class ShiftScreen extends StatefulWidget {
  final String storeId;
  final String user;
  const ShiftScreen({super.key, required this.storeId, required this.user});

  @override
  State<ShiftScreen> createState() => _ShiftScreenState();
}

class _ShiftScreenState extends State<ShiftScreen> {
  String shiftType = 'Дневная';
  bool busy = false;
  String status = '—';

  Future<void> _start() async {
    setState(()=>busy=true);
    final ok = await TabachkiApi.startShift(storeId: widget.storeId, user: widget.user, shiftType: shiftType);
    setState(()=>{busy=false, status = ok ? 'Смена начата' : 'Ошибка'});
  }

  Future<void> _end() async {
    setState(()=>busy=true);
    final ok = await TabachkiApi.endShift(storeId: widget.storeId, user: widget.user, shiftType: shiftType);
    setState(()=>{busy=false, status = ok ? 'Смена закрыта (проверь Z-отчет)' : 'Ошибка'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Смена')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Магазин: ${widget.storeId}'),
            const SizedBox(height: 8),
            Text('Сотрудник: ${widget.user}'),
            const SizedBox(height: 12),
            DropdownButton<String>(
              value: shiftType,
              items: const [
                DropdownMenuItem(value: 'Дневная', child: Text('Дневная')),
                DropdownMenuItem(value: 'Ночная', child: Text('Ночная')),
              ],
              onChanged: (v){ setState(()=>shiftType = v??'Дневная'); },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(onPressed: busy?null:_start, icon: const Icon(Icons.play_arrow), label: const Text('Начать смену')),
                const SizedBox(width: 12),
                ElevatedButton.icon(onPressed: busy?null:_end, icon: const Icon(Icons.stop), label: const Text('Закрыть смену')),
              ],
            ),
            const SizedBox(height: 16),
            Text('Статус: $status'),
          ],
        ),
      ),
    );
  }
}
