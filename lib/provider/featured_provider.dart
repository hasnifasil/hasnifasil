import 'package:flutter/cupertino.dart';
import 'package:pmc_app/API/featured_product_api.dart';

import 'package:pmc_app/models/latest_products_model.dart';

class FeatureProductProvider extends ChangeNotifier {
  int _page = 1;
  int get page => _page;
  bool hasNext = false;
  bool isLoading = true;

  set page(int value) {
    _page = value;
    notifyListeners();
  }

  List<Products> _featured = <Products>[];

  List<Products> get getFeaturedList => _featured;

  set featuredProd(List<Products> value) {
    _featured = value;
  }

  String lang = 'en';
  Future<void> getFeaturedData() async {
    await FeaturedProductAPI().getFeaturedApi(_page, lang).then((response) {
      if (response['products'].isNotEmpty) {
        print(response);
        print(response['products'].isEmpty);
        _page = _page + 1;
        addProductToList(ProductClass.fromJson(response).products);
      } else {
        hasNext = false;
      }
    });
    notifyListeners();
  }

  void addProductToList(List<Products> latest) {
    _featured.addAll(latest);
    isLoading = false;
    notifyListeners();
  }
}
