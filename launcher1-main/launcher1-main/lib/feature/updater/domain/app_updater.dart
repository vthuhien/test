import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AppUpdater {
  var _downloading = false;
  void upgradeApp({bool install = false}) async {
    final newAppApkUrl = await isNeedUpgrade();

    if (newAppApkUrl == null || !install) return;

    await downloadAndInstallApk(newAppApkUrl);
  }

  Future<void> downloadAndInstallApk(String url) async {
    try {
      // Check and request necessary permissions
      var storageStatus = await Permission.storage.status;
      var requestInstallPackagesStatus =
          await Permission.requestInstallPackages.status;

      if (!storageStatus.isGranted) {
        await Permission.storage.request();
      }
      if (!requestInstallPackagesStatus.isGranted) {
        await Permission.requestInstallPackages.request();
      }

      if (_downloading) return;
      _downloading = true;

      // Get the directory to download the APK
      Directory directory = await getApplicationDocumentsDirectory();
      String apkPath = '${directory.path}/launcher1.apk';

      // Check if the file already exists and delete it if it does
      File apkFile = File(apkPath);
      if (await apkFile.exists()) {
        await apkFile.delete();
      }

      log('download');
      // Download the APK using Dio
      Dio dio = Dio();
      await dio.download(url, apkPath);

      log('install');

      // Install the APK using android_intent_plus
      final res = await InstallPlugin.install(apkPath);

      log('res: $res');
    } catch (e) {
      log('err: $e');
    }
  }

  Future<String?> isNeedUpgrade() async {
    try {
      final latestVersionInfo = await _fetchLatestInfoFromGitHub();
      final currentVersion = await _getCurrentAppVersion();

      // log('currentVersion: $currentVersion');
      // log('latestVersionInfo: $latestVersionInfo');

      String? latestVersion = latestVersionInfo?['version'];

      bool isNew = _versionCompare(currentVersion, latestVersion);

      if (isNew) {
        return latestVersionInfo?['downloadUrl'];
      }
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  bool _versionCompare(
    String? currentVersion,
    String? latestVersion,
  ) {
    try {
      if (latestVersion == null || currentVersion == null) return false;

      // Strip out non-numeric parts and then split
      final currentVersionNumeric = currentVersion.split(RegExp(r'[^0-9.]'))[0];
      final latestVersionNumeric = latestVersion.split(RegExp(r'[^0-9.]'))[0];

      final currentVersionList =
          currentVersionNumeric.split('.').map(int.parse).toList();
      final lastestVersionList =
          latestVersionNumeric.split('.').map(int.parse).toList();

      int comparisonLength =
          math.min(currentVersionList.length, lastestVersionList.length);

      for (int i = 0; i < comparisonLength; i++) {
        if (currentVersionList[i] < lastestVersionList[i]) {
          return true;
        } else if (currentVersionList[i] > lastestVersionList[i]) {
          return false;
        }
      }

      // In case one version has more numbers (e.g., 1.0.0 vs 1.0)
      return lastestVersionList.length > currentVersionList.length;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<String?> _getCurrentAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<Map?> _fetchLatestInfoFromGitHub() async {
    final dio = Dio();
    final response = await dio.get(
      'https://api.github.com/repos/MrJohnDev/qin_launcher1/releases/latest',
    );
    if (response.statusCode == 200) {
      final json = response.data;
      final version = json['name'];
      final asset = json['assets'][0];
      return {
        'version': version.toString(),
        'downloadUrl': asset['browser_download_url'],
      };
    }
    return null;
  }
}
