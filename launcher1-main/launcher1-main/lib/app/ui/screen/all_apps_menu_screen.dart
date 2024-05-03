import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:auto_route/auto_route.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:launcher1/app/di/init_di.dart';
import 'package:launcher1/app/ui/components/scroll_effect.dart';
import 'package:launcher1/feature/lang/app_lang.dart';
import 'package:launcher1/feature/router/domain/app_router.dart';
import 'package:launcher1/feature/status_bar/ui/status_bar.dart';
import 'package:launcher1/feature/updater/domain/app_updater.dart';
import 'package:launcher1/gen/assets.gen.dart';
import 'package:package_info_plus/package_info_plus.dart';

@RoutePage()
class AllAppsMenuScreen extends StatefulWidget {
  static const String path = '/menu';

  final bool onlyUserApps;

  const AllAppsMenuScreen({super.key, required this.onlyUserApps});

  @override
  State<AllAppsMenuScreen> createState() => _AllAppsMenuState();
}

class _AllAppsMenuState extends State<AllAppsMenuScreen> {
  String _status = AppLang.loc.loading;
  String? _updateUrl;

  List<AllAppItem> _apps = [];

  void setStateIfMounted(VoidCallback f) {
    if (mounted) setState(f);
  }

  @override
  void initState() {
    super.initState();
    _loadApps();
    _checkUpdate();
    _checkAppsUpdate();
  }

  Future<void> _checkUpdate() async {
    final update = await AppUpdater().isNeedUpgrade();
    setStateIfMounted(() => _updateUrl = update);
  }

  Future<void> _checkAppsUpdate() async {
    DeviceApps.listenToAppsChanges().listen((event) async {
      String packageName = event.packageName;
      switch (event.event) {
        case ApplicationEventType.installed:
        case ApplicationEventType.disabled: // disabled and enabled are mixed-up
        case ApplicationEventType.updated:
          _apps.removeWhere((app) => app.app?.packageName == packageName);
          _apps.add(
            AllAppItem(
              app: (await DeviceApps.getApp(
                packageName,
                true,
              )),
            ),
          );
          break;
        case ApplicationEventType.uninstalled:
        case ApplicationEventType.enabled: // disabled and enabled are mixed-up
          _apps.removeWhere((app) => app.app?.packageName == packageName);
          break;
      }
      // _apps.sort(
      //   (a, b) => (a.app?.appName ?? '').compareTo(b.app?.appName ?? ''),
      // );
      setStateIfMounted(() {});
    });
  }

