import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:launcher1/gen/assets.gen.dart';

// https://github.com/mabDc/eso/blob/f41ce76b5bd690638c3a53518b29309d1317c532/lib/model/system_info_provider.dart#L4
// https://github.com/cgarwood/controlly-flutter/blob/9c5a5e1b72cf7789c5cd78a3f80e00e27d5887d5/lib/device_details.dart#L4

class StatusBar extends StatefulWidget {
  final bool showClock;

  const StatusBar({super.key, required this.showClock});

  @override
  State<StatusBar> createState() => _StatusBarState();
}

class _StatusBarState extends State<StatusBar> {
  final _format = DateFormat('HH:mm');

  Timer? _timer;

  int _battetyLevel = 100;
  String? _nowTime;

  void setStateIfMounted(VoidCallback f) {
    if (mounted) setState(f);
  }

  @override
  void initState() {
    _nowTime = _format.format(DateTime.now());
    _init();
    super.initState();
  }

  Future<bool> _init() async {
    _timer = Timer.periodic(const Duration(milliseconds: 300), (_) async {
      _nowTime = _format.format(DateTime.now());
      _battetyLevel = await Battery().batteryLevel;
      setStateIfMounted(() => ());
    });
    return true;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var batteryImg = Assets.images.icBattery3;
    if (_battetyLevel < 12) batteryImg = Assets.images.icBattery0;
    if (_battetyLevel < 31) batteryImg = Assets.images.icBattery1;
    if (_battetyLevel < 76) batteryImg = Assets.images.icBattery2;
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.showClock)
            Text(
              _nowTime.toString(),
              style: const TextStyle(
                color: Colors.white54,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          const Spacer(),
          SvgPicture.asset(
            batteryImg,
            height: 38,
            width: 38,
            colorFilter: const ColorFilter.mode(
              Colors.white54,
              BlendMode.srcATop,
            ),
          ),
        ],
      ),
    );
  }
}
