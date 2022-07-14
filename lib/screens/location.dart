import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pmc_app/screens/location_service.dart';
import 'package:geocoder/geocoder.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final searchNode = FocusNode();
  double? myAdress;
  TextEditingController _searchController = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  static final Marker _kGooglePlexMarker = Marker(
    markerId: MarkerId('_kGooglePlex'),
    infoWindow: InfoWindow(title: 'Google Plex'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(37.42796133580664, -122.085749655962),
  );

  Set<Marker> markers = {
    Marker(
      markerId: MarkerId('_kGooglePlex'),
      infoWindow: InfoWindow(title: 'Google Plex'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(37.42796133580664, -122.085749655962),
    )
  };

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_searchController.text != null) {
          Navigator.pop(context, _searchController.text);
          return true;
        }
        return false;
      },
      child: SafeArea(
        child: new Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _searchController,
                      focusNode: searchNode,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(hintText: 'search'),
                      onFieldSubmitted: (text) {
                        if (_searchController.text != null) {
                          getLocation(_searchController.text);
                        }
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        if (_searchController.text != null) {
                          setState(() {
                            searchNode.unfocus();
                          });
                          getLocation(_searchController.text);
                        }
                      },
                      icon: Icon(Icons.search))
                ],
              ),
              Expanded(
                child: GoogleMap(
                  markers: markers,
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  onTap: (args) async {
                    print(args.latitude);
                    setState(() {
                      markers.add(Marker(
                        markerId: MarkerId('_kGooglePlex'),
                        infoWindow: InfoWindow(title: 'Google Plex'),
                        icon: BitmapDescriptor.defaultMarker,
                        position: LatLng(args.latitude, args.longitude),
                      ));
                    });
                    final coordinates =
                        new Coordinates(args.latitude, args.longitude);
                    var addresses = await Geocoder.local
                        .findAddressesFromCoordinates(coordinates);
                    var first = addresses.first;
                    print("${first.featureName} : ${first.addressLine}");
                    setState(() {
                      _searchController.text = first.addressLine;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getLocation(String address) async {
    final GoogleMapController controller = await _controller.future;

    var addresses = await Geocoder.local.findAddressesFromQuery(address);
    var first = addresses.first;
    print("${first.featureName} : ${first.coordinates}");
    myAdress = first.coordinates.latitude;
    print("Latitude: ${first.coordinates.latitude}");
    print("Longitude: ${first.coordinates.longitude}");
    if (first.coordinates.latitude != null &&
        first.coordinates.longitude != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
              LatLng(first.coordinates.latitude!, first.coordinates.longitude!),
          zoom: 12)));
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          markers.add(Marker(
            markerId: MarkerId('_kGooglePlex'),
            infoWindow: InfoWindow(title: 'Google Plex'),
            icon: BitmapDescriptor.defaultMarker,
            position: LatLng(
                first.coordinates.latitude!, first.coordinates.longitude!),
          ));
          print("^^^^^^^^^^^^^^^^^^^^^^^");
        });
      });
    }
  }

  Future<void> _goToPlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12)));
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
