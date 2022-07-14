import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pmc_app/API/constats/constant_api.dart';
import 'package:pmc_app/API/constats/styles.dart';
import 'package:pmc_app/profile/sign_up.dart';
import 'package:pmc_app/screens/forgotPassword.dart';

import 'package:pmc_app/screens/screen_home.dart';
import 'package:pmc_app/screens/screen_profile.dart';
import 'package:pmc_app/screens/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({Key? key}) : super(key: key);

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final unameController = TextEditingController();
  final passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String namee;


  @override
  void initState(){
    arabicSelectedorNot();
    super.initState();
  }

  bool obsecureText = true;
  void toggle() {
    setState(() {
      obsecureText = !obsecureText;
    });
  }
 bool languageArabic=false;
  arabicSelectedorNot() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
//final lang=prefs.getString('language');
if(prefs.getString('language')!=null){
  setState(() {
   languageArabic=true; 
  });
  
  
}
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Screens()));
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Form(
                    key: _formKey,
                    child: Column(children: [
                      SizedBox(
                        height: 10,
                      ),
                      Image.asset(
                        'assets/images/appbaar.jpeg',
                        height: 100,
                        width: 100,
                      ),
                      Text(
                        "welcome_to_pmc".tr(),
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        controller: unameController,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: [AutofillHints.email],
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                            color: primaryColor,
                          ),
                          labelText: "enter_email".tr(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "enter_email".tr();
                          } else if (!EmailValidator.validate(value)) {
                            return 'enter valid email';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Stack(children: [
                        TextFormField(
                          obscureText: obsecureText,
                          controller: passController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                              color: primaryColor,
                            ),
                            labelText: 'password'.tr(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'enter_password'.tr();
                            } else {
                              return null;
                            }
                          },
                        ),
                        Align(
                          alignment:(languageArabic)?Alignment.centerLeft: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {
                              toggle();
                            },
                            icon: Icon((!obsecureText)
                                ? Icons.visibility
                                : Icons.visibility_off),
                            color: primaryColor,
                          ),
                        )
                      ]),
                      SizedBox(
                        height: 25,
                      ),
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            authentic(
                                unameController.text, passController.text);
                          }
                        },
                        child: Container(
                          child: Center(
                            child: Text(
                              'login'.tr(),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          width: double.infinity,
                          height: 38,
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUp()));
                              },
                              child: Text(
                                'signup'.tr(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ))
                        ],
                      )
                    ]),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassword()));
                        },
                        child: Text('forgot_passwords'.tr()))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
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
       base_url+ 'api/authenticate',
        data: data,
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(response.data);

      Map<String, dynamic> map = Map<String, dynamic>.from(response.data);
      if (response.statusCode == 200 && map['result']['status'] == 200) {
        prefs.setString('token', map['result']['token']);
        prefs.setString('user_login_flag', "1");
        print(prefs.getString('user_login_flag'));
        prefs.setString('email', unameController.text);
        var namee = prefs.getString('email');
        print(namee);
        Navigator.pop(context);

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Screens();
        }));
      } else if (response.statusCode == 200 && map['result']['status'] == 401) {
        print(map['result']['status']);
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: red,
              margin: EdgeInsets.all(10),
              behavior: SnackBarBehavior.floating,
              content: Text(
                'Enter Valid Credentials',
                textAlign: TextAlign.center,
              )));
        });
      } else {}
    } catch (e) {}
  }
}
