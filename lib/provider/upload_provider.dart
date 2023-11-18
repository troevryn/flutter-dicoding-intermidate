import 'package:declarative_route/api/api_service.dart';
import 'package:declarative_route/model/error.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

/// todo-03-upload-03: create UploadProvider file
class UploadProvider extends ChangeNotifier {
  final ApiService apiService;
  UploadProvider({
    required this.apiService,
  });

  /// todo-03-upload-04: to handle upload state
  bool isUploading = false;
  String message = "";
  ErrorResponse? uploadResponse;
  String description = "";
  bool error = false;
  double? _lat = -6.8957473;
  double? _log = 107.6337669;
void addLatLog(lat,log){
  _lat=lat;
  _log=log;
  notifyListeners();
}
  /// todo-03-upload-05: create a function to handle upload
  Future<void> upload(
    List<int> bytes,
    String fileName,
    String description,
  ) async {
    try {
      message = "";
      uploadResponse = null;
      isUploading = true;
      notifyListeners();

      uploadResponse = await apiService.postStory(bytes, fileName, description,_lat,_log);
      message = uploadResponse?.message ?? "success";
      isUploading = false;

      notifyListeners();
    } catch (e) {
      isUploading = false;
      message = e.toString();
      error = true;
      notifyListeners();
    }
  }

  /// todo-05-compress-02: add new function to handle a image compress
  Future<List<int>> compressImage(List<int> bytes) async {
    int imageLength = bytes.length;
    if (imageLength < 1000000) return bytes;

    final img.Image image = img.decodeImage(bytes)!;
    int compressQuality = 100;
    int length = imageLength;
    List<int> newByte = [];

    do {
      ///
      compressQuality -= 10;

      newByte = img.encodeJpg(
        image,
        quality: compressQuality,
      );

      length = newByte.length;
    } while (length > 1000000);

    return newByte;
  }

  Future<List<int>> resizeImage(List<int> bytes) async {
    int imageLength = bytes.length;
    if (imageLength < 1000000) return bytes;

    final img.Image image = img.decodeImage(bytes)!;
    bool isWidthMoreTaller = image.width > image.height;
    int imageTall = isWidthMoreTaller ? image.width : image.height;
    double compressTall = 1;
    int length = imageLength;
    List<int> newByte = bytes;

    do {
      ///
      compressTall -= 0.1;

      final newImage = img.copyResize(
        image,
        width: isWidthMoreTaller ? (imageTall * compressTall).toInt() : null,
        height: !isWidthMoreTaller ? (imageTall * compressTall).toInt() : null,
      );

      length = newImage.length;
      if (length < 1000000) {
        newByte = img.encodeJpg(newImage);
      }
    } while (length > 1000000);

    return newByte;
  }
}
