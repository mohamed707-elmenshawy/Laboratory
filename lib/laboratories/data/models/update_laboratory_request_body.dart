import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class LaboratoryLogoFile {
  const LaboratoryLogoFile({required this.bytes, required this.filename});

  final Uint8List bytes;
  final String filename;
}

class UpdateLaboratoryRequestBody {
  const UpdateLaboratoryRequestBody({
    required this.lang,
    required this.name,
    this.logo,
  });

  final String lang;
  final String name;
  final LaboratoryLogoFile? logo;

  FormData toFormData() => FormData.fromMap(<String, dynamic>{
    'lang': lang,
    'name': name,
    if (logo != null)
      'logo': MultipartFile.fromBytes(
        logo!.bytes,
        filename: logo!.filename,
        contentType: _mediaTypeOf(logo!.filename),
      ),
  });

  static MediaType _mediaTypeOf(String filename) {
    final String extension = filename.split('.').last.toLowerCase();

    return switch (extension) {
      'png' => MediaType('image', 'png'),
      'jpg' || 'jpeg' => MediaType('image', 'jpeg'),
      _ => MediaType('application', 'octet-stream'),
    };
  }
}
