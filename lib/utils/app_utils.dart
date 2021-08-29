import 'dart:io';
import 'package:path/path.dart';

class AppUtil {
  static Future<String> createInternalDir(String folderName) async {
    try {
      final String rootPath = '/storage/emulated/0';
      final Directory _internalDir = Directory(rootPath);

      final Directory _appInternalDirectory =
          Directory('${_internalDir.path}/$folderName');

      if (await _appInternalDirectory.exists()) {
        print("existe $_appInternalDirectory");
        return _appInternalDirectory.path;
      } else {
        print("no existe $_appInternalDirectory");
        final Directory _appNewFolder =
            await _appInternalDirectory.create(recursive: false);
        return _appNewFolder.path;
      }
    } catch (error) {
      print("error $error");
    }
  }

  static Future<List<Map<String, dynamic>>> getFiles(String path) async {
    final String rootPath = '/storage/emulated/0/$path';
    final Directory dir = Directory(rootPath);
    List<FileSystemEntity> files;
    List<Map<String, dynamic>> listFiles = [];
    if (await dir.exists()) {
      files = Directory('$rootPath/').listSync(recursive: true);
      for (FileSystemEntity file in files) {
        var created = file.statSync().changed;
        var fileItem = {
          "path": file.path,
          "date": '${toDateString(created)}',
          "time": '${toHourString(created, ':')}',
          "name": basename(file.path)
        };
        listFiles.insert(0, fileItem);
      }
    }
    return listFiles;
  }

  static String toHourString(DateTime value, String char) {
    return '${twoDigitsString(value.hour)}$char${twoDigitsString(value.minute)}$char${twoDigitsString(value.second)}';
  }

  static twoDigitsString(int value) {
    return value.toString().padLeft(2, '0');
  }

  static toDateString(DateTime val) {
    return '${twoDigitsString(val.day)}-${twoDigitsString(val.month)}-${twoDigitsString(val.year)}';
  }

  static Future<String> createFile(String appPath) async {
    try {
      DateTime dateNow = DateTime.now();
      String extension = "wav";
      String now = '${toDateString(dateNow)}_${toHourString(dateNow, '')}';
      String newFile = "$appPath/$now.$extension";
      print("filename $newFile");

      final File fileApp = File('$newFile');
      if (await fileApp.exists()) {
        return fileApp.path;
      } else {
        await fileApp.create(recursive: true);
        return fileApp.path;
      }
    } catch (error) {
      print("error $error");
    }
  }
}
