import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pmc_app/API/constats/constant_api.dart';

import 'package:pmc_app/models/subcategery_products_model.dart';
import 'package:pmc_app/screens/category/sub_categer_products.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SubCategoryAPI {
  Dio dio = Dio();

  Future getSubCatApi({required String id}) async {
    print("id " + id);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
         String lang="";
  
     if (prefs.getString('language') != null) {lang='ar';}else{lang='en';}

    final response = await dio.get(
     base_url+ 'api/read/sub/category?id=$id&lang=$lang',
    );
    print(response);
    print(response.data);
    if (response.statusCode == 200) {
      return response.data;
    }
  }

  Future<CatSubProducts> getSubCategeryProducts(
    String id,
  ) async { 
     String lang="";
    SharedPreferences prefs = await SharedPreferences.getInstance();
     if (prefs.getString('language') != null) {lang='ar';}else{lang='en';}

    final response = await http
        .get(Uri.parse(base_url + "api/read/category/products?id=$id&lang=$lang&page=1"));
    print(response);
    print(response.body);
    if (response.statusCode == 200) {
      CatSubProducts data = CatSubProducts.fromJson(json.decode(response.body));
      return data;
    } else {
      return CatSubProducts(
        products: [],
      );
    }
  }
}
