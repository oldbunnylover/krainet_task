import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:krainet_task/domain/repositories/interfaces/i_firebase_image_repository.dart';

class FirebaseImageRepository implements IFirebaseImageRepository {
  final _images = FirebaseFirestore.instance.collection('images');

  @override
  Future<String> uploadImage(String name, Uint8List imageBytes, String userId) async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child(name);
    await imageRef.putData(imageBytes, SettableMetadata(contentType: 'image/jpeg'));
    final url = await imageRef.getDownloadURL();
    await _images.doc(userId).set(
      {
        'url': FieldValue.arrayUnion([url])
      },
      SetOptions(merge: true),
    );
    return url;
  }

  @override
  Future<List<String>> fetchImageUrls(String userId) async {
    final imagesList = (await _images.doc(userId).get()).data();
    return imagesList != null ? (imagesList['url'] as List).map((e) => e.toString()).toList() : [];
  }

  @override
  Future<void> removeImage(String url, String userId) async {
    await _images.doc(userId).update({
      'url': FieldValue.arrayRemove([url])
    });
  }
}
