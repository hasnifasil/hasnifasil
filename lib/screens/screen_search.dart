import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pmc_app/API/constats/constant_api.dart';
import 'package:pmc_app/API/constats/styles.dart';
import 'package:pmc_app/provider/search_filter_provider.dart';
import 'package:pmc_app/provider/search_provider.dart';

import 'package:pmc_app/screens/poduct_screen_latest.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/latest_products_model.dart';

class ScreenSearch extends StatefulWidget {
  const ScreenSearch({Key? key}) : super(key: key);

  @override
  _ScreenSearchState createState() => _ScreenSearchState();
}

class _ScreenSearchState extends State<ScreenSearch> {
  TextEditingController serchcntroller = TextEditingController();
  bool isLoading = false;
  List<Products> list = [];
  List<Products> listfilter = [];
  bool isEnable = false;
  bool asc = false;
  bool desc = false;
  bool filter = false;
  bool filterloading = true;
  final ScrollController _controller = ScrollController();
  final ScrollController _filcontroller = ScrollController();
List <String> keys=[];
  bool? searchLoading;

  @override
  void initState() {
    arabicSelectedorNot();

    

    
    Provider.of<SearchProductFilterProvider>(context, listen: false)
        .getSearchFilterList
        .clear();

    super.initState();
   
  }

  fetchData() {

    Provider.of<SearchProductProvider>(context, listen: false)
        .getSearchData(serchcntroller.text, context);
  }

  fetchfilData() {
    Provider.of<SearchProductFilterProvider>(context, listen: false)
        .getSearchFilterData(serchcntroller.text, context);
  }

  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      fetchData();
    }
  }

  void _scrollFilListener() {
    if (_filcontroller.position.pixels ==
        _filcontroller.position.maxScrollExtent) {
      fetchfilData();
    }
  }

  bool? languageArabic;
  arabicSelectedorNot() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
