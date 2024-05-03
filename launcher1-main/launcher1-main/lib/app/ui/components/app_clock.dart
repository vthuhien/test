import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppClock extends StatefulWidget {
  const AppClock({super.key});

  @override
  State<AppClock> createState() => _AppClockState();
}

class _AppClockState extends State<AppClock> {
  String? _timeString;
  String? _dateString;
  Timer? _timer;

  @override
  void initState() {
    final now = DateTime.now();
    _timeString = _formatTime(now);
    _dateString = _formatDate(now);

    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (Timer t) => _getTime(),
    );
    super.initState();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedTime = _formatTime(now);
    final String formattedDate = _formatDate(now);
    setState(() {
      _timeString = formattedTime;
      _dateString = formattedDate;
    });
  }

  String _formatTime(DateTime dateTime) => DateFormat('HH:mm').format(dateTime);
  String _formatDate(DateTime dateTime) =>
      DateFormat('dd MMM').format(dateTime);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 48, right: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.contain,
            child: Text(
              _timeString ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 400.0,
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.contain,
            child: Text(
              _dateString ?? '',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 30.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
