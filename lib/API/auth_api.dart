// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:pmc_app/API/constats/constant_api.dart';
// import 'package:pmc_app/screens/screens.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthApi {
//   Dio dio = Dio();
//   Future<String> authentic(BuildContext context) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     Map<String, dynamic> data = {
//       "params": {
//         'db': 'zts-pnm-joud-server-26-12-3873344',
//         'login': 'admin',
//         'password': '123456'
//       }
//     };
//     String subUrl = "/api/authenticate";
//     final response = await dio.post(base_url + subUrl,
//         data: data,
//         options: Options(headers: {"Content-Type": "application/json"}));

//     print(response.data);

//     Map<String, dynamic> map = Map<String, dynamic>.from(response.data);
//     if (map['result']['status'] == 200) {
//       prefs.setString('token', map['result']['token']);

//       return "success";
//     }
//     return "failed";
//   }
// }
