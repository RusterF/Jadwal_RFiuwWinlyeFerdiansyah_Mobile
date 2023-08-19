import 'package:flutter/material.dart';

void main() {
  runApp(const ScheduleApp());
}

class ScheduleApp extends StatelessWidget {
  const ScheduleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schedule App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const ScheduleScreen(),
    );
  }
}

class ScheduleItem {
  final String title;
  final TimeOfDay time;
  final DateTime date;

  ScheduleItem({required this.title, required this.time, required this.date});
}

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<ScheduleItem> scheduleItems = [];
  final TextEditingController _scheduleItemController = TextEditingController();
  TimeOfDay? _selectedTime;
  DateTime? _selectedDate;

  void _addScheduleItem(String item, TimeOfDay time, DateTime date) {
    setState(() {
      scheduleItems.add(ScheduleItem(title: item, time: time, date: date));
      _scheduleItemController.clear();
      _selectedTime = null;
      _selectedDate = null;
    });
  }

  void _removeScheduleItem(int index) {
    setState(() {
      scheduleItems.removeAt(index);
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = pickedDate;
          _selectedTime = pickedTime;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: scheduleItems.length,
              itemBuilder: (context, index) {
                final item = scheduleItems[index];
                return ListTile(
                  title: Text(
                      '${item.title} (${item.date.day}/${item.date.month}/${item.date.year} ${item.time.format(context)})'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_forever_rounded),
                    onPressed: () {
                      _removeScheduleItem(index);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _scheduleItemController,
                    decoration:
                        const InputDecoration(labelText: 'Masukkan kegiatan'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.date_range_rounded),
                  onPressed: () {
                    _selectTime(context);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_scheduleItemController.text.isNotEmpty &&
                        _selectedTime != null &&
                        _selectedDate != null) {
                      _addScheduleItem(
                        _scheduleItemController.text,
                        _selectedTime!,
                        _selectedDate!,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
