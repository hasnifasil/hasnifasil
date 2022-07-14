import 'dart:io';
import 'dart:ui';

import 'package:image_picker/image_picker.dart';
import 'package:pmc_app/API/constats/styles.dart';
import 'package:pmc_app/screens/dashboard.dart';
import 'package:pmc_app/screens/all_orders.dart';
import 'package:pmc_app/screens/location.dart';
import 'package:pmc_app/screens/screen_payment.dart';
import 'package:pmc_app/screens/screen_splas.dart';
import 'package:pmc_app/screens/wishlist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:pmc_app/profile/contact.dart';
import 'package:pmc_app/screens/language_select.dart';
import 'package:pmc_app/screens/screen_login.dart';
import 'package:pmc_app/screens/settings.dart';
import 'package:share/share.dart';
import 'package:easy_localization/easy_localization.dart';

class ScreenProfile extends StatefulWidget {
  const ScreenProfile({Key? key}) : super(key: key);

  @override
  State<ScreenProfile> createState() => _ScreenProfileState();
}

class _ScreenProfileState extends State<ScreenProfile> {
  String emaill="";
  bool isShow = false;
  bool islog = true;
  File? image;
  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }
    final imageTemp = File(image.path);
    setState(() {
      this.image = imageTemp;
    });
  }

  @override
  void initState() {
    getUserLoginOrNot();
    getLog();
    getToken();
    getEmail();
    super.initState();
  }

  String login = '0';

  getUserLoginOrNot() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? user_login_flag = pref.getString('user_login_flag');
    if (user_login_flag != null) {
      login = user_login_flag;
    }
  }

  Future getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = (prefs.getString('token'));
    if (token != null) {
      if (mounted) {
        setState(() {
          isShow = true;
        });
      } else {
        setState(() {
          isShow = false;
        });
      }
    }
  }

  Future getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    if (token != null) {
      emaill = prefs.getString('email')!;
      print(emaill);
      print('${emaill[0]}');
    }
  }

  Future getLog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = (prefs.getString('token'));
    if (token != null) {
      if (mounted) {
        setState(() {
          islog = false;
        });
      } else {
        setState(() {
          islog = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Material(
            color: white,
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(2),
                child: Column(
                  children: [
                    Visibility(
                      visible: isShow,
                      child: Container(
                        child: Column(children: [
                          if (isShow)
                            Container(
                              height: 140,
                              width: double.infinity,
                              child: Center(
                                  child: Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primaryColor,
                                ),
                                child: Center(
                                  child: Text(
                                    '${emaill[0]}'.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 44,
                                        fontWeight: FontWeight.bold,
                                        color: white),
                                  ),
                                ),
                              )),
                            ),
                          if (isShow)
                            Align(
                              alignment: Alignment.topCenter,
                              child: Center(
                                  child: Text(
                                emaill,
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              )),
                            ),
                          if (isShow)
                            SizedBox(
                              height: 30,
                            )
                        ]),
                      ),
                    ),
                    if (isShow)
                      Divider(
                        thickness: 4,
                      ),
                    SizedBox(
                      height: 25,
                    ),
                    Visibility(
                        visible: islog,
                        child: Container(
                            height: 160,
                            child: Center(
                                child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Image.asset(
                                  "assets/images/appbaar.jpeg",
                                  height: 80,
                                  width: 90,
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  'welcome_to_pmc'.tr(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                                if (islog)
                                  SizedBox(
                                    height: 10,
                                  ),
                              ],
                            )))),
                    Visibility(visible: islog, child: Divider(thickness: 3)),
                    Visibility(
                        visible: islog,
                        child: SizedBox(
                          height: 20,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Column(
                          children: [
                            Visibility(
                              visible: islog,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ScreenLogin()));
                                },
                                child: ListTile(
                                  leading: iconDrawer(Icons.person),
                                  title: Text('account'.tr(),
                                      style: drawerTextsStyle()),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Visibility(
                              visible: isShow,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              AccountInfo()));
                                },
                                child: ListTile(
                                  leading: iconDrawer(Icons.person),
                                  title: Text('account'.tr(),
                                      style: drawerTextsStyle()),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            InkWell(
                              onTap: () {
                                Share.share('check out my app https://example.com',
                                    subject: 'Look what I made!');
                              },
                              child: ListTile(
                                leading: iconDrawer(Icons.share),
                                title: Text('share_app'.tr(),
                                    style: drawerTextsStyle()),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            InkWell(
                              onTap: () async {
                                if (Platform.isAndroid) {
                                  if (!await launch(
                                      "https://play.google.com/store/apps/details?id=com.linkedin.android"))
                                    throw 'Could not launch ';
                                } else if (Platform.isIOS) {
                                  if (!await launch("")) throw 'Could not launch ';
                                }
                              },
                              child: ListTile(
                                leading: iconDrawer(Icons.star_border),
                                title:
                                    Text('rate_us'.tr(), style: drawerTextsStyle()),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            InkWell(
                              onTap: () {
                                // Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Contact()));
                              },
                              child: ListTile(
                                leading: iconDrawer(Icons.messenger_sharp),
                                title: Text('contact_us'.tr(),
                                    style: drawerTextsStyle()),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            InkWell(
                              onTap: () {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LanguageSelection()));
                                });
                              },
                              child: ListTile(
                                leading: iconDrawer(Icons.language),
                                title: Text('language'.tr(),
                                    style: drawerTextsStyle()),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            InkWell(
                              onTap: () {
                                String url = privacypolicy;
                                launch(url);
                              },
                              child: ListTile(
                                leading: iconDrawer(Icons.policy),
                                title: Text('privacy_policy'.tr(),
                                    style: drawerTextsStyle()),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            // Visibility(
                            //   visible: isShow,
                            //   child: 
                            //   InkWell(
                            //     onTap: () {
                            //       signOut();
                            //       Navigator.of(context).pop();
                            //       Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //               builder: (context) => Splash(
                            //                     login: "0",
                            //                   )));
                            //     },
                            //     child: ListTile(
                            //       leading: iconDrawer(Icons.logout_outlined),
                            //       title: Text('sign_out'.tr(),
                            //           style: drawerTextsStyle()),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

 
}
