import 'dart:html' as html;
import 'dart:typed_data';

Future<String> downloadQrCode(Uint8List bytes, String tableNum) async {
  final blob = html.Blob([bytes.buffer]);
  final blobUrl = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: blobUrl)
    ..download = 'QR_Meja_$tableNum.png'
    ..click();
  html.Url.revokeObjectUrl(blobUrl);
  return '';
}
