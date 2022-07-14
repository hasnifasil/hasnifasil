import 'package:dio/dio.dart';
import 'package:pmc_app/API/constats/constant_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubProducts {
  Dio dio = Dio();

  Future getSellingApi(int page, String lang, String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final token = prefs.getString('token');
       if (prefs.getString('language') != null) {lang='ar';}else{lang='en';}
      final response = await dio
          .get(base_url + 'api/read/category/products?id=$id&page=$page&lang=$lang');
      print(response);
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {}
  }
}
