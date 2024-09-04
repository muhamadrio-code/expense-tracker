import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

void showImagePickerDialog(BuildContext context,
    {required void Function(List<XFile>) onSuccess,
    required void Function(Exception) onError}) {
  void pickFromAlbum() async {
    try {
      final images = await ImagePicker().pickMultiImage();
      onSuccess(images);
      Navigator.pop(context);
    } on PlatformException catch (e) {
      onError(e);
    }
  }

  void openCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      onSuccess([image]);
      Navigator.pop(context);
    } on PlatformException catch (e) {
      onError(e);
    }
  }

  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: pickFromAlbum, child: const Text("Album")),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: openCamera, child: const Text("Camera")),
            )
          ]),
        );
      });
}
