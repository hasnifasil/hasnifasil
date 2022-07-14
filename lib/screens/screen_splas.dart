import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:pmc_app/API/constats/styles.dart';

import 'package:pmc_app/screens/language_select.dart';

import 'package:pmc_app/screens/screen_login.dart';
import 'package:pmc_app/screens/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  String login;

  Splash({Key? key, required this.login}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String login = '0';

  @override
  void initState() {
    login = widget.login;
    // TODO: implement initState
    getUserLoginOrNot();

    super.initState();
  }

  getUserLoginOrNot() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? user_login_flag = pref.getString('user_login_flag');
    if (user_login_flag == null) {
      pref.setString("user_login_flag", '0');
    }
    print(user_login_flag);
    if (user_login_flag == '0' && user_login_flag != null) {
      setState(() {
        login = '0';
      });
    } else if (user_login_flag == '1' && user_login_flag != null) {
      setState(() {
        login = '1';
      });
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Screens()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        body: login == "0"
            ? Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LanguageSelection()));
                          },
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.language,
                                  color: white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'language'.tr(),
                                  style: TextStyle(color: white),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 158.0),
                          child: Container(
                            decoration: BoxDecoration(),
                            child: SvgPicture.asset("assets/images/Pmc.svg",
                                fit: BoxFit.cover, height: 90, width: 200),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 60.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ScreenLogin()));
                              },
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 60,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: yellow,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    height: 40,
                                    width: 260,
                                    child: Center(
                                        child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 35.0, right: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'login_to_pmc'.tr(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Icon(Icons.arrow_forward_outlined)
                                        ],
                                      ),
                                    )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: InkWell(
                                        onTap: () async {
                                          SharedPreferences prf =
                                              await SharedPreferences
                                                  .getInstance();
                                          prf.setString("user_login_flag", "1");

                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Screens()));
                                        },
                                        child: Text(
                                          'continue_as_guest'.tr(),
                                          style: TextStyle(
                                              color: white, fontSize: 15),
                                        ),
                                        // icon: Icon(Icons.cancel),
                                        // iconSize: 35,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
              )
            : Stack(children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(),
                    child: SvgPicture.asset("assets/images/Pmc.svg",
                        fit: BoxFit.cover, height: 90, width: 200),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 35.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      color: Colors.yellow[400],
                      backgroundColor: Colors.white,
                    ),
                  ),
                )
              ]),
      ),
    );
  }
}
