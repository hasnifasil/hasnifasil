

import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({ Key? key }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isSwitched=false;
  bool history=false;
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(padding: EdgeInsets.all(10), child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Recieve Notifications',style: TextStyle(fontSize: 18),),
            Switch(value: isSwitched, onChanged: (value){
              
                  setState(() {
                    isSwitched=value;
                    
                  });
            })],),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Track and Show in Recent History',style: TextStyle(fontSize: 18),),
            Switch(value: history, onChanged: (value){
              
                  setState(() {
                    history=value;
                    
                  });
            })],),
          ],
        ),
          
        ),
      ),
    );
  }

}