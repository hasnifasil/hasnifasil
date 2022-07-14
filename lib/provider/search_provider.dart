import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pmc_app/API/constats/styles.dart';
import 'package:pmc_app/API/featured_product_api.dart';
import 'package:pmc_app/API/search_api.dart';

import 'package:pmc_app/models/latest_products_model.dart';

class SearchProductProvider extends ChangeNotifier {
  int _page = 1;
  int get page => _page;
  bool hasNext = true;
  bool? isLoading;

  set page(int value) {
    _page = value;
    notifyListeners();
  }

  List<Products> _search = <Products>[];

  List<Products> get getSearchList => _search;

  set featuredProd(List<Products> value) {
    _search = value;
  }

  Future<void> getSearchData(String name, BuildContext context) async {
    isLoading = true;

    await SearchProductAPI().getSearchApi(_page, name).then((response) {
      isLoading = true;
      if (_page == 1 && response['products'].isEmpty) {
        //  isLoading = false;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: black,
            margin: EdgeInsets.all(10),
            behavior: SnackBarBehavior.floating,
            content: Text(
              'No products found',
              textAlign: TextAlign.center,
            )));
      }
      if (response['products'].isNotEmpty) {
        print(response);
        print(response['products'].isEmpty);

        _page = _page + 1;
        addProductToList(ProductClass.fromJson(response).products);
        isLoading = false;
        notifyListeners();
      } else {
        hasNext = false;
      }
    });
    isLoading = false;
    notifyListeners();
  }

  void addProductToList(List<Products> search) {
    _search.addAll(search);
    notifyListeners();
  }
}
