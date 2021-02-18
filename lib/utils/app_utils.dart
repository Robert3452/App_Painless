import 'dart:io';

class AppUtil {
  static Future<String> createFolderInIntDocDir(String folderName) async {
    final Directory _appInternalDir = Directory('/storage/emulated/0');
    final Directory _appInternalDirFolder =
        Directory('${_appInternalDir.path}/$folderName/');

    if (await _appInternalDirFolder.exists()) {
      return _appInternalDirFolder.path;
    } else {
      final Directory _appNewFolder =
          await _appInternalDirFolder.create(recursive: true);
      return _appNewFolder.path;
    }
  }
}