  Future<void> _loadApps() async {
    final apps = await DeviceApps.getInstalledApplications(
      includeSystemApps: !widget.onlyUserApps,
      includeAppIcons: true,
      onlyAppsWithLaunchIntent: true,
    );
    final currentApp = await PackageInfo.fromPlatform();
    final currentPackage = currentApp.packageName;

    final appMine = currentPackage.replaceAll('.debug', '');

    _status = '';
    _apps = apps.map((app) => AllAppItem(app: app)).toList();
    _apps.removeWhere((item) {
      final toRemove = item.app?.packageName.startsWith(appMine);
      return toRemove ?? false;
    });

    // _apps.sort(
    //   (a, b) => (a.app?.appName ?? '').compareTo(b.app?.appName ?? ''),
    // );

    setStateIfMounted(() {});

    if (widget.onlyUserApps) return;

    _apps.add(AllAppItem(
      title: 'Engineer Mode',
      dial: 'tel:*%23*%233646633%23*%23*',
    ));

    // _apps.sort(
    //   (a, b) => (a.app?.appName ?? '').compareTo(b.app?.appName ?? ''),
    // );

    setStateIfMounted(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        locator.get<AppRouter>().replace(const HomeRoute());
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(
            children: [
              Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const StatusBar(showClock: true),
                  if (_updateUrl != null)
                    _UpdateBadge(downloadUrl: _updateUrl!),
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: ScrollEffect(),
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(6),
                        physics: const ClampingScrollPhysics(),
                        itemCount: _apps.length,
                        itemBuilder: (context, index) {
                          final item = _apps[index];
                          return _AppItemView(item: item);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: Text(
                  _status,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 32,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AllAppItem {
  final Application? app;
  final String? title;
  final String? package;
  final String? componentName;
  final String? dial;

  AllAppItem({
    this.app,
    this.title,
    this.package,
    this.componentName,
    this.dial,
  });
}

class _UpdateBadge extends StatefulWidget {
  final String downloadUrl;

  const _UpdateBadge({required this.downloadUrl});

  @override
  State<_UpdateBadge> createState() => _UpdateBadgeState();
}

class _UpdateBadgeState extends State<_UpdateBadge> {
  String _status = AppLang.loc.update;

  final ValueNotifier<bool> _isSelected = ValueNotifier<bool>(false);

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _focusNode.addListener(() => _isSelected.value = _focusNode.hasFocus);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _isSelected.dispose();
    super.dispose();
  }

  Future<void> _update() async {
    if (_status == AppLang.loc.downloading) return;
    setState(() => _status = AppLang.loc.downloading);
    await AppUpdater().downloadAndInstallApk(widget.downloadUrl);
  }

  void _handleKeyPress(RawKeyEvent event) {
    if (event.runtimeType != RawKeyDownEvent) return;

    if (event.logicalKey == LogicalKeyboardKey.select) {
      _update();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: _focusNode,
      onKey: _handleKeyPress,
      child: GestureDetector(
        onTap: () => _update(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: ValueListenableBuilder<bool>(
            valueListenable: _isSelected,
            builder: (context, isSelected, _) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        isSelected ? Colors.blue.shade100 : Colors.transparent,
                    style: BorderStyle.solid,
                    width: 3.0,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  children: [
                    const SizedBox(width: 16 + 8),
                    Container(
                      height: 22,
                      width: 22,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    const SizedBox(width: 14 + 22),
                    Text(
                      _status,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 28,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AppItemView extends StatefulWidget {
  const _AppItemView({required this.item});

  final AllAppItem item;

  @override
  State<_AppItemView> createState() => _AppItemViewState();
}

class _AppItemViewState extends State<_AppItemView> {
  final ValueNotifier<bool> _isSelected = ValueNotifier<bool>(false);

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _focusNode.addListener(() => _isSelected.value = _focusNode.hasFocus);
    super.initState();
  }

  void _openApp() {
    if (widget.item.dial != null) {
      try {
        AndroidIntent intent = AndroidIntent(
          action: 'android.intent.action.DIAL',
          data: widget.item.dial,
        );
        intent.launch();
      } catch (e) {
        widget.item.app?.openApp();
      }
      return;
    }
    if (widget.item.componentName == null) {
      widget.item.app?.openApp();
      return;
    }

    try {
      AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.RUN',
        package: widget.item.app?.packageName,
        componentName:
            '${widget.item.app?.packageName}${widget.item.componentName}',
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      intent.launch();
    } catch (e) {
      widget.item.app?.openApp();
    }
  }

  void _handleKeyPress(RawKeyEvent event) {
    if (event.runtimeType != RawKeyDownEvent) return;

    if (event.logicalKey == LogicalKeyboardKey.select) {
      _openApp();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _isSelected.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: _focusNode,
      onKey: _handleKeyPress,
      child: GestureDetector(
        onTap: _openApp,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 12,
                bottom: 12,
                left: 12,
                right: 12,
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: _AppItemIcon(item: widget.item),
                  ),
                  const SizedBox(width: 22),
                  Flexible(
                    child: Text(
                      widget.item.app?.appName ?? (widget.item.title ?? 'app'),
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: ValueListenableBuilder<bool>(
                valueListenable: _isSelected,
                builder: (context, isSelected, _) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? Colors.blue.shade100
                            : Colors.transparent,
                        style: BorderStyle.solid,
                        width: 3.0,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppItemIcon extends StatelessWidget {
  const _AppItemIcon({required this.item});

  final AllAppItem item;

  @override
  Widget build(BuildContext context) {
    return (item.app != null)
        ? Image.memory(
            (item.app as ApplicationWithIcon).icon,
            height: 52,
            width: 52,
            cacheWidth: 52,
            cacheHeight: 52,
          )
        : SvgPicture.asset(
            Assets.images.icBox,
            height: 52,
            width: 52,
            colorFilter: const ColorFilter.mode(
              Colors.white54,
              BlendMode.srcATop,
            ),
          );
  }
}
