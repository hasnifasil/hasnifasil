import 'package:dio/dio.dart';
import 'package:pmc_app/API/constats/constant_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartLength{

int? saleId;
   Future getCartLength() async {
    SharedPreferences prefs=await SharedPreferences.getInstance();
   if(prefs.getInt('sale_id')!=null){
   saleId= prefs.getInt('sale_id')??0;}
    Dio dio = Dio();
    try {
      final response = await dio.get(
        base_url + 'api/read/cart/length?sale_id=$saleId',
      );

      print(response);
      if (response.statusCode == 200) {
        return response.data;
      
       
         
       
      } else {
        return response.data;
      }
    } catch (e) {}
  }

}