import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerComponent extends StatefulWidget {
  final Function(XFile)? onImagePicked;
  String? defaultImage;
  ImagePickerComponent({Key? key, this.onImagePicked, this.defaultImage})
      : super(key: key);

  @override
  State<ImagePickerComponent> createState() => _ImagePickerComponentState();
}

class _ImagePickerComponentState extends State<ImagePickerComponent> {
  XFile? image;
  final ImagePicker imagePicker = ImagePicker();
  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

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
              child: Stack(
                children: [
                  SizedBox.expand(
                    child: FittedBox(
                      child: (image != null)
                          ? _buildImageWidget(image!.path)
                          : widget.defaultImage != null
                              ? _buildDefaultImageWidget(widget.defaultImage!)
                              : const Icon(
                                  Icons.image_outlined,
                                  color: Colors.blueGrey,
                                ),
                    ),
                  ),
                  if (image == null && widget.defaultImage == null)
                    Positioned(
                      top: 70,
                      right: size.width / 2 - 80,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Text(
                          '16:9',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 36),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageWidget(String imagePath) {
    return ClipRect(
      child: Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: size.width,
            maxHeight: 250,
          ),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.file(
              File(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultImageWidget(String imagePath) {
    return ClipRect(
      child: Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: size.width,
            maxHeight: 250,
          ),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
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
      // await convertToBase64(pickedFile);
      if (widget.onImagePicked != null) {
        widget.onImagePicked!(pickedFile);
      }
    }
    setState(() {
      image = pickedFile;
    });
  }

  Future<void> getFromCamera() async {
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      // await convertToBase64(pickedFile);
      if (widget.onImagePicked != null) {
        // widget.onImagePicked!(pickedFile);
      }
    }
    setState(() {
      image = pickedFile;
    });
  }
}
