// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:pmc_app/API/constats/constant_api.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LatestProdAPI {
//   Dio dio = Dio();

//   Future getLatestApi(context, int page) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//     try {
//       final response =
//           await dio.get(base_url + 'api/read/latest/products?page=$page');
//       print(response);
//       if (response.statusCode == 200) {
//         return response.data;
//       } else {
//         print('request failed with status: ${response.statusCode}');
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
// }
import 'package:dio/dio.dart';
import 'package:pmc_app/API/constats/constant_api.dart';

class LatestApi {
  Response? response;
  Dio dio = new Dio();

  getLatestDatas(int page,String lang) async {
    response = await dio.get(base_url + 'api/read/latest/products?lang=$lang&page=$page');
    //  print(response);
    return (response!.data!);
  }
}
