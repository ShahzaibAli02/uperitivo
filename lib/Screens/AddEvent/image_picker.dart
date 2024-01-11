import 'dart:io';
import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerComponent extends StatefulWidget {
  final Function(String)? onImagePicked;
  const ImagePickerComponent({Key? key, this.onImagePicked}) : super(key: key);

  @override
  _ImagePickerComponentState createState() => _ImagePickerComponentState();
}

class _ImagePickerComponentState extends State<ImagePickerComponent> {
  String? base64Image;
  final ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            showPictureBottomSheet();
          },
          child: Container(
            margin: const EdgeInsets.all(20),
            width: size.width,
            height: 250,
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              color: Colors.blueGrey,
              strokeWidth: 1,
              dashPattern: const [5, 5],
              child: SizedBox.expand(
                child: FittedBox(
                  child: base64Image != null
                      ? Image.memory(
                          base64.decode(base64Image!),
                          fit: BoxFit.cover,
                        )
                      : const Icon(
                          Icons.image_outlined,
                          color: Colors.blueGrey,
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> showPictureBottomSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    getFromCamera();
                    Navigator.of(context).pop();
                  },
                  leading: const Icon(Icons.camera),
                  title: const Text('Open Camera'),
                ),
                ListTile(
                  onTap: () {
                    getFromGallery();
                    Navigator.of(context).pop();
                  },
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Open Gallery'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> getFromGallery() async {
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      await convertToBase64(pickedFile);
      if (widget.onImagePicked != null) {
        widget.onImagePicked!(base64Image!);
      }
    }
  }

  Future<void> getFromCamera() async {
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      await convertToBase64(pickedFile);
      if (widget.onImagePicked != null) {
        widget.onImagePicked!(base64Image!);
      }
    }
  }

  Future<void> convertToBase64(XFile pickedFile) async {
    List<int> imageBytes = await pickedFile.readAsBytes();
    String imageBase64 = base64Encode(imageBytes);
    setState(() {
      base64Image = imageBase64;
    });
  }
}
