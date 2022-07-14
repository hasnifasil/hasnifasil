import 'dart:convert';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pmc_app/API/constats/styles.dart';
import 'package:pmc_app/provider/brand_provider.dart';
import 'package:pmc_app/screens/poduct_screen_latest.dart';

// import 'package:pmc_app/screens/products_brand_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenBrand1 extends StatefulWidget {
  final int id;
  final String name;
  const ScreenBrand1({Key? key, required this.id, required this.name})
      : super(key: key);

  @override
  _ScreenBrand1State createState() => _ScreenBrand1State();
}

class _ScreenBrand1State extends State<ScreenBrand1> {
  Uint8List? _bytesImage;
  final ScrollController _controller = ScrollController();
bool langCalled=false;
  @override
  void initState() {
   // getLanguage();
   
   firstLoad();
    super.initState();
    _controller.addListener(_scrollListener);
  }

  // @override
  // void setState(VoidCallback fn) {
  //   if (mounted) super.setState(fn);
  // }

  fetchData() {
    print(widget.id);
    Provider.of<BrandOneProvider>(context, listen: false)
        .getBrandData(id: widget.id, context: context);
  }

  firstLoad() {
    
    Provider.of<BrandOneProvider>(context, listen: false)
        .getbrand1OneList
        .clear();
    Provider.of<BrandOneProvider>(context, listen: false).page = 1;
    print(widget.id);
    Provider.of<BrandOneProvider>(context, listen: false)
        .getBrandData(id: widget.id, context: context);
  }

  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      Provider.of<BrandOneProvider>(context, listen: false).hasNext = true;
      fetchData();
    }
  }

  getLanguage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('language') != null) {
      Provider.of<BrandOneProvider>(context, listen: false).lang = 'ar';
    } else {
      Provider.of<BrandOneProvider>(context, listen: false).lang = 'en';
    }
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.name)),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Consumer<BrandOneProvider>(builder: (context, snapshot, _) {
            if (snapshot.isl == true) {
              return gridFadeShimmer();
            } else {  
              return (snapshot.getbrand1OneList.length==0)?Center(child: Text('no_products'.tr()+"!!!",style: TextStyle(fontSize: 18),)): Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                        controller: _controller,
                        itemCount: snapshot.getbrand1OneList.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 250, childAspectRatio: 2 / 3),
                        itemBuilder: (context, index) {
                 

                          return 
                                 InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LatestProductSel(
                                          latestp: snapshot
                                              .getbrand1OneList[index])));
                            },
                            child: InkWell(
                              child: Card(
                                elevation: 10,
                                shape: cardStyle(),
                                shadowColor: black,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [((snapshot.getbrand1OneList[index].image)!=null&&snapshot.getbrand1OneList[index].image.isNotEmpty)?
                                    Image.memory(
                                     base64.decode(snapshot.getbrand1OneList[index].image),
                                      width: 150,
                                      height: 150,
                                    ):Container(height: 150,child:Image.asset(
                  "assets/images/no_img.png",
                  gaplessPlayback: true,
                ),),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0, top: 8),
                                      child: Text(
                                        snapshot.getbrand1OneList[index].name,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                          
                                            Text(
                                              'QAR  ' +
                                                  snapshot
                                                      .getbrand1OneList[index]
                                                      .price
                                                      .toStringAsFixed(2),
                                              style: TextStyle(
                                                  color: black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            // if (snapshot.getbrand1OneList[index]
                                            //             .discount_price !=
                                            //         null &&
                                            //     snapshot.getbrand1OneList[index]
                                            //         .discount_price.isNotEmpty)
                                            //   Text(
                                            //     'QAR  ' +
                                            //         snapshot
                                            //             .getbrand1OneList[index].price
                                            //             .toString(),
                                            //     style: TextStyle(
                                            //         decoration:
                                            //             TextDecoration.lineThrough,
                                            //         color: black,
                                            //         fontSize: 16,
                                            //         fontWeight: FontWeight.bold),
                                            //   ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  (snapshot.hasNext) ? CircularProgressIndicator() : SizedBox(),
                ],
              );
            }
          }),
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
