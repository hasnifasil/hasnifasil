import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pmc_app/models/all_order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pmc_app/API/constats/constant_api.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({Key? key}) : super(key: key);

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  bool isLoading = false;
  List<Data> list = [];
  @override
  void initState() {
    getAllOrderList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('all_orders'.tr()),
        ),
        body: Container(
            margin: EdgeInsets.all(6),
            child: (list.length == 0)
                ? Center(
                    child: Text(
                      'no_orders'.tr() + ".",
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                : ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.grey[300],
                        margin: EdgeInsets.all(10),
                        child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('order'.tr() +
                                    list[index].order.toString()),
                                Text('order_placed_on'.tr() +
                                    list[index].dateOrder.toString()),
                                Text('order_total'.tr() +
                                    list[index].orderTotal!.toStringAsFixed(2)),
                                Text('mobile'.tr() +
                                    "974" +
                                    list[index].mobile.toString()),
                                Text('qatar'.tr()),
                                Text('building_number'.tr() +
                                    list[index].building.toString()),
                                Text('city'.tr() + list[index].city.toString()),
                                Text('zone'.tr() + list[index].zone.toString()),
                              ],
                            )),
                      );

                      return Text('');
                    })),
      ),
    );
  }

  Future<AllOrderModel?> getAllOrderList() async {
    setState(() {
      list.clear();
      isLoading = true;
    });

    Dio dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print(token);
    final response = await dio
        .get(base_url + 'api/user/orders', queryParameters: {"token": token});
    print(response);
    if (response.statusCode == 200) {
      AllOrderModel dataa = AllOrderModel.fromJson((response.data));
      setState(() {
        list = dataa.data!;
        print(dataa);
      });
    } else {
      // setState(() {
      //   isLoading = false;
      // });
    }
  }
}
