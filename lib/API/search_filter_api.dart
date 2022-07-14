import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pmc_app/API/constats/constant_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchFilterAPI {
  Dio dio = Dio();

  Future getSearchFilterApi(int page, String name,String filter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('desc')!=null){
      filter='desc';

    }else{
      filter='asc';
    }
    try {
      final token = prefs.getString('token');
      final response =
          await dio.get(base_url + 'api/search/products/filter?name=$name&page=$page&filter=$filter');
      print(response);
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {}
  }
}