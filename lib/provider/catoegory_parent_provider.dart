import 'package:flutter/cupertino.dart';
import 'package:pmc_app/API/category_parent_api.dart';

import 'package:pmc_app/models/category_parent.dart';

class CategoryAPIProvider extends ChangeNotifier {
  CategoryParentAPI _categoryAPI = CategoryParentAPI();
  late Category _category;
  bool isLoading = true;

  List<ParentCategory> _categList = [];

  List<ParentCategory> get getCategList => _categList;

  Future getCategData(context) async {
    _categList.clear();
    var categoryData = await _categoryAPI.getCategoryAPI(context);
    if (categoryData != null) {
      _category = Category.fromJson(categoryData);
      _categList.addAll(_category.parentCategories);
      isLoading = false;
    } else {
      isLoading = false;
      print("Something went wrong!!");
    }

    notifyListeners();
  }
}
