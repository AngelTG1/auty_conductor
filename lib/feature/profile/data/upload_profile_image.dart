import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import '../../../core/services/secure_storage_service.dart';
import '../../../core/http/api_constants.dart';

class ProfileImageUploader {
  static Future<String> uploadProfileImage({
    required String userUuid,
    required File imageFile,
  }) async {
    final token = await SecureStorageService.read('token');
    final url = Uri.parse("${ApiConstants.users}/$userUuid/upload-image");

    final mime = lookupMimeType(imageFile.path)!.split('/');

    final request = http.MultipartRequest("POST", url)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType(mime[0], mime[1]),
        ),
      );

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception("Error al subir imagen: $body");
    }

    final regex = RegExp(r'"imageUrl"\s*:\s*"([^"]+)"');
    final match = regex.firstMatch(body);
    final imageUrl = match?.group(1) ?? "";

    if (imageUrl.isNotEmpty) {
      await SecureStorageService.write("profileImage", imageUrl);
    }

    return imageUrl;
  }
}
