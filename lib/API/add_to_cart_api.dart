// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class addToCartApi{

//  Dio dio = Dio();

//   Future getSubCatApi({required String id}) async {
//     print("id " + id);
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//          String lang="";
  
//      if (prefs.getString('language') != null) {lang='ar';}else{lang='en';}

//     final response = await dio.get(
//      base_url+ 'api/read/sub/category?id=$id&lang=$lang',
//     );
//     print(response);
//     print(response.data);
//     if (response.statusCode == 200) {
//       return response.data;
//     }


// }