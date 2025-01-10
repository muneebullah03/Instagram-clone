// ignore_for_file: depend_on_referenced_packages

import 'dart:typed_data';

import 'package:image/image.dart' as img;

class StorageServices {
  Uint8List compressImage(Uint8List imageBytes) {
    final decodedImage = img.decodeImage(imageBytes);
    final compressedImage =
        img.encodeJpg(decodedImage!, quality: 70); // Adjust quality
    return Uint8List.fromList(compressedImage);
  }

  // final FirebaseStorage _storage = FirebaseStorage.instance;
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<String> uploadImageToStorage(
  //     String childName, Uint8List file, bool isPost) async {
  //   // this will send data to server and store in file in below location
  //   Reference ref =
  //       _storage.ref().child(childName).child(_auth.currentUser!.uid);

  //   UploadTask uploadTask = ref.putData(file);
  //   TaskSnapshot snapshot = await uploadTask;
  //   // this will get all the data that we upload
  //   String downloadedUrl = await snapshot.ref.getDownloadURL();

  //   return downloadedUrl;
  // }
}
