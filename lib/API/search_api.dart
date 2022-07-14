import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pmc_app/API/constats/constant_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchProductAPI {
  Dio dio = Dio();

  Future getSearchApi(int page, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final token = prefs.getString('token');
      final response =
          await dio.get(base_url + 'api/search/products?name=$name&page=$page');
      print(response);
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {}
  }
}
