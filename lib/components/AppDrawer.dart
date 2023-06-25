import 'package:customer_portal/Controllers/DrawerController.dart' as dc;
import 'package:customer_portal/Controllers/UserController.dart';
import 'package:customer_portal/others/pie_chart.dart';
import 'package:customer_portal/pages/Payments/PaymentsPage.dart';
import 'package:customer_portal/pages/calenderPage.dart';
import 'package:customer_portal/pages/dashboard.dart';
import 'package:customer_portal/pages/profilePage.dart';
import 'package:customer_portal/pages/property/propertyList.dart';
import 'package:customer_portal/pages/requests/requestsPage.dart';
import 'package:customer_portal/pages/requests/tasksPage.dart';
import 'package:customer_portal/utils/Base.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String currentPage = "home";

  ImageProvider getImage(String? url) {
    if (url == null || url == "") {
      return AssetImage("assets/person.png");
    }
    return NetworkImage(
        "${Base.baseUrlWithoutApi}storage/images/profile_image/${url}");
  }

  @override
  Widget build(BuildContext context) {
    dc.DrawerController ctrl = Get.find(tag: "drawer");
    return Drawer(
      child: GetX<dc.DrawerController>(
          // stream: null,
          init: ctrl,
          builder: (ctrls) {
            return ListView(
              shrinkWrap: true,
              children: [
                // Obx((cx) {
                //   return Text("");
                // }),
                GetX<UserController>(
                    init: UserController(),
                    builder: (controller) {
                      return DrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          image: DecorationImage(
                            image: AssetImage("assets/images/splash_top.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 40,
                              backgroundImage: getImage(
                                  controller.customer.value.profileImage),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hello,",
                                  style: TextStyle(
                                      // fontWeight: FontWeight.,
                                      color: Colors.black.withOpacity(0.7),
                                      fontStyle: FontStyle.italic,
                                      fontFamily:
                                          GoogleFonts.raleway().fontFamily),
                                ),
                                Text(
                                  controller.customer.value.name ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                controller.customer.value.status
                                    ? const SizedBox()
                                    : const SizedBox(
                                        height: 8,
                                      ),
                                controller.customer.value.status
                                    ? const SizedBox()
                                    : ElevatedButton(
                                        onPressed: () {},
                                        child:
                                            const Text("Complete your profile"),
                                      )
                              ],
                            ),
                            // Text(
                            //   controller.customer.value.email ?? "",
                            //   style: TextStyle(fontSize: 12),
                            // ),
                          ],
                        ),
                      );
                    }),
                Container(
                  child: ListTile(
                    onTap: () {
                      ctrl.changePage("Home");
                      navigateWithFadeReplace(context, Dashboard());
                    },
                    title: Text(
                      "Home",
                      style: TextStyle(
                        fontWeight: ctrl.currentPage.value == "Home"
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: ctrl.currentPage.value == "Home"
                            ? Colors.black
                            : Colors.black.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    ctrl.changePage("Profile");
                    navigateWithFadeReplace(context, ProfilePage());
                  },
                  title: Text(
                    "My Profile",
                    style: TextStyle(
                      fontWeight: ctrl.currentPage.value == "Profile"
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: ctrl.currentPage.value == "Profile"
                          ? Colors.black
                          : Colors.black.withOpacity(0.7),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    ctrl.changePage("Properties");
                    navigateWithFadeReplace(context, PropertyListPage());
                  },
                  title: Text(
                    "Property List",
                    style: TextStyle(
                      fontWeight: ctrl.currentPage.value == "Properties"
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: ctrl.currentPage.value == "Properties"
                          ? Colors.black
                          : Colors.black.withOpacity(0.7),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    ctrl.changePage("Calendar");
                    navigateWithFadeReplace(context, CalenderPage());
                  },
                  title: Text(
                    "Calendar",
                    style: TextStyle(
                      fontWeight: ctrl.currentPage.value == "Calendar"
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: ctrl.currentPage.value == "Calendar"
                          ? Colors.black
                          : Colors.black.withOpacity(0.7),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    ctrl.changePage("Requests");
                    navigateWithFadeReplace(context, RequestsPage());
                  },
                  title: Text(
                    "Requests",
                    style: TextStyle(
                      fontWeight: ctrl.currentPage.value == "Requests"
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: ctrl.currentPage.value == "Requests"
                          ? Colors.black
                          : Colors.black.withOpacity(0.7),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    ctrl.changePage("Tasks");
                    navigateWithFadeReplace(
                        context,
                        TasksPage(
                          propertyName: "All Properties",
                        ));
                  },
                  title: Text(
                    "Tasks",
                    style: TextStyle(
                      fontWeight: ctrl.currentPage.value == "Tasks"
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: ctrl.currentPage.value == "Tasks"
                          ? Colors.black
                          : Colors.black.withOpacity(0.7),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    ctrl.changePage("Payments");
                    navigateWithFadeReplace(context, PaymentPage());
                  },
                  title: Text(
                    "Payments",
                    style: TextStyle(
                      fontWeight: ctrl.currentPage.value == "Payments"
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: ctrl.currentPage.value == "Payments"
                          ? Colors.black
                          : Colors.black.withOpacity(0.7),
                    ),
                  ),
                ),
                Divider(),
                // ListTile(
                //   onTap: () {
                //     Navigator.pop(context);
                //     showAboutDialog(
                //       context: context,
                //       applicationName: "ENRIX Client portal",
                //       applicationVersion: "1.0.0",
                //       applicationIcon: FlutterLogo(),
                //       applicationLegalese: "lorem lipsom",
                //     );
                //   },
                //   title: Text("About"),
                // ),
                ListTile(
                  onTap: () async {
                    // return;
                    Navigator.pop(context);
                    String url = "mailto:contact@enrix.in";
                    try {
                      if (await canLaunch(url)) {
                        await launch(url);
                      }
                    } catch (e) {
                      Get.snackbar(
                        "Email client not configured",
                        "write your queries to contact@enrix.in",
                        snackPosition: SnackPosition.BOTTOM,
                        barBlur: 0,
                        backgroundColor: Colors.grey,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(0),
                        borderRadius: 0,
                        overlayBlur: 0,
                      );
                    }
                  },
                  title: Text("Any Queries?"),
                ),
              ],
            );
          }),
    );
  }
}
