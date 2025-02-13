import 'package:permission_handler/permission_handler.dart';

class AppPermissions {
  // Private constructor for singleton
  AppPermissions._privateConstructor();

  // Singleton instance
  static final AppPermissions instance = AppPermissions._privateConstructor();

  /// Request a specific permission
  Future<bool> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  /// Check if a specific permission is granted
  Future<bool> isPermissionGranted(Permission permission) async {
    return await permission.status.isGranted;
  }

  /// Open app settings
  Future<void> openAppSettings() async {
    await openAppSettings();
  }
}
