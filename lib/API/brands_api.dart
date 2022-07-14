import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pmc_app/API/constats/constant_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrandAPI {
  Dio dio = Dio();

  Future getBrand1API({context, required int id, required int page, String? lang}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
        if (prefs.getString('language') != null) {
          lang='ar';
          }
        else{
          lang='en';}
      final response = await dio.get(
        base_url + 'api/read/banner/products?id=$id&page=$page&lang=$lang',
      );
      print(response);
      if (response.statusCode == 200) {
           print(response);
            print('kkkkkkk');  
        return response.data;
     
      }
        else {
        print('failed with status:${response.statusCode}');
        print('jjjjjjjjjjjjjjjjjjj');
        print(response.statusCode);
      }
    } catch (e) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text("Page not found")));
    }
  }
}
