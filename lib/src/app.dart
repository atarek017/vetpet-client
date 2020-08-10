import 'package:flutter/material.dart';
import 'package:vetwork_app/src/providers/authentiction.dart';

import 'screens/splash_screen.dart';

class App extends StatelessWidget {
  Authentication authentication = Authentication();

  Widget build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Vetwork",
      theme: ThemeData(primarySwatch: Colors.green),
      home: SplashScreen(),

      builder: (c, w) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (BuildContext context) {
              return new MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: 1.0,
                ),
                child: w,
              );
            },
          ),
        );
      },
    );
  }
}
