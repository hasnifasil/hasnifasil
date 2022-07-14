import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pmc_app/API/constats/constant_api.dart';

class BuyOneAPI {
  Dio dio = Dio();

  Future getBuyOneApi({context, required int id,required int page, String? lang }) async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
        if (prefs.getString('language') != null) {lang='ar';}else{lang='en';}
      final response = await dio.get(
        base_url + 'api/read/promotion/products?id=$id&page=$page&lang=$lang',
      );
      print(response);
      if (response.statusCode == 200) {
        print(response.data);
        return response.data;
      }
      //  else {
      //   print('failed with status:${response.statusCode}');
      // }
    } catch (e) {
      print(e);
    }
  }
}
