import 'dart:convert';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pmc_app/API/constats/styles.dart';
import 'package:pmc_app/models/promotion_model.dart';
import 'package:pmc_app/provider/promotion_provider.dart';
import 'package:pmc_app/screens/poduct_screen_latest.dart';
import 'package:pmc_app/screens/product_screen_promotion.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PromoBuyOne extends StatefulWidget {
  final int id;
  final String name;
  bool discount = true;
  final String type;

  PromoBuyOne(
      {Key? key, required this.id, required this.name, required this.type})
      : super(key: key);

  @override
  State<PromoBuyOne> createState() => _PromoBuyOneState();
}

class _PromoBuyOneState extends State<PromoBuyOne> {
  

  final ScrollController _controller = ScrollController();
  bool languageLoad=false;
  @override
  void initState() {
   
   
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
    Provider.of<BuyOneProvider>(context, listen: false)
        .getBuyOneData(id: widget.id, context: context);
  }
  

  firstLoad() async{
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // if (pref.getString('language') != null) {
    //   Provider.of<BuyOneProvider>(context, listen: false).lang = 'ar';
    // } else {
    //   Provider.of<BuyOneProvider>(context, listen: false).lang = 'en';
    // }
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // if (pref.getString('language') != null) {
    //   Provider.of<BuyOneProvider>(context, listen: false).lang = 'ar';
    // }
  
    Provider.of<BuyOneProvider>(context, listen: false).getbuyOneList.clear();
    Provider.of<BuyOneProvider>(context, listen: false).page = 1;
    print(widget.id);
    Provider.of<BuyOneProvider>(context, listen: false)
        .getBuyOneData(id: widget.id, context: context);
  }

  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      Provider.of<BuyOneProvider>(context, listen: false).hasNext = true;
      fetchData();
     
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Consumer<BuyOneProvider>(builder: (context, snapshot, _) {
       
            if (snapshot.isl == true) {
              return gridFadeShimmer();
              
            } 
           else {
           
              return (snapshot.getbuyOneList.length==0&&snapshot.getbuyOneList.isEmpty)?Center(child: Text('no_products'.tr()+'!!!',style: TextStyle(fontSize: 18),)):Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                        controller: _controller,
                        itemCount: snapshot.getbuyOneList.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 250, childAspectRatio: 2 / 3),
                        itemBuilder: (context, index) {
                         
                          
                  
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LatestProductSel(
                                          
                                          latestp: snapshot.getbuyOneList[index])));
                            },
                            child: InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Card(
                                  shape: cardStyle(),
                                  elevation: 10,
                                  shadowColor: black,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [(snapshot.getbuyOneList[index].image!=null&&snapshot.getbuyOneList[index].image.isNotEmpty)?
                                      Image.memory(
                                       base64Decode(snapshot.getbuyOneList[index].image),
                                        width: 150,
                                        height: 140,
                                      ):Container(height: 120,child: Image.asset(
                  "assets/images/no_img.png",
                  gaplessPlayback: true,
                ),),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          snapshot.getbuyOneList[index].name,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: black,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            if (snapshot.getbuyOneList[index]
                                                        .discount_price !=
                                                    null &&
                                                snapshot.getbuyOneList[index]
                                                    .discount_price.isNotEmpty)
                                              Text(
                                                'QAR ' +
                                                    snapshot.getbuyOneList[index]
                                                        .discount_price
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            if (snapshot.getbuyOneList[index]
                                                        .discount_price !=
                                                    null &&
                                                snapshot.getbuyOneList[index]
                                                    .discount_price.isNotEmpty)
                                              Text(
                                                'QAR ' +
                                                    snapshot
                                                        .getbuyOneList[index].price
                                                        .toStringAsFixed(2),
                                                style: TextStyle(
                                                    decoration:
                                                        TextDecoration.lineThrough,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            if (snapshot.getbuyOneList[index]
                                                .discount_price.isEmpty)
                                              Text(
                                                'QAR ' +
                                                    snapshot
                                                        .getbuyOneList[index].price
                                                        .toStringAsFixed(2),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                (snapshot.hasNext) ? CircularProgressIndicator() : SizedBox(), ],
              );
            }
    }),
        ));
  }
}
