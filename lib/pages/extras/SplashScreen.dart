import 'package:customer_portal/pages/extras/onBoardingScreen.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dashboard.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opcty = 0.00;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3)).then((value) async {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      if (_pref.getString("token") != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (c) => Dashboard(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (bc) => OnBoardingScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xffEFEFEF),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            // height: 500,
            child: Container(
              child: Image.asset(
                "assets/images/splash_top.png",
                // height: 200,

                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width - 30,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            // height: 500,
            child: RotatedBox(
              quarterTurns: 2,
              child: Image.asset(
                "assets/images/splash_top.png",
                // height: 200,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width - 30,
              ),
            ),
          ),
          Center(
            child: Container(
              height: 100,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 50,
                    child: RiveAnimation.asset(
                      "assets/rive/enrix_logo.riv",
                      fit: BoxFit.contain,
                      onInit: (a) {
                        Future.delayed(Duration(seconds: 1)).then((value) {
                          setState(() {
                            _opcty = 1.00;
                          });
                        });
                      },
                      controllers: [
                        SpeedController("ani1", speedMultiplier: 1.5),
                      ],
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _opcty,
                    duration: Duration(seconds: 1),
                    child: Image.asset(
                      "assets/logo_down.png",
                      width: 50,
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Text(
              "© Enrix Property Management",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff7e7e7e),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
