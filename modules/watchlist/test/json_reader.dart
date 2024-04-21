import 'dart:io';

String readJson(String name) {
  var dir = Directory.current.path;
  if (dir.endsWith('/test')) {
    dir = dir.replaceAll('/test', '');
  }
  var file = File('$dir/test/$name');
  var content = file.readAsStringSync();
  // Remove invalid characters
  content = content.replaceAll('\uFEFF', '');
  return content;
}
