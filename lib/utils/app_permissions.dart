import 'package:permission_handler/permission_handler.dart';

class AppPermissions {
  // Private constructor for singleton
  AppPermissions._privateConstructor();

  // Singleton instance
  static final AppPermissions instance = AppPermissions._privateConstructor();

  /// Request a specific permission
  Future<bool> requestPermission(Permission permission) async {
    final status = await permission.request();
     if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      // Open app settings if permission is permanently denied
      await openSettings();
      return false;
    }

    return false;
  }

  /// Check if a specific permission is granted
  Future<bool> isPermissionGranted(Permission permission) async {
    return await permission.status.isGranted;
  }

   /// Open app settings
  Future<void> openSettings() async {
    bool isOpened = await openAppSettings();
    if (!isOpened) {
      throw Exception("Could not open app settings.");
    }
  }
}
