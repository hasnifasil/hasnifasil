import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:pmc_app/API/constats/constant_api.dart';
import 'package:pmc_app/API/constats/styles.dart';

import 'package:pmc_app/screens/screen_login.dart';
import 'package:pmc_app/screens/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();

  final userController = TextEditingController();

  final passwController = TextEditingController();

  final conpassController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    arabicSelectedorNot();
    super.initState();
  }

  bool obsecureText = true;
  bool obsecureText2 = true;
  void toggle() {
    setState(() {
      obsecureText = !obsecureText;
    });
  }

  void toggle2() {
    setState(() {
      obsecureText2 = !obsecureText2;
    });
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
        title: Text('signup'.tr()),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
                padding: EdgeInsets.all(15.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                            maxLines: 1,
                            style: TextStyle(fontSize: 15),
                            controller: emailController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.email,
                                color: primaryColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              labelText: 'email'.tr(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'enter_email'.tr();
                              } else if (!EmailValidator.validate(value)) {
                                return 'enter_valid_email'.tr();
                              } else {
                                return null;
                              }
                            }),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                            style: TextStyle(fontSize: 15),
                            controller: userController,
                            decoration: InputDecoration(
                              prefixIcon:
                                  Icon(Icons.person, color: primaryColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              labelText: 'user_name'.tr(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'enter_your_name'.tr();
                              } else {
                                return null;
                              }
                            }),
                        SizedBox(
                          height: 15,
                        ),
                        Stack(children: [
                          TextFormField(
                              style: TextStyle(fontSize: 15),
                              obscureText: obsecureText2,
                              controller: passwController,
                              decoration: InputDecoration(
                                prefixIcon:
                                    Icon(Icons.lock, color: primaryColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                labelText: "password".tr(),
                              ),
                              validator: (value) {
                                if (value!.length < 5) {
                                  return "passsword_must_contain_five".tr();
                                } else if (value == null || value.isEmpty) {
                                  return 'enter_password'.tr();
                                } else {
                                  return null;
                                }
                              }),
                          Align(
                            alignment: (languageArabic)
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: IconButton(
                              onPressed: () {
                                toggle2();
                              },
                              icon: Icon((!obsecureText2)
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              color: primaryColor,
                            ),
                          )
                        ]),
                        SizedBox(
                          height: 15,
                        ),
                        Stack(children: [
                          TextFormField(
                              style: TextStyle(fontSize: 15),
                              obscureText: obsecureText,
                              controller: conpassController,
                              decoration: InputDecoration(
                                prefixIcon:
                                    Icon(Icons.lock, color: primaryColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                labelText: "confirm_password".tr(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'confirm_pasword_required'.tr();
                                } else {
                                  return null;
                                }
                              }),
                          // Align(
                          //   alignment: (languageArabic)
                          //       ? Alignment.centerLeft
                          //       : Alignment.centerRight,
                          //   child: IconButton(
                          //     onPressed: () {
                          //       toggle();
                          //     },
                          //     icon: Icon((!obsecureText)
                          //         ? Icons.visibility
                          //         : Icons.visibility_off),
                          //     color: primaryColor,
                          //   ),
                          // )
                        ]),
                        SizedBox(
                          height: 30,
                        ),
                        InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              if (passwController.text ==
                                  conpassController.text) {
                                signUp(emailController.text,
                                    userController.text, passwController.text);
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        backgroundColor: red,
                                        margin: EdgeInsets.all(10),
                                        behavior: SnackBarBehavior.floating,
                                        content: Text(
                                          'password_does_not_match'.tr(),
                                          textAlign: TextAlign.center,
                                        )));
                              }
                            }
                          },
                          child: Container(
                            child: Center(
                              child: Text(
                                'sign_up'.tr(),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: white),
                              ),
                            ),
                            width: double.infinity,
                            height: 45,
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(7)),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ScreenLogin()));
                              },
                              child: Center(
                                child: Text(
                                  'i_want_login'.tr(),
                                ),
                              ),
                            ),
                          ],
                        )
                      ]),
                )),
          ),
        ),
      ),
    );
  }

  checkPass(BuildContext ctx) {
    if (passwController.text != conpassController.text) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          backgroundColor: red,
          margin: EdgeInsets.all(10),
          behavior: SnackBarBehavior.floating,
          content: Text(
            'retype_password'.tr(),
            textAlign: TextAlign.center,
          )));
    }
  }

  Future signUp(String email, user, pass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Dio dio = Dio();
    Map<String, dynamic> data = {
      'login': email,
      'name': user,
      'password': pass
    };

    var formData = FormData.fromMap(data);
    try {
      final response = await dio.post(base_url + 'api/signup/', data: data);

      print(response.data);

      Map<String, dynamic> map = Map<String, dynamic>.from(response.data);
      if (response.statusCode == 200 && map['result']['status'] == 200) {
        print(response.data);
        prefs.setString('user_login_flag', "1");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: black,
            margin: EdgeInsets.all(10),
            behavior: SnackBarBehavior.floating,
            content: Text(
              'registration_successfull'.tr(),
              textAlign: TextAlign.center,
            )));
        authentic(emailController.text, passwController.text);
        print(prefs.getString('user_login_flag'));
        print(response.data);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return Screens();
        }));
      } else if (response.statusCode == 200 && map['result']['status'] == 201) {
        print(response.data);
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: black,
              margin: EdgeInsets.all(10),
              behavior: SnackBarBehavior.floating,
              content: Text(
                'email_id_exist'.tr(),
                textAlign: TextAlign.center,
              )));
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future authentic(String user, pass) async {
    Dio dio = Dio();

    Map<String, dynamic> data = {
      'db': 'zts-pnm-lian-server-05-06-5063731',
      'login': user,
      'password': pass
    };
    var formData = FormData.fromMap(data);
    try {
      final response = await dio.post(
        base_url + 'api/authenticate',
        data: data,
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(response.data);

      Map<String, dynamic> map = Map<String, dynamic>.from(response.data);
      if (response.statusCode == 200 && map['result']['status'] == 200) {
        prefs.setString('token', map['result']['token']);
        prefs.setString('user_login_flag', "1");
        print(prefs.getString('user_login_flag'));
        prefs.setString('email', emailController.text);
        var namee = prefs.getString('email');
        print(namee);
        // Navigator.pop(context);

      }
    } catch (e) {}
  }
}
