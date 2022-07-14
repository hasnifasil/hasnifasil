import 'package:pmc_app/API/sub_category_api.dart';
import 'package:pmc_app/models/cart_provider.dart';
import 'package:pmc_app/models/wish_provider.dart';
import 'package:pmc_app/provider/carousal_provider.dart';
import 'package:pmc_app/provider/cartListing_provider.dart';
import 'package:pmc_app/provider/cart_length_provider.dart';
import 'package:pmc_app/provider/promotion_provider.dart';
import 'package:pmc_app/provider/brand_provider.dart';

import 'package:pmc_app/provider/catoegory_parent_provider.dart';
import 'package:pmc_app/provider/featured_provider.dart';
import 'package:pmc_app/provider/search_filter_provider.dart';
import 'package:pmc_app/provider/search_provider.dart';

import 'package:pmc_app/provider/selling_api_provider.dart';
import 'package:pmc_app/provider/latest_prod_provider.dart';
import 'package:pmc_app/provider/subcatproducts_provider.dart';

// import 'package:pmc_app/provider/sub_category_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [...remoteProviders];

List<SingleChildWidget> remoteProviders = [
  ChangeNotifierProvider(
    create: (_) => SellingAPIProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => FeatureProductProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => LatestAPIProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => BuyOneProvider(),
  ),

  ChangeNotifierProvider(
    create: (_) => CategoryAPIProvider(),
  ),
  // ),
  // ChangeNotifierProvider(
  //   create: (_) => SubCategoryProvider(),
  // ),

  ChangeNotifierProvider(
    create: (_) => BrandOneProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => SearchProductProvider(),
  ),

  ChangeNotifierProvider(
    create: (_) => CartProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => WishProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => Carousal(),
  ),
  ChangeNotifierProvider(
    create: (_) => SubCatAPIProvider(),
  ),
     ChangeNotifierProvider(
    create: (_) => SearchProductFilterProvider(),
  ),
  
ChangeNotifierProvider(
    create: (_) => CartLengthProvider()),
    ChangeNotifierProvider(
    create: (_) => CartListProvider()),
];
