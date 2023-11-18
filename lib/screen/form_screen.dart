import 'dart:io';
import 'package:declarative_route/common.dart';
import 'package:declarative_route/common/flavor_config.dart';
import 'package:declarative_route/provider/image_provider.dart';
import 'package:declarative_route/provider/upload_provider.dart';
import 'package:declarative_route/widget/Snackbar.dart';
import 'package:declarative_route/widget/placemark_widget.dart';
import 'package:declarative_route/widget/platform_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart';

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
  final dicodingOffice = const LatLng(-6.8957473, 107.6337669);
  late final Set<Marker> markers = {};
  geo.Placemark? placemark;
  late GoogleMapController mapController;

  @override
  void dispose() {
    descriptionController.dispose();
    mapController.dispose();
    super.dispose();
  }

  Widget _buildList() {
    final contextImageProvider = context.watch<ShowImageProvider>();
    final contextUploadProvider = context.watch<UploadProvider>();

    return SingleChildScrollView(
      child: Column(children: [
        if (FlavorConfig.instance.flavor != FlavorType.free)
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width,
                height: 500,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    zoom: 18,
                    target: dicodingOffice,
                  ),

                  markers: markers,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  myLocationButtonEnabled: false,

                  /// todo-02-12: show the device location's marker
                  myLocationEnabled: true,

                  /// todo-01-03: setup controller and marker
                  /// todo-04-07: do reverse geocoding in onMapCreated callback
                  onMapCreated: (controller) async {
                    final info = await geo.placemarkFromCoordinates(
                        dicodingOffice.latitude, dicodingOffice.longitude);

                    final place = info[0];
                    final street = place.street!;
                    final address =
                        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

                    setState(() {
                      placemark = place;
                    });

                    defineMarker(dicodingOffice, street, address);

                    setState(() {
                      mapController = controller;
                    });
                  },

                  /// todo-03-01: setup callback onLongPress
                  onLongPress: (LatLng latLng) => onLongPressGoogleMap(latLng),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: FloatingActionButton(
                  child: const Icon(Icons.my_location),
                  onPressed: () => onMyLocationButtonPress(),
                ),
              ),
              if (placemark == null)
                const SizedBox()
              else
                Positioned(
                  bottom: 16,
                  right: 16,
                  left: 16,
                  child: PlacemarkWidget(
                    placemark: placemark!,
                  ),
                ),
            ],
          ),
        Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                contextImageProvider.imagePath == null
                    ? const Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.image,
                          size: 100,
                        ),
                      )
                    : _showImage(),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _onGalleryView(),
                      child: const Text("Gallery"),
                    ),
                    ElevatedButton(
                      onPressed: () => _onCameraView(),
                      child: Text(AppLocalizations.of(context)!.buttonCamera),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
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
                        showCustomSnackBar(context,
                            contextUploadProvider.message, Colors.greenAccent);
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
            )),
      ]),
    );
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

  void onLongPressGoogleMap(LatLng latLng) async {
    final uploadProvider = context.read<UploadProvider>();
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    uploadProvider.addLatLog(latLng.latitude, latLng.longitude);
    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    setState(() {
      placemark = place;
    });

    /// todo-03-02: set a marker based on new lat-long
    defineMarker(latLng, street, address);

    /// todo-03-03: animate a map view based on a new latLng
    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  void onMyLocationButtonPress() async {
    /// todo-02-06: define a location variable
    final Location location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    /// todo-02-07: check the location service
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        if (kDebugMode) {
          print("Location services is not available");
        }
        return;
      }
    }

    /// todo-02-08: check the location permission
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        if (kDebugMode) {
          print("Location permission is denied");
        }
        return;
      }
    }

    /// todo-02-09: get the current device location
    locationData = await location.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);

    /// todo-04-03: run the reverse geocoding
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    /// todo-04-04: define a name and address of location
    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    setState(() {
      placemark = place;
    });

    /// todo-02-10: set a marker
    /// todo-04-05: show the information of location's place and add new argument
    defineMarker(latLng, street, address);

    /// todo-02-11: animate a map view based on a new latLng
    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  /// todo--02: define a marker based on a new latLng
  void defineMarker(LatLng latLng, String street, String address) {
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
      infoWindow: InfoWindow(
        title: street,
        snippet: address,
      ),
    );

    /// todo--03: clear and add a new marker
    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }
}
