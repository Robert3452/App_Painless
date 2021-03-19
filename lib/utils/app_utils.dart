import 'dart:io';

class AppUtil {
  static Future<String> createInternalDir(String folderName) async {
    final Directory _internalDir = Directory('/storage/emulated/0');
    final Directory _appInternalDirectory =
        Directory('${_internalDir.path}/$folderName/');

    if (await _appInternalDirectory.exists()) {
      return _appInternalDirectory.path;
    } else {
      final Directory _appNewFolder =
          await _appInternalDirectory.create(recursive: true);
      return _appNewFolder.path;
    }
  }

  static Future<String> createFile(String appPath) async {
    String now = DateTime.now().toString();
    print(now);
    String newFile = "$appPath/$now.mp3";
    final File fileApp = File('$newFile');
    if (await fileApp.exists()) {
      return fileApp.path;
    } else {
      await fileApp.create(recursive: true);
      return fileApp.path;
    }
  }
}
