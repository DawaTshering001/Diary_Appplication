import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class ReminderPage extends StatefulWidget {
  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  TimeOfDay? _time;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    tz.initializeTimeZones(); // Initialize timezones
  }

  // Initialize local notifications
  void _initializeNotifications() async {
    var androidInitialize = AndroidInitializationSettings('app_icon'); // Ensure app_icon is present in assets
    var initializationSettings = InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Schedule a reminder notification
  Future<void> _scheduleReminder() async {
    if (_time != null) {
      final now = DateTime.now();
      final scheduledTime = DateTime(now.year, now.month, now.day, _time!.hour, _time!.minute);

      // Get the local timezone
      final localTimezone = tz.getLocation('Asia/Kolkata'); // Adjust this according to your region

      // Convert the DateTime to TZDateTime
      final tzDateTime = tz.TZDateTime.from(scheduledTime, localTimezone);

      var androidDetails = AndroidNotificationDetails(
        'reminder_channel',
        'Reminder Notifications',
        channelDescription: 'Channel for daily diary reminders',
        importance: Importance.high,
        priority: Priority.high,
        enableVibration: true, // Vibrates when notification is triggered
        playSound: true, // Play sound on notification
      );

      var platformDetails = NotificationDetails(android: androidDetails);

      // Schedule the notification
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Diary Reminder',
        'It\'s time to write in your diary!',
        tzDateTime,
        platformDetails,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
        matchDateTimeComponents: DateTimeComponents.time,
        androidScheduleMode: AndroidScheduleMode.exact,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reminder set for ${_time!.format(context)}')),
      );
    }
  }

  // Open time picker and set reminder
  Future<void> _pickTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null && time != _time) {
      setState(() {
        _time = time;
      });
      _scheduleReminder(); // Automatically set reminder after time is picked
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Reminder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Set a reminder for your diary entry!'),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _pickTime,
              child: Text(
                _time == null ? 'Pick Time' : 'Time: ${_time!.format(context)}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
