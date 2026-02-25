import 'dart:io';

void main() {
  final files = Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('_provider.dart') && f.readAsStringSync().contains('riverpod_annotation'));
      
  for (var f in files) {
    var content = f.readAsStringSync();
    if (!content.contains('flutter_riverpod.dart')) {
      content = content.replaceFirst(
        "import 'package:riverpod_annotation/riverpod_annotation.dart';",
        "import 'package:riverpod_annotation/riverpod_annotation.dart';\nimport 'package:flutter_riverpod/flutter_riverpod.dart';"
      );
      f.writeAsStringSync(content);
      print('Updated ${f.path}');
    }
  }
}
