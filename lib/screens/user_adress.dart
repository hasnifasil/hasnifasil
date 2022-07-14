import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pmc_app/API/constats/constant_api.dart';
import 'package:pmc_app/API/constats/styles.dart';
import 'package:pmc_app/models/user_address.model.dart';
import 'package:pmc_app/screens/add_address.dart';
import 'package:pmc_app/screens/checkout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAddresss extends StatefulWidget {
  const UserAddresss({Key? key}) : super(key: key);

  @override
  _UserAddresssState createState() => _UserAddresssState();
}

class _UserAddresssState extends State<UserAddresss> {
  List<Adress> list = [];

  @override
  void initState() {
    getAllOrderList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('address'.tr()),
        ),
        body: Column(
          children: [
            InkWell(
                onTap: () async {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => AddAddress()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                    ),
                    width: double.infinity,
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'add_new_adress'.tr(),
                          style: TextStyle(
                              color: white, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                )),
            Container(
                child: Expanded(
              child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return list.length == 0
                        ? Text('')
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 220,
                                child: InkWell(
                                  onTap: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();

                                    prefs.setString(
                                        'add_id', list[index].id.toString());
                                    prefs.setString('name', list[index].name);
                                    prefs.setString(
                                        'building', list[index].building);
                                    prefs.setString(
                                        'street', list[index].street);
                                    prefs.setString('zone', list[index].zone);
                                    prefs.setString(
                                        'address', list[index].street);
                                    prefs.setString('city', list[index].city);
                                    prefs.setString(
                                        'floor', list[index].floorNumber);
                                    // prefs.setString('street', list[list.length ].streetNumber);

                                    prefs.setString(
                                        'phones', list[index].mobile);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CheckoutScreen()));
                                  },
                                  child: Card(
                                    elevation: 7,
                                    color: Colors.grey[300],
                                    margin: EdgeInsets.all(10),
                                    child: Container(
                                        child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('name'.tr() +
                                              "  :" +
                                              list[index].name),
                                          Text('phone'.tr() +
                                              "  : " +
                                              "974" +
                                              list[index].mobile.toString()),
                                          Text('Qatar'),
                                          Text('street_number'.tr() +
                                              "  :" +
                                              list[index].street),
                                          Text('building_number'.tr() +
                                              "  :" +
                                              list[index].building.toString()),
                                          Text('city'.tr() +
                                              "  :" +
                                              list[index].city.toString()),
                                          Text('zone'.tr() +
                                              "  :" +
                                              list[index].zone.toString()),
                                        ],
                                      ),
                                    )),
                                  ),
                                ),
                              ),
                            ],
                          );
                  }),
            )),
          ],
        ),
      ),
    );
  }

  Future<UserAddress?> getAllOrderList() async {
    setState(() {
      list.clear();
      //isLoading = true;
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
        if (list.length != 0) {
          prefs.setString('name', list[list.length - 1].name);
          prefs.setString('building', list[list.length - 1].building);
          prefs.setString('street', list[list.length - 1].street);
          prefs.setString('zone', list[list.length - 1].zone);
          prefs.setString('address', list[list.length - 1].street);
          prefs.setString('city', list[list.length - 1].city);
          prefs.setString('floor', list[list.length - 1].floorNumber);
          // prefs.setString('street', list[list.length ].streetNumber);

          prefs.setString('phones', list[list.length - 1].mobile);
        }

        print(dataa);
      });
    } else {}
  }
}
