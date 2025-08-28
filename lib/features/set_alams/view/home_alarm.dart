import 'dart:convert';
import 'package:assignment/common_widgets/custom_button.dart';
import 'package:assignment/common_widgets/custom_text.dart';
import 'package:assignment/constants/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeAlarm extends StatefulWidget {
  const HomeAlarm({super.key});

  @override
  State<HomeAlarm> createState() => _HomeAlarmState();
}

class _HomeAlarmState extends State<HomeAlarm> {
  final String location = "79 Regent's Park Rd, London NW1 8UY, United Kingdom";
  List<Map<String, dynamic>> alarms = [];

  @override
  void initState() {
    super.initState();
    _loadAlarms(); // Load alarms from local storage
    _startAlarmCheck();
  }

  Future<void> _loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final String? alarmsString = prefs.getString('alarms');
    if (alarmsString != null) {
      setState(() {
        alarms = List<Map<String, dynamic>>.from(jsonDecode(alarmsString));
      });
    }
  }

  Future<void> _saveAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('alarms', jsonEncode(alarms));
  }

  void _startAlarmCheck() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      _checkAlarms();
      return true;
    });
  }

  void _checkAlarms() {
    DateTime now = DateTime.now();
    String currentTime =
        "${now.hour % 12}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'pm' : 'am'}";
    for (var alarm in alarms) {
      if (alarm['time'] == currentTime && alarm['isActive']) {
        _showAlarmNotification(alarm['date']);
      }
    }
  }

  void _showAlarmNotification(String date) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alarm!'),
        content: Text(
          'Alarm set for $date has triggered at ${DateTime.now().hour}:${DateTime.now().minute}',
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context); // Closes the dialog
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> addAlarm() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      DateTime now = DateTime.now();
      String time =
          "${pickedTime.hour % 12}:${pickedTime.minute.toString().padLeft(2, '0')} ${pickedTime.hour >= 12 ? 'pm' : 'am'}";
      String date = "Fri ${now.day} ${now.month} ${now.year}";
      setState(() {
        alarms.add({'time': time, 'date': date, 'isActive': true});
      });
      await _saveAlarms();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Text(
                          'Selected Location',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            location,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: addAlarm,
                      child: CustomButton(
                        cardColor: const Color(0xff3C3D3F),
                        title: "Add Alarm",
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              CustomText(
                title: "Alarms",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  itemCount: alarms.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(alarms[index]['time'] + alarms[index]['date']),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) async {
                        setState(() {
                          alarms.removeAt(index);
                        });
                        await _saveAlarms();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Alarm deleted')),
                        );
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              alarms[index]['time'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  alarms[index]['date'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                SizedBox(
                                  width: 40,
                                  height: 20,
                                  child: Transform.scale(
                                    scale: 0.7,
                                    child: Switch(
                                      value: alarms[index]['isActive'],
                                      onChanged: (value) async {
                                        setState(() {
                                          alarms[index]['isActive'] = value;
                                        });
                                        await _saveAlarms();
                                      },
                                      activeColor: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
