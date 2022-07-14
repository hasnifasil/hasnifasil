import 'package:flutter/cupertino.dart';
import 'package:pmc_app/API/brands_api.dart';



import '../models/latest_products_model.dart';

class BrandOneProvider extends ChangeNotifier {

  int _page = 1;
  int get page => _page;

  set page(int value) {
    _page = value;
   
  }

  bool? isl;
  List<Products> _featured = <Products>[];

  List<Products> get getbrand1OneList => _featured;
bool noproduct=false;
  set BrandProd(List<Products> value) {
    _featured = value;
  }
 String lang = '';
  bool hasNext = false;
  Future<void> getBrandData({
    context,
    required int id,
  }) async {
    
    isl = true;
    await BrandAPI()
        .getBrand1API(id: id, context: context, page: _page,lang: lang)
        .then((response) {
      if (response['products']!=null&&response['products'].isNotEmpty) {
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

  void addProductToList(List<Products> brand) {
    _featured.addAll(brand);
    isl = false;
    notifyListeners();
  }
}
