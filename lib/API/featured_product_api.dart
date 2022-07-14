import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pmc_app/API/constats/constant_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeaturedProductAPI {
  Dio dio = Dio();
  Response? response;

  Future getFeaturedApi(int page ,String lang) async {
    try {
      response =
          await dio.get(base_url + 'api/read/featured/products?lang=$lang&page=$page');
      print(response);
      if (response!.statusCode == 200) {
        return (response!.data!);
      }
    } catch (e) {}
  }
}
