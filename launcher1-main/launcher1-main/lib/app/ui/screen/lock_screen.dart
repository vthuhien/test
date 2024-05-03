import 'dart:async';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:device_policy_manager/device_policy_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:launcher1/app/di/init_di.dart';
import 'package:launcher1/app/ui/components/app_clock.dart';
import 'package:launcher1/feature/lang/app_lang.dart';
import 'package:launcher1/feature/router/domain/app_router.dart';
import 'package:launcher1/feature/status_bar/ui/status_bar.dart';

@RoutePage()
class LockScreen extends StatefulWidget {
  static const String path = '/';

  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    _fn.requestFocus();
  }

  void setStateIfMounted(VoidCallback f) {
    if (mounted) setState(f);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Приложение возобновило работу
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    }
  }

  final FocusNode _fn = FocusNode();

  var _leftKeyClick = 0;

  String _unlockText = AppLang.loc.unlock; // 'Unlock'
  Timer? _comboTimer;
  bool _lockPermissionRequested = false;

  Future<void> _lock() async {
    try {
      /// Return `true` if the given administrator component is currently active (enabled) in the system.
      final status = await DevicePolicyManager.isPermissionGranted();

      if (!status && !_lockPermissionRequested) {
        setStateIfMounted(() => _lockPermissionRequested = true);
        await DevicePolicyManager.requestPermession(
          "Lock Permissions",
        );
      }

      await DevicePolicyManager.lockNow();
    } catch (e) {
      log(e.toString());
    }
  }

  bool _unlock(LogicalKeyboardKey key) {
    const comboSeconds = 3;

    try {
      final now = DateTime.now().millisecondsSinceEpoch;

      switch (key) {
        case LogicalKeyboardKey.select:
          _leftKeyClick = now;
          setStateIfMounted(
              () => _unlockText = context.l10n.pressStar); // 'Press *'
          _comboTimer?.cancel();
          _comboTimer = Timer(const Duration(seconds: comboSeconds), () {
            setStateIfMounted(
                () => _unlockText = context.l10n.unlock); // 'Unlock'
          });
          return false;
        case LogicalKeyboardKey.asterisk: // STAR
          if ((now - _leftKeyClick) < comboSeconds * 1000) {
            log('\n\n!!! UNLOCKED!!!\n\n');
            locator.get<AppRouter>().replace(const HomeRoute());
            return true;
          }
          break;
        case LogicalKeyboardKey.goBack:
        case LogicalKeyboardKey.endCall:
        default:
          _lock();
          return false;
      }
    } on Exception catch (_) {}
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: RawKeyboardListener(
          focusNode: _fn,
          onKey: (value) => _unlock(value.logicalKey),
          child: Stack(
            children: [
              const StatusBar(showClock: false),
              Positioned(
                left: 0,
                right: 0,
                bottom: 8,
                child: Text(
                  _unlockText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              const Center(
                child: AppClock(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
