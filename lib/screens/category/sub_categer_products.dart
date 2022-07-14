import 'dart:convert';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pmc_app/API/constats/styles.dart';
import 'package:pmc_app/API/sub_category_api.dart';

import 'package:pmc_app/models/subcategery_products_model.dart';
import 'package:pmc_app/provider/subcatproducts_provider.dart';
import 'package:pmc_app/screens/poduct_screen_latest.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubCategeryProducts extends StatefulWidget {
  String id;
  String? name;
  SubCategeryProducts({Key? key, required this.id, this.name})
      : super(key: key);

  @override
  _SubCategeryProductsState createState() => _SubCategeryProductsState();
}

class _SubCategeryProductsState extends State<SubCategeryProducts> {
  List<Products> products = [];
  bool isload = false;
  Uint8List? _bytesImage;
  final ScrollController _controller = ScrollController();
  @override
  void initState() {
   // getLanguage();
    firstLoad();
    //  getProducts();
    super.initState();

    _controller.addListener(_scrollListener);
  }
 getLanguage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('language') != null) {
      Provider.of<SubCatAPIProvider>(context, listen: false).lang = 'ar';
    } else {
      Provider.of<SubCatAPIProvider>(context, listen: false).lang = 'en';
    }
 
  }
  Future<void> getProducts() async {
    print(widget.id);
    SubCategoryAPI().getSubCategeryProducts(widget.id).then((value) {
      if (mounted)
        setState(() {
          products = value.products!;
          isload = true;
        });

      print(products.length);
    });
  }

  firstLoad() {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // if (pref.getString('language') != null) {
    //   Provider.of<SubCatAPIProvider>(context, listen: false).lang = 'ar';
    // } else {
    //   Provider.of<SubCatAPIProvider>(context, listen: false).lang = 'en';
    // }
    Provider.of<SubCatAPIProvider>(context, listen: false)
        .getSubCatList
        .clear();
    Provider.of<SubCatAPIProvider>(context, listen: false).page = 1;
    Provider.of<SubCatAPIProvider>(context, listen: false)
        .getSubCatData(widget.id);
  }

  fetchdata() {
    Provider.of<SubCatAPIProvider>(context, listen: false)
        .getSubCatData(widget.id);
  }

  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      Provider.of<SubCatAPIProvider>(context, listen: false).hasNext = true;
      fetchdata();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name!),
        ),
        body: Consumer<SubCatAPIProvider>(builder: (context, snapshot, _) {
          if (snapshot.isLoading == true) {
            return gridFadeShimmer();
          } else {
            return snapshot.getSubCatList.length==0? Container(child: Center(child: Text('no_products'.tr()+"!!!",style: TextStyle(fontSize: 18,)))): Column(
              children: [
                Expanded(
                  child: GridView.builder(
                      controller: _controller,
                      itemCount: snapshot.getSubCatList.length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 250, childAspectRatio: 2 / 3),
                      itemBuilder: (context, index) {
                       
                       
                          return  InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LatestProductSel(
                                          latestp:
                                              snapshot.getSubCatList[index])));
                            },
                            child: Card(
                              shape: cardStyle(),
                              elevation: 15,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [snapshot.getSubCatList[index].image!=null&&snapshot.getSubCatList[index].image.isNotEmpty?
                                  Image.memory(
                                   base64Decode(snapshot.getSubCatList[index].image),
                                    height: 120,
                                  ):Container(height: 120,child: Image.asset(
                  "assets/images/no_img.png",
                  gaplessPlayback: true,
                ),),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, top: 8),
                                    child: Text(
                                      snapshot.getSubCatList[index].name,
                                      maxLines: 3,
                                      textAlign: TextAlign.center,
                                      style:
                                          TextStyle(color: black, fontSize: 16),
                                    ),
                                  ),
                                  Text(
                                    'QR  ' +
                                        snapshot.getSubCatList[index].price
                                            .toStringAsFixed(2),
                                    style: TextStyle(
                                        color: black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          );
                        
                       // return CircularProgressIndicator();
                      }),
                ),
                (snapshot.hasNext) ? CircularProgressIndicator() : SizedBox(),
              ],
            );
          }
        }));
  }
  // body: Container(
  //   child: !isload
  //       ? gridFadeShimmer()
  //       : products.isEmpty
  //           ? const Center(
  //               child: Text(
  //                 "No products found!!",
  //                 style: TextStyle(
  //                     fontSize: 16, fontWeight: FontWeight.bold),
  //               ),
  //             )
  //           : GridView.builder(
  //               gridDelegate:
  //                   const SliverGridDelegateWithMaxCrossAxisExtent(
  //                       maxCrossAxisExtent: 250, childAspectRatio: 2 / 3),
  //               itemCount: products.length,
  //               itemBuilder: (context, index) {
  //                 String _imgString = products[index].image!;

  //                 _bytesImage = Base64Decoder().convert(_imgString);

  //                 return InkWell(
  //                   onTap: () {
  //                     Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                             builder: (context) => ProductScreenCategery(
  //                                   products: products[index],
  //                                 )));
  //                   },
  //                   child: Card(
  //                       shape: cardStyle(),
  //                       elevation: 10,
  //                       child: Column(
  //                         mainAxisAlignment:
  //                             MainAxisAlignment.spaceAround,
  //                         children: [
  //                           Card(
  //                             color: white,
  //                             child: (products[index].image!.isNotEmpty)
  //                                 ? Image.memory(
  //                                     _bytesImage!,
  //                                     width: 150,
  //                                     height: 180,
  //                                   )
  //                                 : Container(height: 100, width: 100),
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(
  //                                 left: 8.0, right: 8, bottom: 15),
  //                             child: Text(
  //                               products[index].name!,
  //                               overflow: TextOverflow.ellipsis,
  //                               textAlign: TextAlign.center,
  //                               maxLines: 2,
  //                               style:
  //                                   TextStyle(color: black, fontSize: 15),
  //                             ),
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(bottom: 8.0),
  //                             child: Text(
  //                               'QAR ' +
  //                                   products[index]
  //                                       .price!
  //                                       .toStringAsFixed(2),
  //                               style: TextStyle(
  //                                   color: black,
  //                                   fontSize: 16,
  //                                   fontWeight: FontWeight.bold),
  //                             ),
  //                           )
  //                         ],
  //                       )),
  //                 );
  //               }),
  // ));

}
