import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:pmc_app/API/constats/constant_api.dart';
import 'package:pmc_app/API/constats/styles.dart';
import 'package:pmc_app/screens/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  var name, phone;
  TextEditingController addressCtlr = TextEditingController();
  final _namecontrller = TextEditingController();
  final _phonecontrller = TextEditingController();
  final _floorcontrller = TextEditingController();
  final _buildingcontrller = TextEditingController();
  final _streetcontrller = TextEditingController();
  final _zonecontrller = TextEditingController();
  final _adresscontrller = TextEditingController();
  final _citycontrller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Location location = Location();
  double? latittude;
  double? longitude;

  @override
  void initState() {
    getPrefs();
    arabicSelectedorNot();
    // TODO: implement initState
    super.initState();
  }

  bool languageArabic = false;
  arabicSelectedorNot() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
//final lang=prefs.getString('language');
    if (prefs.getString('language') != null) {
      setState(() {
        languageArabic = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add_new_adress'.tr()),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            Form(
              key: _formKey,
              child: Container(
                child: Expanded(
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'enter_your_name'.tr();
                            } else {
                              return null;
                            }
                          },
                          controller: _namecontrller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            labelText: "enter_your_name".tr(),
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            prefixText: 'Qatar',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: red)),
                            labelText: "Qatar",
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                          validator: (value) {
                            if (value!.length != 8) {
                              return "enter_valid_phone_num".tr();
                            } else if (value == null || value.isEmpty) {
                              return 'Enter valid Phone Number';
                            } else {
                              return null;
                            }
                          },
                          controller: _phonecontrller,
                          maxLength: 11,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.phone),
                            prefixText: (languageArabic) ? " " : '974',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            labelText: "telephone".tr(),
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'enter_floor_num'.tr();
                            } else {
                              return null;
                            }
                          },
                          controller: _floorcontrller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            labelText: "floor_number".tr(),
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'enter_your_building_num'.tr();
                            } else {
                              return null;
                            }
                          },
                          controller: _buildingcontrller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            labelText: "building_number".tr(),
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'enter_street_num'.tr();
                            } else {
                              return null;
                            }
                          },
                          controller: _streetcontrller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            labelText: "street_number".tr(),
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'enter_zone_number'.tr();
                            } else {
                              return null;
                            }
                          },
                          controller: _zonecontrller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            labelText: "zone".tr(),
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () async {
                          String add = await Navigator.push(context,
                              MaterialPageRoute(builder: (_) => MapSample()));
                          if (add != null) {
                            setState(() {
                              addressCtlr.text = add;
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue)),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                child: Center(
                                  child: IconButton(
                                      iconSize: 35,
                                      onPressed: () {
                                        getLocation().then((value) {
                                          setState(() {
                                            latittude = value.latitude!;
                                            longitude = value.longitude!;
                                          });
                                          getAddressFromLatLan(value.latitude!,
                                              value.longitude!);
                                        });
                                      },
                                      icon: Icon(Icons.location_on_sharp)),
                                ),
                              ),
                              Container(
                                width: 265,
                                child: TextField(
                                  controller: addressCtlr,
                                  enabled: false,
                                  decoration: const InputDecoration(
                                      hintText: "address"),
                                  //  onChanged: getLocationManually,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'city'.tr();
                            } else {
                              return null;
                            }
                          },
                          controller: _citycontrller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            labelText: "city".tr(),
                          )),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  addAddress(
                      _namecontrller.text,
                      _phonecontrller.text,
                      _floorcontrller.text,
                      _buildingcontrller.text,
                      _streetcontrller.text,
                      _zonecontrller.text,
                      _adresscontrller.text,
                      _adresscontrller.text,
                      _citycontrller.text);
                }
              },
              child: Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                height: 40,
                color: primaryColor,
                child: Text(
                  'add_new_adress'.tr(),
                  style: TextStyle(color: white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<LocationData> getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {}
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {}
    }

    _locationData = await location.getLocation();
    return _locationData;
  }

  getAddressFromLatLan(double lat, double lon) async {
    final coordinates = Coordinates(lat, lon);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");
    setState(() {
      addressCtlr.text = first.addressLine;
    });
  }

  Future addAddress(String name, mobile, floor_number, building, street_number,
      zone, street, city, country) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print(token);
    Dio dio = Dio();
    Map<String, dynamic> data = {
      'token': token,
      "address": {
        'name': name,
        'mobile': mobile,
        'floor_number': floor_number,
        'building': building,
        'street_number': street,
        'zone': zone,
        'street': street,
        'city': city,
        'country': country
      }
    };

    //var formData = FormData.fromMap(data);

    final response =
        await dio.post(base_url + 'api/create/user/address', data: data);

    print(response.data);
    if (response.statusCode == 200) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            margin: EdgeInsets.all(10),
            behavior: SnackBarBehavior.floating,
            content: Text(
              'Address Updated Successfully',
              textAlign: TextAlign.center,
            )));
        Navigator.pop(context);
      });
    }

    Map<String, dynamic> map = Map<String, dynamic>.from(response.data);
  }

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _namecontrller.text = prefs.getString('name') ?? "";
    _phonecontrller.text = prefs.getString('phone') ?? "";
    _streetcontrller.text = prefs.getString('street') ?? "";
    _buildingcontrller.text = prefs.getString('building') ?? "";
    _citycontrller.text = prefs.getString('city') ?? "";
    _zonecontrller.text = prefs.getString('zone') ?? "";
    _floorcontrller.text = prefs.getString('floor') ?? "";
  }
}
