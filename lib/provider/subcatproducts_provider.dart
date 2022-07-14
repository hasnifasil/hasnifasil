import 'package:flutter/cupertino.dart';
import 'package:pmc_app/API/selling_api.dart';
import 'package:pmc_app/API/sub_category_api.dart';
import 'package:pmc_app/API/subcatproducts.dart';
import 'package:pmc_app/models/selling_model.dart';

import '../models/latest_products_model.dart';

class SubCatAPIProvider extends ChangeNotifier {
  int _page = 1;
  int get page => _page;
  bool hasNext = false;
  bool isLoading = true;

  set page(int value) {
    _page = value;
    // notifyListeners();
  }

  List<Products> _category = <Products>[];

  List<Products> get getSubCatList => _category;

  set latestProd(List<Products> value) {
    _category = value;
  }

  String lang = 'en';
  Future<void> getSubCatData(String id) async {
    isLoading = true;
    await SubProducts().getSellingApi(_page, lang, id).then((response) {
      if (response['products'].isNotEmpty) {
        _page = _page + 1;

        addProductToList(ProductClass.fromJson(response).products);
      } else {
        hasNext = false;
      }
    });
    isLoading = false;
    notifyListeners();
  }

  void addProductToList(List<Products> selling) {
    _category.addAll(selling);
    isLoading = false;
    notifyListeners();
  }
}
