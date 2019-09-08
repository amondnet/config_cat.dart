import 'dart:io';

String readFile(String path) {
  final file = new File(path);
  return file.readAsStringSync();
}
