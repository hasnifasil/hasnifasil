import 'dart:convert';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:pmc_app/models/cart_model.dart';
import 'package:pmc_app/models/cart_provider.dart';
import 'package:pmc_app/models/db_helper.dart';
import 'package:pmc_app/screens/all_orders.dart';
import 'package:pmc_app/screens/user_adress.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

//splash screen logo
const String logo = 'assets/images/pmcimg.jpeg';

Color primaryColor = Color(0xFF3274a2);
Color black = Colors.black;
Color red = Colors.red;
Color yellow = Color(0xFFFbbb24);
Color white = Colors.white;
Color grey = Colors.grey;
Color green = Colors.green;
bool isAddtoCartCalled = false;

String phone = '974-44419222';
String email = "info@pharmacyandmore.com";
String privacypolicy = "https://www.pmc.qa/privacy-policy-1";

//Empty cart Image
String cartImg = 'assets/images/empty-cart.jpg';

//text style of drawer,text style of product name

TextStyle drawerTextsStyle() {
  return TextStyle(
    fontSize: 18,
    color: black,
  );
}

//share icon style and function

shareIcon(String name) {
  return IconButton(
    onPressed: () {
      Share.share(name, subject: 'Buy Products from PMC');
    },
    icon: Icon(
      Icons.share,
      color: grey,
    ),
  );
}
//view all products card style

cardStyle() {
  return BeveledRectangleBorder(borderRadius: BorderRadius.circular(10));
}

containerBox() {
  return BoxDecoration(
    color: white,
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15), topRight: Radius.circular(15)),
  );
}

//latest product,most selling//featured product container style
products(String name, String image, String price) {
  return Container(
    decoration: BoxDecoration(boxShadow: [
      BoxShadow(
          color: Color.fromARGB(239, 196, 194, 194),
          spreadRadius: 3,
          blurRadius: 3)
    ], borderRadius: BorderRadius.circular(19), color: Colors.white),
    margin: EdgeInsets.all(10),
    height: double.infinity,
    width: 140,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 10,
        ),(image!=null&&image.isNotEmpty)?
        Image.memory(base64.decode(image)
          ,
          gaplessPlayback: true,
          height: 100,
        ):Container(height: 90,child: Image.asset(
                  "assets/images/no_img.png",
                  gaplessPlayback: true,
                ),),
        SizedBox(
          height: 3,
        ),
        Container(
          height: 40,
          color: Colors.grey[200],
          child: Center(
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.5),
            ),
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'QAR  ' + price,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        )
      ],
    ),
  );
}

//drawer Icon style
iconDrawer(IconData icon) {
  return Container(
    height: 32,
    width: 32,
    decoration: BoxDecoration(shape: BoxShape.circle, color: primaryColor),
    child: Icon(
      icon,
      color: white,
      size: 22,
    ),
  );
}

//fade shimmer for latest,featured,selling products
fadeshimmer() {
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: 6,
    itemBuilder: ((context, index) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(19)),
          child: FadeShimmer(
            height: 140,
            width: 150,
            radius: 4,
            highlightColor: Color.fromARGB(255, 174, 174, 179),
            baseColor: Color.fromARGB(255, 215, 227, 240),
          ),
        ),
      );
    }),
  );
}

//grid view fade shimmer

gridFadeShimmer() {
  return Container(
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(19)),
    child: GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250, childAspectRatio: 2 / 3),
      itemCount: 10,
      itemBuilder: ((context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeShimmer(
              height: 180,
              width: 180,
              radius: 4,
              highlightColor: Color.fromARGB(255, 174, 174, 179),
              baseColor: Color.fromARGB(255, 215, 227, 240),
            ),
          ),
        );
      }),
    ),
  );
}
//dashboard  widgets

dashBoard(BuildContext context){
  return  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Container(
                   
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AllOrders()));
                          },
                          leading: iconDrawer(Icons.list),
                          title: Text(
                            'my_orders'.tr(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        UserAddresss()));
                          },
                          leading: iconDrawer(Icons.location_city),
                          title: Text('my_address'.tr(),
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                       
                      ],
                    ),
                  ),
                ]);
}

//fade shimmer list
fadeShimmerList(){
  return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: 6,
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(19)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: FadeShimmer(
                                      height: 110,
                                      width: 70,
                                      radius: 4,
                                      highlightColor:
                                          Color.fromARGB(255, 174, 174, 179),
                                      baseColor:
                                          Color.fromARGB(255, 215, 227, 240),
                                    ),
                                  ),
                                  title: FadeShimmer(
                                    height: 70,
                                    width: 300,
                                    radius: 4,
                                    highlightColor:
                                        Color.fromARGB(255, 174, 174, 179),
                                    baseColor:
                                        Color.fromARGB(255, 215, 227, 240),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      );
}


// sign out function


 Future signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('name');
    prefs.remove('address');
    prefs.remove('street');
    prefs.remove('zone');
    prefs.remove('building');
    prefs.remove('city');
    prefs.remove('phones');
    prefs.remove('floor');

    prefs.setString("user_login_flag", "0");
   
  }
