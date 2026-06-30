import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

/// Builds a Dio [MultipartFile] from an [XFile] in a way that works on BOTH
/// Flutter web and mobile.
///
/// On web there is no `dart:io` File, so we must read the bytes and use
/// [MultipartFile.fromBytes] (never `fromFile`). We also set an explicit
/// `image/*` content type because the YallaDo backend rejects
/// `application/octet-stream` ("invalid img type").
DioMediaType imageMediaType(String name) {
  final ext = name.contains('.') ? name.split('.').last.toLowerCase() : 'jpg';
  final sub = switch (ext) {
    'png' => 'png',
    'webp' => 'webp',
    'gif' => 'gif',
    'heic' => 'heic',
    _ => 'jpeg',
  };
  return DioMediaType('image', sub);
}

Future<MultipartFile> multipartFromXFile(XFile file) async {
  final bytes = await file.readAsBytes();
  final name = file.name.isNotEmpty ? file.name : 'upload.jpg';
  return MultipartFile.fromBytes(
    bytes,
    filename: name,
    contentType: imageMediaType(name),
  );
}
