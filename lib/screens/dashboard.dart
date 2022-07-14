import 'package:badges/badges.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pmc_app/API/constats/styles.dart';
import 'package:pmc_app/models/all_order_model.dart';
import 'package:pmc_app/models/user_address.model.dart';
import 'package:pmc_app/models/wish_provider.dart';
import 'package:pmc_app/screens/all_orders.dart';
import 'package:pmc_app/screens/screen_cart.dart';
import 'package:pmc_app/screens/user_adress.dart';
import 'package:pmc_app/screens/wishlist.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({Key? key}) : super(key: key);

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  bool isLoading = false;
  String? emaill;

  @override
  void initState() {
    super.initState();
  }

  Future getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    emaill = prefs.getString('email');
    print(emaill);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text('dashboard'.tr()),
            ),
            body: Container(
                child:dashBoard(context))));
  }
}
