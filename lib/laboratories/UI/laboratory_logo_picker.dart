import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

import '../data/models/update_laboratory_request_body.dart';

typedef LaboratoryLogoPicker = Future<LaboratoryLogoResult?> Function();

class LaboratoryLogoResult {
  const LaboratoryLogoResult.picked(this.file) : tooLarge = false;
  const LaboratoryLogoResult.tooLarge() : file = null, tooLarge = true;

  final LaboratoryLogoFile? file;
  final bool tooLarge;
}

/// The backend accepts jpeg, png and jpg only, at most 2 MB.
const List<String> laboratoryLogoExtensions = <String>['png', 'jpg', 'jpeg'];
const int laboratoryLogoMaxBytes = 2 * 1024 * 1024;

Future<LaboratoryLogoResult?> pickLaboratoryLogo() async {
  final PlatformFile? file = await FilePicker.pickFile(
    type: FileType.custom,
    allowedExtensions: laboratoryLogoExtensions,
  );

  if (file == null) return null;

  final Uint8List bytes = await file.readAsBytes();
  if (bytes.isEmpty) return null;
  if (bytes.length > laboratoryLogoMaxBytes) {
    return const LaboratoryLogoResult.tooLarge();
  }

  final String name = file.name.trim();
  final String filename = name.isEmpty ? 'logo.png' : name;

  return LaboratoryLogoResult.picked(
    LaboratoryLogoFile(bytes: bytes, filename: filename),
  );
}
