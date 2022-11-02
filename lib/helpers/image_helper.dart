import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  Future<String?> uploadImage(
      {required File imageFile, required String directoryName}) async {
    final now = DateTime.now();
    final uniqueName = now.microsecondsSinceEpoch.toString();
    final ref = FirebaseStorage.instance
        .ref()
        .child(directoryName)
        .child('$uniqueName.jpg');
    await ref.putFile(imageFile);
    final url = await ref.getDownloadURL();
    return url;
  }

  Future<File?> chooseFile() async {
    final ImagePicker picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImage == null) {
      return null;
    }
    final pickedImageFile = File(pickedImage.path);

    return pickedImageFile;
  }
}
