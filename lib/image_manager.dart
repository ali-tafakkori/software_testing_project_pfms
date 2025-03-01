import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path_pack;
import 'package:image_picker/image_picker.dart';

class ImageManager {
  static late ImageManager _imageManager;

  static ImageManager get instance {
    return _imageManager;
  }

  static void init() async {
    _imageManager = ImageManager();
    _imageManager.createTemporaryDirectory();
  }

  late String photosDirectoryPath;

  void createTemporaryDirectory() async {
    Directory tempDir = await getTemporaryDirectory();
    await tempDir.create();
    photosDirectoryPath = "${tempDir.path}/Invoices";
    await Directory(photosDirectoryPath).create();
  }

  Future<String> copyToTempAndDelete(String path) async {
    Directory photos = await Directory(photosDirectoryPath).create();
    String extension = path_pack.extension(path);
    String newPath =
        "${photos.path}/IMAGE_${DateTime
        .now()
        .microsecondsSinceEpoch}$extension";

    File file = File(path);

    await file.copy(newPath);
    await file.delete();
    return path_pack.basename(newPath);
  }

  Future<String?> showDialogImagePicker({
    required BuildContext context,
    VoidCallback? onDelete,
  }) {
    Completer<String?> completer = Completer<String?>();

    showDialog<String?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: [
            if (onDelete != null)
              TextButton(
                onPressed: () => Navigator.of(context).pop("delete"),
                child: const Text("Delete"),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop("camera"),
              child: const Text("Camera"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop("gallery"),
              child: const Text("Gallery"),
            ),
          ],
        );
      },
    ).then((value) {
      if (value != null) {
        if (value == "camera" || value == "gallery") {
          ImagePicker()
              .pickImage(
            source: value == "camera" && value != "gallery"
                ? ImageSource.camera
                : ImageSource.gallery,
            imageQuality: 50,
          )
              .then((value) async {
            if (value != null) {
              try {
                String name = await copyToTempAndDelete(value.path);
                completer.complete(name);
              } catch (e) {
                completer.completeError(e);
              }
            }
          });
        } else if (value == "delete") {
          if (onDelete != null) {
            onDelete();
            completer.complete(null);
          }
        }
      }
    });
    return completer.future;
  }

  void deleteImage(String photo) {
    File("$photosDirectoryPath/$photo").deleteSync();
  }
}
