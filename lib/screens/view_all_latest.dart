import 'dart:convert';
import 'dart:typed_data';

import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:pmc_app/API/constats/styles.dart';
import 'package:pmc_app/models/latest_products_model.dart';
import 'package:pmc_app/provider/latest_prod_provider.dart';
import 'package:pmc_app/screens/poduct_screen_latest.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewLatest extends StatefulWidget {
  const ViewLatest({Key? key}) : super(key: key);

  @override
  State<ViewLatest> createState() => _ViewLatestState();
}

class _ViewLatestState extends State<ViewLatest> {
  final ScrollController _controller = ScrollController();
  Uint8List? _bytesImage;

  bool isBottomReached = false;

  @override
  void initState() {
    super.initState();
    fetchData();
    _controller.addListener(_scrollListener);
  }

  fetchData() async {
    // Provider.of<LatestAPIProvider>(context, listen: false).getLatestData('en');

    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('language') != null) {
      Provider.of<LatestAPIProvider>(context, listen: false).lang = 'ar';
      Provider.of<LatestAPIProvider>(context, listen: false).getLatestData();
    } else {
      Provider.of<LatestAPIProvider>(context, listen: false).lang = 'en';
      Provider.of<LatestAPIProvider>(context, listen: false).getLatestData();
    }
  }

  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      Provider.of<LatestAPIProvider>(context, listen: false).hasNext = true;
      fetchData();
    } else {}
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text('Latest Products'),
        ),
        body: Container(
          child: Consumer<LatestAPIProvider>(builder: (context, snapshot, _) {
            if (snapshot.isLoading == true) {
              return gridFadeShimmer();
            } else {
              return Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                        controller: _controller,
                        itemCount: snapshot.getLatestList.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 250, childAspectRatio: 2 / 3),
                        itemBuilder: (context, index) {
                         
                    
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LatestProductSel(
                                        latestp:
                                            snapshot.getLatestList[index])));
                              },
                              child: Card(
                                elevation: 10,
                                shape: cardStyle(),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [(snapshot.getLatestList[index].image!=null&&snapshot.getLatestList[index].image.isNotEmpty)?
                                    Image.memory(base64.decode(snapshot.getLatestList[index].image)
                                      ,
                                      height: 120,
                                      width: double.infinity,
                                    ):Container(height:120,child: Image.asset(
                  "assets/images/no_img.png",
                  gaplessPlayback: true,
                ),),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0, top: 8),
                                      child: Text(
                                        snapshot.getLatestList[index].name,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    Text(
                                        ' QAR  ' +
                                            snapshot.getLatestList[index].price
                                                .toStringAsFixed(2),
                                        style: TextStyle(
                                            color: black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            );
                      
                         
                        }),
                  ),
                  (snapshot.hasNext) ? CircularProgressIndicator() : SizedBox(),
                ],
              );
              // }
            }
          }),
        ));
  }
}
