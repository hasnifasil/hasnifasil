import 'package:badges/badges.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pmc_app/API/constats/styles.dart';
import 'package:pmc_app/models/cart_provider.dart';
import 'package:pmc_app/models/wish_provider.dart';
import 'package:pmc_app/profile/sign_up.dart';
import 'package:pmc_app/provider/cart_length_provider.dart';
import 'package:pmc_app/provider/selling_api_provider.dart';
import 'package:pmc_app/screens/dashboard.dart';

import 'package:pmc_app/screens/notifications.dart';
import 'package:pmc_app/screens/screen_login.dart';
import 'package:pmc_app/screens/screen_splas.dart';
import 'package:pmc_app/screens/screen_cart.dart';

import 'package:pmc_app/screens/screen_home.dart';
import 'package:http/http.dart' as http;
import 'package:pmc_app/screens/screen_profile.dart';
import 'package:pmc_app/screens/screen_search.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:pmc_app/screens/screens.dart';
import 'package:pmc_app/screens/wishlist.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Screens extends StatefulWidget {
  const Screens({Key? key}) : super(key: key);

  @override
  _ScreensState createState() => _ScreensState();
}

class _ScreensState extends State<Screens> {
  String? emaill;
  Future getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    if (token != null) {
      emaill = prefs.getString('email');
      print(emaill);
      print('${emaill![0]}');
    }
  }

  int _currentSelectedIndex = 0;
  final _pages = [
    ScreenHome(),
    ScreenProfile(),
    WishList(),
    ScreenCart(),
    Notifications()
  ];
  final items = [
    Image.asset(
      'assets/images/iconPmc.png',
      height: 40,
      width: 40,
      fit: BoxFit.cover,
    ),
    Icon(
      Icons.person_outline,
      color: white,
    ),
    Badge(
        position: BadgePosition(
          bottom: 7,
          start: 19,
        ),
        showBadge: true,
        badgeContent: Consumer<WishProvider>(
          builder: (context, value, child) {
            return Text(value.getCounter().toString(),
                style: TextStyle(color: white));
          },
        ),
        animationType: BadgeAnimationType.fade,
        animationDuration: Duration(milliseconds: 300),
        child: Icon(
          Icons.favorite_border,
          color: white,
        )),
    Badge(
        position: BadgePosition(bottom: 7, start: 19),
        showBadge: true,
        badgeContent: Consumer<CartLengthProvider>(
          builder: (context, value, child) {
            return Text(value.cartLength.toString(),
                style: TextStyle(color: white));
          },
        ),
        animationType: BadgeAnimationType.fade,
        animationDuration: Duration(milliseconds: 300),
        child: Icon(Icons.shopping_cart_outlined, color: white)),
    Icon(
      Icons.notifications,
      color: white,
    )
  ];

  @override
  void initState() {
    getEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        body: _pages[_currentSelectedIndex],
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(.5),
          child: CurvedNavigationBar(
              animationCurve: Curves.easeOutQuart,
              color: primaryColor,
              buttonBackgroundColor: primaryColor,
              backgroundColor: Colors.transparent,
              height: 50,
              items: items,
              index: _currentSelectedIndex,
              onTap: (_currentSelectedIndex) => setState(() {
                    this._currentSelectedIndex = _currentSelectedIndex;
                  })),
        ),
      ),
    );
  }
}
