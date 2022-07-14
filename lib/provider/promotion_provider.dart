import 'package:flutter/cupertino.dart';

import 'package:pmc_app/API/promo_buyone_api.dart';

import 'package:pmc_app/models/promotion_model.dart';
import 'package:pmc_app/models/promotion_model.dart';
import 'package:pmc_app/models/latest_products_model.dart';

class BuyOneProvider extends ChangeNotifier {
  // BuyOneAPI _buy = BuyOneAPI();
  // late PromotionProducts _buyone;

  // List<Beauty> getbuyOneList = [];
  // bool isl = true;
  // Future getBuyOneData({context, required int id}) async {
  //   isl = true;
  //   notifyListeners();
  //   getbuyOneList.clear();

  //   var buydata = await _buy.getBuyOneApi(id: id, context: context);

  //   if (buydata != null) {
  //     _buyone = PromotionProducts.fromJson(buydata);
  //     getbuyOneList.addAll(_buyone.products);
  //     isl = false;

  //     notifyListeners();
  //   }
  // }

  int _page = 1;
  int get page => _page;

  set page(int value) {
    _page = value;
    //  notifyListeners();
  }

  bool? isl;
  List<Products> _promotion = <Products>[];

  List<Products> get getbuyOneList => _promotion;

  set BrandProd(List<Products> value) {
    _promotion = value;
  }
String lang='';
  bool hasNext = false;
  Future<void> getBuyOneData({
    context,
    required int id,
  }) async {
    isl = true;
    await BuyOneAPI()
        .getBuyOneApi(id: id, context: context, page: _page,lang: lang)
        .then((response) {
      if (response['products'].isNotEmpty) {
        print(response);
        _page = _page + 1;
        print(_page);

        addProductToList(ProductClass.fromJson(response).products);
        isl = false;
      } else {
        hasNext = false;
      }
    });
    isl = false;
    notifyListeners();
  }

  void addProductToList(List<Products> promo) {
    _promotion.addAll(promo);
    isl = false;
    notifyListeners();
  }
}
