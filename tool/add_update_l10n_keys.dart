import 'dart:convert';
import 'dart:io';

/// Bu script, en.arb içindeki update metinlerini
/// diğer tüm locale .arb dosyalarına İngilizce fallback olarak ekler.
///
/// Yeni anahtarlar:
/// - updateAvailableTitle
/// - updateAvailableMessage
/// - updateRequiredTitle
/// - updateRequiredMessage
/// - updateNow
/// - updateLater
/// - updateChangelog
/// - openDownloadPage
///
/// Çalıştırmak için:
/// dart run tool/add_update_l10n_keys.dart

void main() async {
  final l10nDir = Directory('lib/l10n');
  if (!l10nDir.existsSync()) {
    stderr.writeln('lib/l10n klasörü bulunamadı.');
    exit(1);
  }

  final enFile = File('lib/l10n/app_en.arb');
  if (!enFile.existsSync()) {
    stderr.writeln('lib/l10n/app_en.arb bulunamadı.');
    exit(1);
  }

  final enJson =
      json.decode(await enFile.readAsString()) as Map<String, dynamic>;

  final keys = <String>[
    'updateAvailableTitle',
    'updateAvailableMessage',
    'updateRequiredTitle',
    'updateRequiredMessage',
    'updateNow',
    'updateLater',
    'updateChangelog',
    'openDownloadPage',
  ];

  final source = <String, String>{
    for (final k in keys) k: (enJson[k] as String?) ?? '',
  };

  for (final file in l10nDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.arb'))) {
    final name = file.uri.pathSegments.last;
    if (name == 'app_en.arb' || name == 'app_tr.arb') {
      // en ve tr zaten manuel dolduruldu.
      continue;
    }

    final content =
        json.decode(await file.readAsString()) as Map<String, dynamic>;
    var changed = false;

    for (final entry in source.entries) {
      if (!content.containsKey(entry.key)) {
        content[entry.key] = entry.value;
        changed = true;
      }
    }

    if (changed) {
      // JSON'u pretty-print etmeden, mevcut formatı bozmadan yazmak zor.
      // Bu yüzden minimal biçimlendirilmiş JSON yazıyoruz.
      final encoder = const JsonEncoder.withIndent('  ');
      await file.writeAsString('${encoder.convert(content)}\n');
      stdout.writeln('Updated ${file.path}');
    }
  }

  stdout.writeln('Done updating l10n update keys.');
}

