import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:pmc_app/main.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:pmc_app/provider/brand_provider.dart';
import 'package:pmc_app/provider/featured_provider.dart';
import 'package:pmc_app/provider/latest_prod_provider.dart';
import 'package:pmc_app/provider/promotion_provider.dart';
import 'package:pmc_app/provider/selling_api_provider.dart';
import 'package:pmc_app/screens/screen_home.dart';
import 'package:pmc_app/screens/screens.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restart_app/restart_app.dart';

class LanguageSelection extends StatefulWidget {
  const LanguageSelection({Key? key}) : super(key: key);

  @override
  State<LanguageSelection> createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.all(7),
        child: ListView(
          children: [
            ListTile(
              title: Text('English'),
              onTap: () async {
                context.setLocale(Locale("en", "US"));
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('language');
                Phoenix.rebirth(context);

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Screens()));
              },
            ),
            ListTile(
                title: Text('العربية'),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('language', 'ar');
                  context.setLocale(Locale("ar", "SA"));
                  Phoenix.rebirth(context);
                  // Restart.restartApp();

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return Screens();
                  }));
                })
          ],
        ),
      ),
    );
  }
}
