import 'package:customer_portal/Controllers/FabController.dart';
import 'package:customer_portal/Controllers/UserController.dart';
import 'package:customer_portal/db/Adapters/piwd_model.dart';
import 'package:customer_portal/pages/auth/loginPage.dart';
import 'package:customer_portal/pages/extras/SplashScreen.dart';
import 'package:customer_portal/pages/extras/onBoardingScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Controllers/DrawerController.dart' as dc;

Future<void> main() async {
  // Directory temp = await getApplicationDocumentsDirectory();
  // Hive.init(temp.path);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Hive.initFlutter();
  Hive.registerAdapter(PiwdAdapter());
  await Hive.openBox("store");
  await Hive.openBox("cache_store");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final c = Get.put(UserController(), tag: "user");
  final fabController = Get.put(FabController(), tag: "fab");
  final drawerCtrl = Get.put(dc.DrawerController(), tag: "drawer");
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        print("Working :" + n.metrics.pixels.toString());
        double lastRecorded = 0.00;
        if (n.metrics.pixels > 30) {
          fabController.changeState(false);
        } else {
          fabController.changeState(true);
        }
        return false;
      },
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.grey,
          fontFamily: GoogleFonts.raleway().fontFamily,
        ),
        navigatorObservers: [],
        home: SplashScreen(),
      ),
    );
  }
}
