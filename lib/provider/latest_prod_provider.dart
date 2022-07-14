// import 'package:flutter/cupertino.dart';
// import 'package:pmc_app/API/latest_product_api.dart';
// import 'package:pmc_app/models/latest_products_model.dart';

// class LatestAPIProvider extends ChangeNotifier {
//   LatestProdAPI _latestAPI = LatestProdAPI();
//   late Latest _latest;
//   bool isLoading = true;
//   int _page = 1;
//   int get page => _page;

//   set page(int value) {
//     _page = value;
//     notifyListeners();
//   }

//   List<LatestProduct> _latestList = [];

//   List<LatestProduct> get getLatestList => _latestList;
//   set photos(List<LatestProduct> value) {
//     _latestList = value;
//   }

//   Future getLatestData(context) async {
//     isLoading = true;

//     _latestList.clear();
//     var latestData =
//         await _latestAPI.getLatestApi(context, _page).then((value) {
//       _page = _page++;
//     });

//     if (latestData != null) {
//       _latest = Latest.fromJson(latestData);
//       _latestList.addAll(_latest.latestProducts);
//       isLoading = false;
//     }

//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import 'package:pmc_app/API/latest_product_api.dart';
import 'package:pmc_app/models/latest_products_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LatestAPIProvider extends ChangeNotifier {
  int _page = 1;
  int get page => _page;

  set page(int value) {
    _page = value;
    notifyListeners();
  }

  bool hasNext = false;

  bool isLoading = true;
  List<Products> _latest = <Products>[];

  List<Products> get getLatestList => _latest;

  set latestProd(List<Products> value) {
    _latest = value;
  }

  String lang = '';
  Future<void> getLatestData() async {
   
    print('initial:$_page');
    await LatestApi().getLatestDatas(_page, lang).then((response) {
      if (response['products'].isNotEmpty) {
        _page = _page + 1;
        hasNext = false;
        print('length${response['products'].length}');

        print('seconddd$_page');
        addProductToList(ProductClass.fromJson(response).products);
        // isLoading = false;
        print(response['products'].isNotEmpty);
      } else {
        hasNext = false;
      }
    });
    // isLoading = false;
    notifyListeners();
  }

  void addProductToList(List<Products> latest) {
    _latest.addAll(latest);
    isLoading = false;
    notifyListeners();
  }

  // String language = "";
  // Future getLanguage() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   language = pref.getString('language')!;
  //   if (language != null && language.isNotEmpty) {
  //     lang = 'ar';
  //   } else {
  //     lang = 'en';
  //   }
  //   notifyListeners();
  // }
}
