import 'dart:io';
import 'package:declarative_route/common.dart';
import 'package:declarative_route/provider/image_provider.dart';
import 'package:declarative_route/provider/upload_provider.dart';
import 'package:declarative_route/widget/Snackbar.dart';
import 'package:declarative_route/widget/platform_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

/// todo-01-setup-02: add form screen
class FormScreen extends StatefulWidget {
  final Function onSend;

  const FormScreen({
    super.key,
    required this.onSend,
  });

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final descriptionController = TextEditingController();
  @override
  void dispose() {
    descriptionController.dispose();

    super.dispose();
  }

  Widget _buildList() {
    final contextImageProvider = context.watch<ShowImageProvider>();
    final contextUploadProvider = context.watch<UploadProvider>();

    return Center(
        child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: contextImageProvider.imagePath == null
                        ? const Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.image,
                              size: 100,
                            ),
                          )
                        : _showImage(),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => _onGalleryView(),
                          child: const Text("Gallery"),
                        ),
                        ElevatedButton(
                          onPressed: () => _onCameraView(),
                          child:
                              Text(AppLocalizations.of(context)!.buttonCamera),
                        ),
                      ],
                    ),
                  ),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: null,
                    minLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email.';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "description",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      /// todo-04-navigate-02: send data to previous screen
                      String description = descriptionController.text;
                      if (contextImageProvider.imagePath == null) {
                        showCustomSnackBar(context,
                            "Pilih gambar terlebih dahulu", Colors.redAccent);
                      } else if (description == "") {
                        showCustomSnackBar(
                            context, "Masukan Deskripsi", Colors.redAccent);
                      } else {
                        await _onUpload(description);
                        if (contextUploadProvider.error == false) {
                          showCustomSnackBar(
                              context,
                              contextUploadProvider.message,
                              Colors.greenAccent);
                          widget.onSend();
                        } else {
                          showCustomSnackBar(context,
                              contextUploadProvider.message, Colors.redAccent);
                        }
                      }
                    },
                    child: contextUploadProvider.isUploading
                        ? const CircularProgressIndicator()
                        : Text(AppLocalizations.of(context)!.buttonSendAddForm),
                  ),
                ],
              ),
            )));
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.titleAppBarAdd,
        ),
      ),
      body: _buildList(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(AppLocalizations.of(context)!.titleAppBarAdd),
      ),
      child: _buildList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }

  _onUpload(description) async {
    final uploadProvider = context.read<UploadProvider>();

    /// todo-02-prepare-01: check image is ready or not
    final homeProvider = context.read<ShowImageProvider>();
    final imagePath = homeProvider.imagePath;
    final imageFile = homeProvider.imageFile;
    if (imagePath == null || imageFile == null) return;

    /// todo-02-prepare-02: prepare a document variabel to upload
    final fileName = imageFile.name;
    final bytes = await imageFile.readAsBytes();

    /// todo-05-compress-03: compress an image before upload

    final newImage = await uploadProvider.compressImage(bytes);
    await uploadProvider.upload(
      newImage,
      // bytes,
      fileName,
      description,
    );

    /// todo-03-upload-07: upload the document
    /// todo-05-compress-04: change the variable byte
    /// print

    /// todo-04-after-02: remove the image
    if (uploadProvider.uploadResponse != null) {
      homeProvider.setImageFile(null);
      homeProvider.setImagePath(null);
    }

    /// todo-04-after-03: show the message
  }

  _onGalleryView() async {
    final provider = context.read<ShowImageProvider>();

    /// todo-gallery-06: check if MacOS and Linux
    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    /// todo-gallery-01: initial ImagePicker class
    final picker = ImagePicker();

    /// todo-gallery-02: pick image from gallery
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    /// todo-gallery-03: check the result and update the image
    if (pickedFile != null) {
      /// todo-gallery-05: update the state, imagePath and imageFile
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onCameraView() async {
    final provider = context.read<ShowImageProvider>();

    /// todo-image-04: check if not Mobile
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isiOS);
    if (isNotMobile) return;

    /// todo-image-01: initial ImagePicker class
    final picker = ImagePicker();

    /// todo-image-02: pick image from camera app
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    /// todo-image-03: check the result and update the image
    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  Widget _showImage() {
    /// todo-show-01: change widget to show the image
    final imagePath = context.read<ShowImageProvider>().imagePath;
    return kIsWeb
        ? Image.network(
            imagePath.toString(),
            fit: BoxFit.contain,
          )
        : Image.file(
            File(imagePath.toString()),
            fit: BoxFit.contain,
          );
  }
}
