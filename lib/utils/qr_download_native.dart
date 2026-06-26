import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

Future<String> downloadQrCode(Uint8List bytes, String tableNum) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/QR_Meja_$tableNum.png');
  await file.writeAsBytes(bytes);
  return file.path;
}
