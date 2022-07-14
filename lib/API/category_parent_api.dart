import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pmc_app/API/constats/constant_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CategoryParentAPI {
  final client = http.Client();
  Future getCategoryAPI(context) async {
    Dio dio = Dio();
    String lang="";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
          if (prefs.getString('language') != null) {lang='ar';}else{lang='en';}
      final response = await dio.get(
        base_url + 'api/read/category?lang=$lang',
      );
      print(response);
      if (response.statusCode == 200) {
        print(response.data);
        return response.data;
      } else {
        return response.data;
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Page not found")));
    }
  }
}
