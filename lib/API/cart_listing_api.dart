 import 'package:dio/dio.dart';
import 'package:pmc_app/API/constats/constant_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class cartListApi{
 double totalAmounts=0.0;
 int quantity=1;
 getCartListItems() async {
      //cartItemsList.clear();
  
   
   
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    final sale_id = prefs.getInt('sale_id') ?? "";
    Dio dio = Dio();

    final response =
        await dio.get(base_url + 'api/read/cart/data?sale_id=$sale_id');
print(response.data);
    if (response.statusCode == 200) {
      print(response.data);
      Map<dynamic, dynamic> map = Map<String, dynamic>.from(response.data);
      prefs.setString('reference',map['name']);
         totalAmounts = map['total_amount'] ?? 0.0;
        // quantity=map['result']
      return response.data;
      
      print(response.data);
     // if (map['total_amount'] != null) {
        // setState(() {
        //    isLoadingCart=false;
        

     
         
        // });
      

     
      // AllCartItems data = AllCartItems.fromJson(response.data);
      // setState(() {
      //   cartItemsList.addAll(data.details!);
      

   
    }
  }
 }