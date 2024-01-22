import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

Future<void> uploadMP3(File file) async {
  try {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageReference = storage
        .ref()
        .child('music/${DateTime.now().millisecondsSinceEpoch}.mp3');

    UploadTask uploadTask = storageReference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    // Làm bất cứ điều gì bạn muốn với downloadUrl, ví dụ: lưu vào Firestore Database.
    print('Download URL: $downloadUrl');
  } catch (e) {
    print('Error uploading file: $e');
  }
}
