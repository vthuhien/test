/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/ic_battery_0.svg
  String get icBattery0 => 'assets/images/ic_battery_0.svg';

  /// File path: assets/images/ic_battery_1.svg
  String get icBattery1 => 'assets/images/ic_battery_1.svg';

  /// File path: assets/images/ic_battery_2.svg
  String get icBattery2 => 'assets/images/ic_battery_2.svg';

  /// File path: assets/images/ic_battery_3.svg
  String get icBattery3 => 'assets/images/ic_battery_3.svg';

  /// File path: assets/images/ic_battery_charging.svg
  String get icBatteryCharging => 'assets/images/ic_battery_charging.svg';

  /// File path: assets/images/ic_box.svg
  String get icBox => 'assets/images/ic_box.svg';

  /// File path: assets/images/ic_calendar.svg
  String get icCalendar => 'assets/images/ic_calendar.svg';

  /// File path: assets/images/ic_call.svg
  String get icCall => 'assets/images/ic_call.svg';

  /// File path: assets/images/ic_math.svg
  String get icMath => 'assets/images/ic_math.svg';

  /// File path: assets/images/ic_message.svg
  String get icMessage => 'assets/images/ic_message.svg';

  /// List of all assets
  List<String> get values => [
        icBattery0,
        icBattery1,
        icBattery2,
        icBattery3,
        icBatteryCharging,
        icBox,
        icCalendar,
        icCall,
        icMath,
        icMessage
      ];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
