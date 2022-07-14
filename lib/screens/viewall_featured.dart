import 'dart:convert';
import 'dart:typed_data';

import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:pmc_app/API/constats/styles.dart';
import 'package:pmc_app/models/latest_products_model.dart';
import 'package:pmc_app/provider/featured_provider.dart';
import 'package:pmc_app/provider/latest_prod_provider.dart';
import 'package:pmc_app/screens/poduct_screen_latest.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewFeatured extends StatefulWidget {
  const ViewFeatured({Key? key}) : super(key: key);

  @override
  State<ViewFeatured> createState() => _ViewFeaturedState();
}

class _ViewFeaturedState extends State<ViewFeatured> {
  Uint8List? _bytesImage;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchData();
    _controller.addListener(_scrollListener);
  }

  fetchData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('language') != null) {
      Provider.of<LatestAPIProvider>(context, listen: false).lang = 'ar';
    } else {
      Provider.of<LatestAPIProvider>(context, listen: false).lang = 'en';
    }
    Provider.of<FeatureProductProvider>(context, listen: false)
        .getFeaturedData();
  }

  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      Provider.of<FeatureProductProvider>(context, listen: false).hasNext =
          true;
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Featured Products'),
        ),
        body: Consumer<FeatureProductProvider>(builder: (context, snapshot, _) {
          if (snapshot.isLoading == true) {
            return gridFadeShimmer();
          } else {
            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                      controller: _controller,
                      itemCount: snapshot.getFeaturedList.length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 250, childAspectRatio: 2 / 3),
                      itemBuilder: (context, index) {
                       

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LatestProductSel(
                                          latestp: snapshot
                                              .getFeaturedList[index])));
                            },
                            child: Card(
                              shape: cardStyle(),
                              elevation: 10,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [snapshot.getFeaturedList[index].image!=null&&snapshot.getFeaturedList[index].image.isNotEmpty?
                                  Image.memory(base64Decode(snapshot.getFeaturedList[index].image),
                                   
                                    height: 140,
                                  ):Container(height:120,child: Image.asset(
                  "assets/images/no_img.png",
                  gaplessPlayback: true,
                ),),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, top: 8),
                                    child: Text(
                                      snapshot.getFeaturedList[index].name,
                                      textAlign: TextAlign.center,
                                      style:
                                          TextStyle(color: black, fontSize: 15),
                                      maxLines: 3,
                                    ),
                                  ),
                                  Text(
                                    'QR ' +
                                        snapshot.getFeaturedList[index].price
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
                        
                      
                      }),
                ),
                (snapshot.hasNext) ? CircularProgressIndicator() : SizedBox(),
              ],
            );
          }
        }));
  }
}