//final lang=prefs.getString('language');
    if (prefs.getString('language') != null) {
      setState(() {
        languageArabic = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          title: Text('search'.tr()),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PopupMenuButton<String>(
                icon: Icon(Icons.filter_alt_outlined),
                onSelected: (index) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  switch (index) {
                    case 'Price High to Low':
                      prefs.remove('asc');
                      prefs.setString('desc', 'desc');
                      Provider.of<SearchProductProvider>(context, listen: false)
                          .getSearchList
                          .clear();
                      Provider.of<SearchProductFilterProvider>(context,
                              listen: false)
                          .getSearchFilterList
                          .clear();

                      setState(() {
                        desc = true;
                        filter = true;
                        asc = false;
                      });

                      Provider.of<SearchProductFilterProvider>(context,
                              listen: false)
                          .page = 1;
                      fetchfilData();
                      _filcontroller.addListener(_scrollFilListener);
                      break;

                    case 'Price Low to High':
                      prefs.remove('desc');
                      prefs.setString('asc', 'asc');
                      Provider.of<SearchProductProvider>(context, listen: false)
                          .getSearchList
                          .clear();
                      Provider.of<SearchProductFilterProvider>(context,
                              listen: false)
                          .getSearchFilterList
                          .clear();
                      setState(() {
                        asc = true;
                        desc = false;
                        filter = true;
                      });
                      // Provider.of<SearchProductFilterProvider>(context, listen: false).order='asc';

                      Provider.of<SearchProductFilterProvider>(context,
                              listen: false)
                          .page = 1;
                      fetchfilData();

                      _filcontroller.addListener(_scrollFilListener);
                      break;
                    case 'السعر الاعلى الى الادنى':
                      prefs.remove('asc');
                      prefs.setString('desc', 'desc');
                      Provider.of<SearchProductProvider>(context, listen: false)
                          .getSearchList
                          .clear();
                      Provider.of<SearchProductFilterProvider>(context,
                              listen: false)
                          .getSearchFilterList
                          .clear();

                      setState(() {
                        desc = true;
                        filter = true;
                        asc = false;
                      });

                      Provider.of<SearchProductFilterProvider>(context,
                              listen: false)
                          .page = 1;
                      fetchfilData();
                      _filcontroller.addListener(_scrollFilListener);
                      break;
                    case 'السعر من الارخص للاعلى':
                      prefs.remove('desc');
                      prefs.setString('asc', 'asc');
                      Provider.of<SearchProductProvider>(context, listen: false)
                          .getSearchList
                          .clear();
                      Provider.of<SearchProductFilterProvider>(context,
                              listen: false)
                          .getSearchFilterList
                          .clear();
                      setState(() {
                        asc = true;
                        desc = false;
                        filter = true;
                      });

                      Provider.of<SearchProductFilterProvider>(context,
                              listen: false)
                          .page = 1;
                      fetchfilData();

                      _filcontroller.addListener(_scrollFilListener);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {'low_to_high'.tr(), 'high_to_low'.tr()}
                      .map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(55),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 46,
                child: Stack(children: [
                  TextField(maxLines: 1,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      hintText: 'search'.tr(),
                    ),
                    controller: serchcntroller,
                    onSubmitted: (v) {
                      if (v.isNotEmpty) {
                        Provider.of<SearchProductFilterProvider>(context,
                                listen: false)
                            .getSearchFilterList
                            .clear();
                        setState(() {
                          //listfilter.clear();
                          filter = false;
                        });

                        Provider.of<SearchProductProvider>(context,
                                listen: false)
                            .getSearchList
                            .clear();
                        Provider.of<SearchProductProvider>(context,
                                listen: false)
                            .page = 1;
                        // search(serchcntroller.text);
                        fetchData();
                        _controller.addListener(_scrollListener);
                      }
                    },
                  ),
                  if (languageArabic == true)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(1.6),
                        child: Container(
                          height: 41,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: yellow,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: (){
                            // SharedPreferences prefs=await SharedPreferences.getInstance();
                            // List.forEach((key,value){if(value==true){
                            //   keys.add(key);
                            // }});
                              
                              Provider.of<SearchProductFilterProvider>(context,
                                      listen: false)
                                  .getSearchFilterList
                                  .clear();
                              setState(() {
                                // listfilter.clear();
                                filter = false;
                              });

                              if (serchcntroller.text.isNotEmpty) {
                              //   prefs.setStringList('recent_key',[serchcntroller.text] );
                              //  final aa=prefs.getStringList('recent_key');
                              
                               // print(aa);
                                //  search(serchcntroller.text);
                                fetchData();
                                _controller.addListener(_scrollListener);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  if (languageArabic != true)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          height: 41,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: yellow,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              Provider.of<SearchProductFilterProvider>(context,
                                      listen: false)
                                  .getSearchFilterList
                                  .clear();
                              setState(() {
                               
                                filter = false;
                              });

                              if (serchcntroller.text.isNotEmpty) {
                          
                                fetchData();
                                _controller.addListener(_scrollListener);
                              }
                            },
                          ),
                        ),
                      ),
                    )
                ]),
              ),
            ),
          ),
          elevation: 0,
        ),
        body: (!filter&&serchcntroller.text.isNotEmpty)
            ? Container(
                decoration: containerBox(),
                margin: EdgeInsets.all(2),
                child: Column(children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(child: Consumer<SearchProductProvider>(
                          builder: (context, snapshot, _) {
                    if (snapshot.isLoading == true) {
                      return fadeShimmerList();
                    }

                    return   (snapshot.getSearchList.length==0)?Center(child: Text('no_products'.tr()+"!!!",style: TextStyle(fontSize: 18),)): ListView.builder(
                        controller: _controller,
                        itemCount: snapshot.getSearchList.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, i) {
                          return Card(
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1.0)),
                            child: InkWell(
                              splashColor: Colors.lightBlue,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        print(snapshot.getSearchList[i].price);

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LatestProductSel(
                                                        latestp: snapshot
                                                                .getSearchList[
                                                            i])));
                                      },
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListTile(
                                            title: Text(
                                              snapshot.getSearchList[i].name,
                                              textAlign: TextAlign.center,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: black),
                                            ),
                                            subtitle: Row(
                                              children: [
                                                SizedBox(
                                                  width: 17,
                                                ),
                                                Text(
                                                    'QAR ' +
                                                        snapshot
                                                            .getSearchList[i]
                                                            .price
                                                            .toStringAsFixed(2),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: black)),
                                              ],
                                            ),
                                            leading: (snapshot.getSearchList[i]
                                                            .image !=
                                                        null &&
                                                    snapshot.getSearchList[i]
                                                        .image.isNotEmpty)
                                                ? (Image.memory(
                                                    base64.decode(snapshot
                                                        .getSearchList[i]
                                                        .image),
                                                    height: 300,
                                                    gaplessPlayback: true,
                                                    width: 100,
                                                  ))
                                                : Container(
                                                  width: 90,
                                                  height: 50,child: Image.asset(
                  "assets/images/no_img.png",
                  gaplessPlayback: true,
                ),
                                                ),
                                          ),
                                        ),
                                        constraints: BoxConstraints(
                                          minHeight: 90,
                                          maxHeight: 250,
                                          minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .85,
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .85,
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Center(
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  })
                      // }
                      //  return CircularProgressIndicator();

                      )
                ]))
            : getFilterList());
  }

  
  getFilterList() {
    return Container(
      color: white,
      child: Consumer<SearchProductFilterProvider>(
          builder: (context, snapshot, _) {
        if (snapshot.isLoading == true) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 6,
            itemBuilder: ((context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(19)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: FadeShimmer(
                          height: 110,
                          width: 70,
                          radius: 4,
                          highlightColor: Color.fromARGB(255, 174, 174, 179),
                          baseColor: Color.fromARGB(255, 215, 227, 240),
                        ),
                      ),
                      title: FadeShimmer(
                        height: 70,
                        width: 300,
                        radius: 4,
                        highlightColor: Color.fromARGB(255, 174, 174, 179),
                        baseColor: Color.fromARGB(255, 215, 227, 240),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }

        return Builder(builder: (context) {
          return   (snapshot.getSearchFilterList.length==0)?Center(child: Text('no_products'.tr()+"!!!",style: TextStyle(fontSize: 18),)): ListView.builder(
              controller: _filcontroller,
              itemCount: snapshot.getSearchFilterList.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, i) {
                return Card(
                  elevation: 15,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1.0)),
                  child: InkWell(
                    splashColor: Colors.lightBlue,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              print(listfilter[i].price);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LatestProductSel(
                                          latestp: snapshot
                                              .getSearchFilterList[i])));
                            },
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      snapshot.getSearchFilterList[i].name,
                                      textAlign: TextAlign.center,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: black),
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(left: 13.0),
                                    child: Text(
                                      'QAR ' +
                                          snapshot.getSearchFilterList[i].price
                                              .toStringAsFixed(2),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: black),
                                    ),
                                  ),
                                  leading:
                                      (snapshot.getSearchFilterList[i].image !=
                                                  null &&
                                              snapshot.getSearchFilterList[i]
                                                  .image.isNotEmpty)
                                          ? Image.memory(
                                              base64.decode(snapshot
                                                  .getSearchFilterList[i]
                                                  .image),
                                              height: double.infinity,
                                              width: 100,
                                            )
                                          : Container(
                                            width: 90,
                                            height: 50,child: Image.asset(
                  "assets/images/no_img.png",
                  gaplessPlayback: true,
                ),
                                          ),
                                ),
                              ),
                              constraints: BoxConstraints(
                                minHeight: 90,
                                maxHeight: 250,
                                minWidth:
                                    MediaQuery.of(context).size.width * .85,
                                maxWidth:
                                    MediaQuery.of(context).size.width * .85,
                              ),
                            ),
                          ),
                          Spacer(),
                          Center(
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
      }),
    );
  }

  @override
  void dispose() {
    serchcntroller.dispose();

    super.dispose();
  }
}
