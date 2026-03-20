import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;

Future<void> downloadAsCSV(
  List<String> header,
  List<List<String>> dataList, [
  String fileName = "wordUtteranceData",
]) async {
  // 1. Generate CSV content
  // note: this used to be final csvData = const CsvEncoder().convert([header, ...dataList]); in VSC: 7.0.0
  //  but with the upgrade to 8.0.0 the preffered API usage has changed. If testing fails revert to older version
  final csvData = Csv().encode([header, ...dataList]);
  final timestamp = DateFormat('yyyyMMdd-HHmmss').format(DateTime.now());
  final fullFileName = '${fileName}_$timestamp.csv';

  // 2. Convert to bytes
  final bytes = Uint8List.fromList(csvData.codeUnits);

  // 3. Handle Web
  if (kIsWeb) {
    final blob = html.Blob([csvData], 'text/csv');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', fullFileName)
      ..click();
    html.Url.revokeObjectUrl(url);
    return;
  }

  // 4. Handle Mobile/Desktop
  await FileSaver.instance.saveAs(
    name: fullFileName.replaceAll('.csv', ''),
    bytes: bytes,
    fileExtension: 'csv',
    mimeType: MimeType.csv,
  );

  // 5. Note: this will not work on desktop platforms since file_saver does not yet support it.
  //    For desktop, you might need to use file_selector to getSavePath() and then write the file manually using dart:io.
}
