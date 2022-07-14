import 'package:dio/dio.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:pmc_app/API/constats/constant_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final mailController = TextEditingController();
  String? messages;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('forgot_passwords'.tr()),
        actions: [
          InkWell(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                forgotPassword(mailController.text);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Center(
                    child: Text(
                  'done'.tr(),
                  style: TextStyle(fontSize: 16),
                )),
              ),
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                  controller: mailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: 'enter_email'.tr(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter_email'.tr();
                    } else {
                      return null;
                    }
                  }),
            ),
            Text(''),
          ],
        ),
      ),
    );
  }

  Future forgotPassword(String user) async {
    Dio dio = Dio();

    Map<String, dynamic> data = {
      'login': user,
    };
    // var formData = FormData.fromMap(data);
    final response = await dio.post(
        base_url+'api/forgot/password',
        data: data,
        options: Options(headers: {"Content-Type": "application/json"}));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(response.data);

    Map<String, dynamic> map = Map<String, dynamic>.from(response.data);
    if (response.statusCode == 200) {
      prefs.setString('message', map['result']['message']);
      final messages = prefs.getString('message')!;
      print(response.data);

      if (map['result']['status'] == 200) {
        print(response.statusCode);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            margin: EdgeInsets.all(10),
            behavior: SnackBarBehavior.floating,
            content: Text(
              'you_will_get_link_to_reset_password'.tr(),
              textAlign: TextAlign.center,
            )));
        Navigator.pop(context);
      } else {
        print(response.statusCode);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            margin: EdgeInsets.all(10),
            behavior: SnackBarBehavior.floating,
            content: Text(
              'invalid email address',
              textAlign: TextAlign.center,
            )));
      }
    }
  }
}
