


import 'package:flutter/material.dart';
import 'package:pmc_app/API/constats/styles.dart';
import 'package:pmc_app/screens/screens.dart';

class OrderCancelled extends StatefulWidget {
  const OrderCancelled({Key? key}) : super(key: key);

  @override
  State<OrderCancelled> createState() => _OrderCancelledState();
}

class _OrderCancelledState extends State<OrderCancelled> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(8),
          child: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel_presentation_rounded,
                    size: 100,
                    color: red
                  ),
                  Text(
                    'Transaction failed',
                    style: TextStyle(fontSize: 23),
                  ),
                  
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Screens()));
                      },
                      child: Text('OK'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}