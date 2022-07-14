import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pmc_app/API/constats/constant_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SellingAPI{
 
  Dio dio = Dio();

  Future getSellingApi(int page,String lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
       final token = prefs.getString('token');
    final response = await dio.get(base_url + 'api/read/selling/products?lang=$lang&page=$page');
    print(response);
    if (response.statusCode == 200) {
      return response.data;
    }
    }catch(e){

    }
   
  }
}