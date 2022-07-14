import 'dart:convert';

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:pmc_app/API/constats/constant_api.dart';
import 'package:flutter/material.dart';
import 'package:pmc_app/API/constats/styles.dart';
import 'package:pmc_app/models/cart_model.dart';
import 'package:pmc_app/models/cart_provider.dart';
import 'package:pmc_app/models/db_helper.dart';
import 'package:pmc_app/models/read_cart_data_model.dart';
import 'package:pmc_app/models/user_address.model.dart';
import 'package:pmc_app/provider/cartListing_provider.dart';
import 'package:pmc_app/screens/location.dart';
import 'package:pmc_app/screens/order_succesfull.dart';
import 'package:pmc_app/screens/screen_cart.dart';
import 'package:pmc_app/screens/screen_payment.dart';
import 'package:pmc_app/screens/screens.dart';
import 'package:pmc_app/screens/user_adress.dart';
import 'package:provider/provider.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutScreen extends StatefulWidget {
  //Function? set;

  CheckoutScreen({
    Key? key,
  }) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  DBHelper dbHelper = DBHelper();
  UserAddresss userAddress = UserAddresss();

  final _namecontrller = TextEditingController();
  final _phonecontrller = TextEditingController();
  final _floorcontrller = TextEditingController();
  final _buildingcontrller = TextEditingController();
  final _streetcontrller = TextEditingController();
  final _zonecontrller = TextEditingController();
  final _adresscontrller = TextEditingController();
  final _citycontrller = TextEditingController();
  String name = "",
      phone = "",
      floor = "",
      building = "",
      street = "",
      zone = "",
      adress = "",
      city = "",
      token = "";
  int currentStep = 0;
  int _value = 0;
  int _val = 0;
  int dc = 20;

  final _formKey = GlobalKey<FormState>();
  Location location = Location();
  TextEditingController addressCtlr = TextEditingController();
  List<Adress> list = [];
  double? latittude;
  double? longitude;
  bool value = false;
  bool checkValue = false;
  singleCheckbox() {
    return Row(
      children: [
        Checkbox(
            value: checkValue,
            onChanged: (newValue) {
              setState(() {
                checkValue = !checkValue;
              });
            }),
        Column(
          children: [
            Text('agree_to_term_and_condition'.tr()),
            InkWell(
              onTap: () {
                String url = privacypolicy;
                launch(url);
              },
              child: Text(
                'read terms and conditions',
                style: TextStyle(color: primaryColor, fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
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

  transactionCreate() {
    if (_val == 1) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Successfull()));
    } else if (_val == 2) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Payment()));
    }
  }

  bool isLoadingCart = true;
  double? totalAmount;
  List<Detail> cartItemsList = [];
  getCartListItems() async {
    cartItemsList.clear();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final sale_id = prefs.getInt('sale_id') ?? "";
    Dio dio = Dio();

    final response =
        await dio.get(base_url + 'api/read/cart/data?sale_id=$sale_id');

    if (response.statusCode == 200) {
      Map<dynamic, dynamic> map = Map<String, dynamic>.from(response.data);
      print(response.data);
      if (map['total_amount'] != null) {
        setState(() {
          isLoadingCart = false;
          totalAmount = map['total_amount'] ?? 0.0;

          print(totalAmount);
        });
      }

      AllCartItems data = AllCartItems.fromJson(response.data);
      setState(() {
        cartItemsList.addAll(data.details!);
        // isloading = false;
        isLoadingCart = false;
      });

      print(response.data);
    } else {
      print(response.data);
    }
    setState(() {});
  }

  Future createAddress(String name, mobile, floor_number, building,
      street_number, zone, street, city, country) async {
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
        'country': 'QA'
      }
    };

    var formData = FormData.fromMap(data);

    final response =
        await dio.post(base_url + 'api/create/user/address', data: data);

    Map<String, dynamic> map = Map<String, dynamic>.from(response.data);

    if (response.statusCode == 200) {
      print(response.data);
    } else {
      print('unsuccesful');
    }
  }

  Future<UserAddress?> getAllAdressList() async {
    setState(() {
      list.clear();
    });

    Dio dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print(token);
    final response = await dio
        .get(base_url + 'api/user/address', queryParameters: {"token": token});
    print(response.data);
    Map<dynamic, dynamic> map = Map<dynamic, dynamic>.from(response.data);
    if (response.statusCode == 200) {
      UserAddress dataa = UserAddress.fromJson((response.data));

      setState(() {
        list = dataa.data;
        prefs.setString('add_id', list[list.length - 1].id.toString());
        prefs.setString('name', list[list.length - 1].name);
        prefs.setString('building', list[list.length - 1].building);
        prefs.setString('street', list[list.length - 1].street);
        prefs.setString('zone', list[list.length - 1].zone);
        prefs.setString('address', list[list.length - 1].street);
        prefs.setString('city', list[list.length - 1].city);
        prefs.setString('floor', list[list.length - 1].floorNumber);
        prefs.setString('phones', list[list.length - 1].mobile);

        print(dataa);
      });
    } else {}
  }

  bool isShoww = false;
  Future getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;
    if (token != null) {
      name = prefs.getString('name') ?? "";
      phone = prefs.getString('phones') ?? "";
      floor = prefs.getString('floor') ?? "";
      building = prefs.getString('building') ?? "";
      street = prefs.getString('street') ?? "";
      zone = prefs.getString('zone') ?? "";
      city = prefs.getString('city') ?? "";

      print(name);
      setState(() {
        isShoww = true;
      });
    } else {
      setState(() {
        isShoww = false;
      });
    }
  }

  CartProvider? cartList = CartProvider();

  @override
  void initState() {
    getCartListItems();
    arabicSelectedorNot();
    getAllAdressList();

    // TODO: implement initState
    getLocation();
    getEmail();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      cartList = Provider.of<CartProvider>(context, listen: false);
      cartList!.getData();
    });
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: ((context) => ScreenCart())));
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
        body: Stepper(
          steps: getSteps(),
          type: StepperType.vertical,
          currentStep: currentStep,
          onStepCancel: () => currentStep == 0
              ? null
              : setState(() {
                  currentStep -= 1;
                }),
          onStepContinue: () {
            final isLastStep = currentStep == getSteps().length - 1;

            if (isLastStep) {
              if (checkValue == true) {
                print('completed');

                transactionCreate();
              } else {
                setState(() {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: red,
                      margin: EdgeInsets.all(10),
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        'accept_terms_conditions'.tr(),
                        textAlign: TextAlign.center,
                      )));
                });
              }
            } else if (currentStep == 0) {
              setState(() {
                if (!isShoww) {
                  if (_formKey.currentState!.validate() && (currentStep == 0)) {
                    createAddress(
                        _namecontrller.text,
                        _phonecontrller.text,
                        _floorcontrller.text,
                        _buildingcontrller.text,
                        _streetcontrller.text,
                        _zonecontrller.text,
                        _streetcontrller.text,
                        _citycontrller.text,
                        'QA');

                    currentStep < getSteps().length - 1
                        ? currentStep += 1
                        : currentStep = 0;
                  }
                } else if (isShoww && name != null && name.isNotEmpty) {
                  currentStep < getSteps().length - 1
                      ? currentStep += 1
                      : currentStep = 0;
                } else {
                  setState(() {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: red,
                        margin: EdgeInsets.all(10),
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                          'enter_valid_addres'.tr(),
                          textAlign: TextAlign.center,
                        )));
                  });
                }
              });
            } else if (currentStep == 1 && _value == 1) {
              setState(() {
                currentStep < getSteps().length - 1
                    ? currentStep += 1
                    : currentStep = 0;
              });
            } else if (currentStep == 2) {
              if (_val == 1 || _val == 2) {
                setState(() {
                  currentStep < getSteps().length - 1
                      ? currentStep += 1
                      : currentStep = 0;
                });
              } else {
                setState(() {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: red,
                      margin: EdgeInsets.all(10),
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        'select_payment_method'.tr(),
                        textAlign: TextAlign.center,
                      )));
                });
              }
            }
          },
        ));
  }

  getLocationManually(String add) async {
    var addresses = await Geocoder.local.findAddressesFromQuery(add);
    var first = addresses.first;
    print("${first.featureName} : ${first.coordinates}");
    setState(() {
      latittude = first.coordinates.latitude;
      longitude = first.coordinates.longitude;
    });
  }

  List<Step> getSteps() => [
        Step(
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 0,
            title: Text('address'.tr()),
            content: (isShoww)
                ? Card(
                    elevation: 7,
                    child: Column(
                      children: [
                        Container(
                          color: grey,
                          height: 30,
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              'delivery_to_this_adress'.tr(),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'name'.tr() + "  :" + name,
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              'phone'.tr() + "  :" + phone,
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              'building_number'.tr() + "  :" + building,
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              'street_number'.tr() + "  :" + street,
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              'zone'.tr() + "  :" + zone,
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              'floor'.tr() + "  :" + floor,
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              'city'.tr() + "  :" + city,
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                          color: grey,
                        ),
                        InkWell(
                          child: Container(
                            height: 30,
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isShoww = false;
                                    });
                                  },
                                  child: Text(
                                    'add_new_adress'.tr(),
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  width: 1,
                                  color: grey,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UserAddresss()));
                                  },
                                  child: Text(
                                    'select_address'.tr(),
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ))
                : Form(
                    key: _formKey,
                    child: Container(
                      height: MediaQuery.of(context).size.height * .70,
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 25,
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
                                labelText: "your_name".tr(),
                              )),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                prefixText: 'qatar'.tr(),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: red)),
                                labelText: "qatar".tr(),
                              )),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                              validator: (value) {
                                if (value!.length != 8) {
                                  return "enter_valid_phone_num".tr();
                                } else if (value == null || value.isEmpty) {
                                  return 'enter_valid_phone_num'.tr();
                                } else {
                                  return null;
                                }
                              },
                              controller: _phonecontrller,
                              maxLength: 11,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.phone),
                                prefixText: (languageArabic) ? "" : '+974',
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
                              String add = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => MapSample()));
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
                                              getAddressFromLatLan(
                                                  value.latitude!,
                                                  value.longitude!);
                                            });
                                          },
                                          icon: Icon(Icons.location_on_sharp)),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: 265,
                                      child: TextField(
                                        style: TextStyle(),
                                        controller: addressCtlr,
                                        enabled: false,
                                        decoration: InputDecoration(
                                            hintText: 'address'.tr()),
                                        onChanged: getLocationManually,
                                      ),
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
                  )),
        Step(
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 1,
            title: Text('delivery'.tr()),
            content: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'select_delivery_method'.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Radio(
                          value: 1,
                          groupValue: _value,
                          onChanged: (value) {
                            setState(() {
                              _value = 1;
                            });
                          }),
                      Expanded(
                        child: Text(
                          'delivery_charge_based_on_location'.tr() +
                              "\n(QAR 20.00)",
                          style: TextStyle(fontSize: 17),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )),
        Step(
            state: currentStep > 2 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 2,
            title: Text('payment'.tr()),
            content: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'select_a_payment_method'.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Radio(
                          value: 2,
                          groupValue: _val,
                          onChanged: (value) {
                            setState(() {
                              _val = 2;
                            });
                          }),
                      Text(
                        'credit_card'.tr(),
                        style: TextStyle(fontSize: 17),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                          value: 1,
                          groupValue: _val,
                          onChanged: (value) {
                            setState(() {
                              _val = 1;
                            });
                          }),
                      Text(
                        'cash_on_delivery'.tr(),
                        style: TextStyle(fontSize: 17),
                      )
                    ],
                  )
                ],
              ),
            )),
        Step(
            state: currentStep > 3 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 3,
            title: Text('review'.tr()),
            content: Container(
              height: 500,
              child: Column(
                children: [
                  Container(child: Consumer<CartListProvider>(
                      builder: (context, snapshot, _) {
                    return Expanded(
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: snapshot.getCartList.length,
                          itemBuilder: (context, index) {
                            // print(snapshot.data![index].image);
                            return Card(
                              margin: EdgeInsets.all(7),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        snapshot.getCartList[index].image !=
                                                    null &&
                                                snapshot.getCartList[index]
                                                    .image!.isNotEmpty
                                            ? Image.memory(
                                                base64Decode(
                                                  snapshot.getCartList[index]
                                                      .image!,
                                                ),
                                                width: 100,
                                                height: 100,
                                              )
                                            : Container(
                                                height: 100,
                                                width: 100,
                                                child: Image.asset(
                                                  "assets/images/no_img.png",
                                                  gaplessPlayback: true,
                                                ),
                                              ),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    snapshot
                                                        .getCartList[index].name
                                                        .toString(),
                                                    maxLines: 3,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        overflow:
                                                            TextOverflow.clip),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                r"QAR" +
                                                    snapshot.getCartList[index]
                                                        .price!
                                                        .toStringAsFixed(2),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    );
                  })),
                  singleCheckbox(),
                  Visibility(
                    visible: totalAmount.toString() == "0.00" ? false : true,
                    child: Column(
                      children: [
                        ReusableWidget(
                          title: 'sub_total'.tr(),
                          value: r'QAR' + totalAmount.toString(),
                        ),
                        ReusableWidget(
                          title: 'delivery_charge'.tr(),
                          value: r'QAR' "20.00",
                        ),
                        // ReusableWidget(
                        //     title: 'total'.tr(),
                        //     value: r'QAR' + "${totalAmount + 20}")
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ];
}

class ReusableWidget extends StatelessWidget {
  String title, value;

  ReusableWidget({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        title,
        style: Theme.of(context).textTheme.subtitle2,
      ),
      Text(
        value.toString(),
        style: Theme.of(context).textTheme.subtitle2,
      ),
    ]);
  }
}
