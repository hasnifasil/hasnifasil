import 'package:flutter/cupertino.dart';
import 'package:pmc_app/API/selling_api.dart';
import 'package:pmc_app/models/selling_model.dart';

import '../models/latest_products_model.dart';

class SellingAPIProvider extends ChangeNotifier {
  int _page = 1;
  int get page => _page;
  bool hasNext = false;
  bool isLoading=true;

  set page(int value) {
    _page = value;
    notifyListeners();
  }

  List<Products> _selling = <Products>[];

  List<Products> get getSellingList => _selling;

  set latestProd(List<Products> value) {
    _selling = value;
  }
String lang ='en';
  Future<void> getSellingData() async {
    await SellingAPI().getSellingApi(_page,lang).then((response) {
      if (response['products'].isNotEmpty) {
       
        _page = _page + 1;

        addProductToList(ProductClass.fromJson(response).products);
     
      } else {
        hasNext = false;
      }
    });
    notifyListeners();
  }

  void addProductToList(List<Products> selling) {
    _selling.addAll(selling);
       isLoading = false;
    notifyListeners();
  }
}
