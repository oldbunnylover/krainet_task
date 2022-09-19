import 'dart:typed_data';

abstract class IFirebaseImageRepository {
  Future<String> uploadImage(String name, Uint8List imageBytes, String userId);
  Future<void> removeImage(String url, String userId);
  Future<List<String>> fetchImageUrls(String userId);
}