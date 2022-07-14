import 'dart:convert';
import 'dart:typed_data';

import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:pmc_app/API/constats/styles.dart';

import 'package:pmc_app/provider/latest_prod_provider.dart';
import 'package:pmc_app/provider/selling_api_provider.dart';
import 'package:pmc_app/screens/poduct_screen_latest.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewSelling extends StatefulWidget {
  const ViewSelling({Key? key}) : super(key: key);

  @override
  State<ViewSelling> createState() => _ViewSellingState();
}

class _ViewSellingState extends State<ViewSelling> {
  Uint8List? _bytesImage;
  final ScrollController _controller = ScrollController();
  @override
  void initState() {
    fetchdata();

    super.initState();
    _controller.addListener(_scrollListener);
  }

  fetchdata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('language') != null) {
      Provider.of<LatestAPIProvider>(context, listen: false).lang = 'ar';
    } else {
      Provider.of<LatestAPIProvider>(context, listen: false).lang = 'en';
    }
    Provider.of<SellingAPIProvider>(context, listen: false).getSellingData();
  }

  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      Provider.of<SellingAPIProvider>(context, listen: false).hasNext = true;
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
          title: Text(' Most Selling Products'),
        ),
        body: Consumer<SellingAPIProvider>(builder: (context, snapshot, _) {
          if (snapshot.isLoading == true) {
            return gridFadeShimmer();
          } else {
            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                      controller: _controller,
                      itemCount: snapshot.getSellingList.length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 250, childAspectRatio: 2 / 3),
                      itemBuilder: (context, index) {
                       
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LatestProductSel(
                                          latestp:
                                              snapshot.getSellingList[index])));
                            },
                            child: Card(
                              shape: cardStyle(),
                              elevation: 15,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [snapshot.getSellingList[index].image!=null&&snapshot.getSellingList[index].image.isNotEmpty?
                                  Image.memory(
                                    base64Decode(snapshot.getSellingList[index].image),
                                    height: 120,
                                  ):Container(height:120,child: Image.asset(
                  "assets/images/no_img.png",
                  gaplessPlayback: true,
                ),),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, top: 8),
                                    child: Text(
                                      snapshot.getSellingList[index].name,
                                      maxLines: 3,
                                      textAlign: TextAlign.center,
                                      style:
                                          TextStyle(color: black, fontSize: 16),
                                    ),
                                  ),
                                  Text(
                                    'QR  ' +
                                        snapshot.getSellingList[index].price
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
