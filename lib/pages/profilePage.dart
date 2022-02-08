import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:customer_portal/Controllers/NotificationController.dart';
import 'package:customer_portal/Controllers/UserController.dart';
import 'package:customer_portal/Models/Customer.dart';
import 'package:customer_portal/components/AppDrawer.dart';
import 'package:customer_portal/components/customLoader.dart';
import 'package:customer_portal/interceptors/cache_interceptor.dart';
import 'package:customer_portal/pages/extras/CropPage.dart';
import 'package:customer_portal/utils/ApiHelper.dart';
import 'package:customer_portal/utils/Base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_range/flutter_time_range.dart';
import 'package:get/get.dart' as gts;
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snap_scroll_physics/snap_scroll_physics.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:time_range/time_range.dart';
// import 'package:time_range_picker/time_range_picker.dart';

import 'auth/loginPage.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ScrollController _controller = new ScrollController();
  bool _isLoading = false;
  bool _isTimeRangeOpen = false;
  List<DropdownMenuItem<String>> _timeZones = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCustomer();
    _controller.addListener(() {
      //print(_controller.offset);
    });
    _getTimeZones();
  }

  _getTimeZones() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/data/timezone.json");
    final jsonResult = jsonDecode(data);
    print(jsonResult[0]['value']);
    jsonResult.forEach((element) {
      _timeZones.add(DropdownMenuItem(
        child: Text(element['value']),
        value: element['value'],
      ));
    });
    setState(() {});
  }

  Customer? _customer = null;
  bool _forceUpdate = false;
  getCustomer() async {
    print("Profile");
    Dio dio = ApiHelper().dio;
    var _pref = await SharedPreferences.getInstance();
    String? _token = _pref.getString("token");
    dio.options.extra.addAll({"canCache": true});
    // dio.interceptors.add(DioCacheInterceptor(
    //     options: CacheOptions(
    //   store: MemCacheStore(),
    //   policy: CachePolicy.request,
    //   maxStale: Duration(days: 7),
    // )));
    // dio.interceptors.add(CacheInterceptor(
    //   isForcedRefresh: _forceUpdate,
    //   cacheDuration: Duration(days: 7),
    // ));
    //print(_token);
    setState(() {
      _isLoading = true;
      if (!_forceUpdate) {
        _forceUpdate = true;
      }
    });
    print(dio.interceptors);
    dio
        .get(
      Base.baseUrl + "customer",
    )
        .then(
      (value) {
        //print(value.data);
        if (value.statusCode == 200) {
          // //print(value.data);
          setState(() {
            _customer = Customer.fromJson(value.data['user']);
          });
          print(_customer?.city);
          UserController().getCustomer();
        }
        setState(() {
          _isLoading = false;
        });
      },
    );
  }

  updateField(String field, String value) async {
    setState(() {
      _isLoading = true;
    });
    ApiHelper()
        .dio
        .post(
          Base.baseUrl + "customer",
          data: FormData.fromMap({field: value}),
        )
        .then((value) {
      getCustomer();

      //print(value.statusCode);
    });
  }

  changePassword(String value) async {
    ApiHelper()
        .dio
        .post(
          "changepassword",
          data: FormData.fromMap({"password": value}),
        )
        .then((value) {
      ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
          title: "Password Changes Successfully",
          confirmButtonColor: Colors.grey,
          type: ArtSweetAlertType.success,
          // titleStyle: TextStyle(fontSize: 16),
          // style: SweetAlertV2Style.success,
        ),
      );

      //print(value.statusCode);
    });
  }

  updateImage(String field, File value) async {
    setState(() {
      _isLoading = true;
    });
    ApiHelper()
        .dio
        .post(
          Base.baseUrl + "customer",
          data: FormData.fromMap(
              {field: await MultipartFile.fromFile(value.path)}),
        )
        .then((value) {
      getCustomer();
      //print(value.statusCode);
      UserController().getCustomer();
    });
  }

  double _lastScroll = 0.0;
  DateFormat format = DateFormat('dd MMMM yyyy');
  TextStyle headingStyle = TextStyle(fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   getCustomer();
      // }),
      drawer: Navigator.canPop(context) ? null : AppDrawer(),
      body: SafeArea(
          child: ModalProgressHUD(
        inAsyncCall: (_isLoading && !_isTimeRangeOpen),
        opacity: 0.3,
        color: Colors.black,
        progressIndicator: CustomLoader(),
        child: CustomScrollView(
          controller: _controller,
          // scrollBehavior: MaterialScrollBehavior(),
          // physics:
          //     RangeMaintainingScrollPhysics(parent: BouncingScrollPhysics()),

          physics: SnapScrollPhysics(
              // parent: RangeMaintainingScrollPhysics(
              //     parent: BouncingScrollPhysics()),
              snaps: [
                // Snap.avoidZone(10,
                //     100), // If the scroll offset is expected to stop between 0-200, the scroll will snap to 0 if the expected one is between 0-99, and to 200 if it is between 100-200,
                Snap.avoidZone(
                  0,
                  131,
                  delimiter: 90,
                ), // If the scroll offset is expected to stop between 0-200, the scroll will snap to 0 if the expected one is between 0-49, and to 200 if it is between 50-200
              ]),

          slivers: [
            SliverPersistentHeader(
              pinned: true,
              // floating: true,

              delegate: CustomSliverHeader(
                onScroll: (d) {},
                changeImage: (File f) {
                  updateImage("profile_image", f);
                },
                imageUrl: _customer?.profileImage ?? "",
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                child: _customer == null
                    ? Container(
                        child: Center(
                            // child: CircularProgressIndicator(),
                            ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 60),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            SizedBox(height: 10),
                            ListTile(
                              title: Text(
                                "Name",
                                style: headingStyle,
                              ),
                              subtitle: Text(_customer?.name ?? ""),
                            ),
                            Divider(),
                            ListTile(
                              title: Text(
                                "User ID",
                                style: headingStyle,
                              ),
                              subtitle: Text(_customer?.customerId != null
                                  ? _customer?.customerId.toString() ?? ""
                                  : "Not assigned"),
                            ),
                            Divider(),
                            ListTile(
                              title: Text(
                                "Date of Signup",
                                style: headingStyle,
                              ),
                              subtitle: Text(format.format(
                                  DateTime.parse(_customer?.createdAt ?? ""))),
                            ),
                            Divider(),
                            ListTile(
                              title: Text(
                                "Current Address",
                                style: headingStyle,
                              ),
                              trailing: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _textEditPopup("Current Address",
                                        _customer!.currentAddress!);
                                  }),
                              subtitle:
                                  Text(_customer!.currentAddress.toString()),
                            ),
                            Divider(),
                            ListTile(
                              title: Text(
                                "Email",
                                style: headingStyle,
                              ),
                              subtitle: Text(_customer!.email!),
                              trailing: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _textEditPopup(
                                        "Email", _customer!.email ?? '');
                                  }),
                            ),
                            Divider(),
                            ListTile(
                              title: Text(
                                "Phone",
                                style: headingStyle,
                              ),
                              subtitle: Text(_customer!.phone ?? ""),
                              trailing: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _textEditPopup(
                                        "Phone", _customer!.phone ?? "");
                                  }),
                            ),
                            Divider(),
                            ListTile(
                              title: Text(
                                "Preferred Communication Time",
                                style: headingStyle,
                              ),
                              subtitle: Text(_customer!.timeOfContact ?? ""),
                              trailing: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _preferedTimePopup("time_of_contact",
                                        _customer!.timeOfContact ?? "");
                                  }),
                            ),
                            Divider(),
                            ListTile(
                              title: Text(
                                "Time Zone",
                                style: headingStyle,
                              ),
                              subtitle: Text(_customer!.timeOfContact!),
                              trailing: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _preferedTimePopup("time_of_contact",
                                        _customer!.timeOfContact!);
                                  }),
                            ),
                            Divider(),
                            ListTile(
                              title: Text(
                                "Preferred Communication Mode",
                                style: headingStyle,
                              ),
                              subtitle: Text(_customer!.modeOfContact!),
                              trailing: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _preferedModeOfContactsPopup(
                                        "mode_of_contact",
                                        _customer!.modeOfContact!);
                                  }),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: InkWell(
                                onTap: () async {
                                  showDialog(
                                      context: context,
                                      builder: (builder) {
                                        final _key = GlobalKey<FormState>();
                                        String pswd = "";
                                        String cnf_pswd = "";
                                        return Dialog(
                                          insetPadding: EdgeInsets.all(10),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Form(
                                              key: _key,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextFormField(
                                                    decoration: InputDecoration(
                                                      labelText: "Password",
                                                    ),
                                                    onSaved: (e) {
                                                      pswd = e!;
                                                    },
                                                    onChanged: (e) {
                                                      pswd = e;
                                                    },
                                                    validator: (s) {
                                                      if (s!.isEmpty) {
                                                        return "Field can't be empty";
                                                      }

                                                      return null;
                                                    },
                                                  ),
                                                  TextFormField(
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          "Confirm Password",
                                                    ),
                                                    onSaved: (e) {
                                                      pswd = e!;
                                                    },
                                                    validator: (s) {
                                                      if (s!.isEmpty) {
                                                        return "Field can't be empty";
                                                      }

                                                      if (s != pswd) {
                                                        return "Confirm Password didn't match";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  SizedBox(
                                                    height: 25,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          if (!_key
                                                              .currentState!
                                                              .validate())
                                                            return;

                                                          _key.currentState!
                                                              .save();

                                                          changePassword(pswd);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("Change")),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 0.5,
                                  decoration: BoxDecoration(
                                    // color: Colors.grey[400],
                                    // borderRadius: BorderRadius.circular(5),
                                    // border: Border.all(color: Colors.grey[400]),
                                    boxShadow: [
                                      // BoxShadow(
                                      //     color: Colors.black.withOpacity(0.2),
                                      //     blurRadius: 1,
                                      //     offset: Offset(3, 3)
                                      //     // spreadRadius: 5,
                                      //     )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 15),
                                    child: Center(
                                      child: Text(
                                        "Change Password",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: InkWell(
                                onTap: () async {
                                  UserController().logout();
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 0.5,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 8,
                                          offset: Offset(3, 3)
                                          // spreadRadius: 5,
                                          )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 15),
                                    child: Center(
                                      child: Text(
                                        "Logout",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            )
          ],
        ),
      )),
    );
  }

  TimeOfDay timeConvert(String normTime) {
    //print(normTime);
    int hour;
    int minute;
    String ampm = normTime.substring(normTime.length - 2);
    String result = normTime.substring(0, normTime.indexOf(' '));
    if (ampm == 'AM' && int.parse(result.split(":")[1]) != 12) {
      hour = int.parse(result.split(':')[0]);
      if (hour == 12) hour = 0;
      minute = int.parse(result.split(":")[1]);
    } else {
      //print(result.split(':')[0]);
      hour = int.parse(result.split(':')[0]) - 12;
      if (hour <= 0) {
        hour = 24 + hour;
      }
      minute = int.parse(result.split(":")[1]);
    }
    return TimeOfDay(hour: hour, minute: minute);
  }

  _preferedTimeZonePopup(String field, String value) async {
    showDialog(
        context: context,
        builder: (cs) {
          _isTimeRangeOpen = true;
          return Center(
            child: Container(
              // color: Colors.red,
              width: MediaQuery.of(context).size.width,
              child: Dialog(
                insetPadding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField(
                      // hintText: "Select your time zone",
                      // filled: false,
                      value: value,
                      // titleText: "Time Zone",
                      validator: (c) {
                        // //print(c);
                        if (c == null) {
                          return "required";
                        }
                        return null;
                      },
                      // contentPadding: EdgeInsets.only(left: 0, right: 12),
                      onChanged: (String? s) {
                        setState(() {
                          updateField("time_zone", s!);
                          Navigator.pop(context);
                        });
                      },
                      onSaved: (s) {
                        setState(() {
                          // _timeZone = s;
                        });
                      },
                      items: _timeZones,
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 15,
                          ),
                          child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _isTimeRangeOpen = false;
                              },
                              child: Text("Close")),
                        ))
                  ],
                ),
              ),
            ),
          );
        });
    _isTimeRangeOpen = false;

    return;
  }

  _preferedTimePopup(String field, String value) async {
    //print(value.split("-"));
    TimeOfDay start = timeConvert(
      value.split("-")[0].trim(),
    );
    TimeOfDay end = timeConvert(
      value.split("-")[1].trim(),
    );

    showDialog(
        context: context,
        builder: (cs) {
          _isTimeRangeOpen = true;
          return Center(
            child: Container(
              // color: Colors.red,
              width: MediaQuery.of(context).size.width,
              child: Dialog(
                insetPadding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: TimeRange(
                          fromTitle: Text(
                            'From',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          toTitle: Text(
                            'To',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          titlePadding: 10,
                          initialRange: TimeRangeResult(start, end),
                          textStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black87,
                              fontSize: 14),
                          activeTextStyle: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                          borderColor: Colors.grey,
                          backgroundColor: Colors.transparent,
                          activeBackgroundColor: Colors.grey,
                          firstTime: TimeOfDay(hour: 6, minute: 30),
                          lastTime: TimeOfDay(hour: 22, minute: 00),
                          timeStep: 30,
                          timeBlock: 30,
                          onRangeCompleted: (range) {
                            String newValue = range!.start.format(context) +
                                " - " +
                                range.end.format(context);
                            updateField(field, newValue);
                            // Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 15,
                          ),
                          child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _isTimeRangeOpen = false;
                              },
                              child: Text("Close")),
                        ))
                  ],
                ),
              ),
            ),
          );
        });
    _isTimeRangeOpen = false;

    return;
  }

  _preferedModeOfContactsPopup(String field, String value) async {
    String newValue = "";
    showDialog(
      context: context,
      builder: (bc) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: value,
                onChanged: (c) {
                  newValue = c;
                },
                decoration: InputDecoration(
                    helperText: "Please enter with your contact details",
                    labelText: "Preferred Contact Mode",
                    hintText: "Phone..."),
              ),
              Wrap(
                direction: Axis.horizontal,
                spacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                alignment: WrapAlignment.center,
                children: [],
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newValue == "") {
                  Navigator.pop(context);
                  return;
                }
                updateField("mode_of_contact", newValue);
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  _textEditPopup(String field, String value) {
    String newValue = "";
    showDialog(
      context: context,
      builder: (bc) {
        return AlertDialog(
          // title: Text("Edit"),
          content: TextFormField(
            maxLines: 5,
            minLines: 1,
            onChanged: (s) {
              newValue = s;
            },
            initialValue: value,
            decoration: InputDecoration(labelText: field),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newValue == "") {
                  Navigator.pop(context);
                  return;
                }
                // setState(() {
                //   _customer.phone = newValue;
                // });
                updateField(field, newValue);
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }
}

class CustomSliverHeader extends SliverPersistentHeaderDelegate {
  Function(File file) changeImage;
  Function(double extend) onScroll;
  String imageUrl;
  CustomSliverHeader(
      {required this.changeImage,
      required this.imageUrl,
      required this.onScroll});
  double _maxImageRadius = 120;
  double _minImageRadius = 40;
  double _maxImagePositionRight = 0.0;
  final picker = ImagePicker();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final fullPercent = shrinkOffset / 200;
    final percent = shrinkOffset / 140;
    final percent2 = shrinkOffset / 130;

    double imageRadius = (_maxImageRadius * (1 - percent))
        .clamp(_minImageRadius, _maxImageRadius)
        .toDouble();

    onScroll(fullPercent);
    _maxImagePositionRight =
        (MediaQuery.of(context).size.width / 2) - _maxImageRadius / 2;
    // //print(fullPercent);
    return Container(
      // height: percent > 0.6 ? 60 : 220,
      height: double.infinity,
      color: Colors.grey.shade50.withOpacity(0.7),
      // color: percent > 0.6 ? Colors.grey.shade50 : Colors.transparent,

      child: Stack(
        children: [
          Positioned(
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text("My Profile"),
            ),
          ),
          Positioned(
            right: (_maxImagePositionRight * (1 - percent2))
                .clamp(15, _maxImagePositionRight)
                .toDouble(),
            top: (79 * (1 - percent2)).clamp(10, 79).toDouble(),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(120),
                  child: (imageUrl == null || imageUrl == "")
                      ? Image.asset(
                          "assets/avatar.jpg",
                          height: imageRadius,
                          width: imageRadius,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          "${Base.baseUrlWithoutApi}storage/images/profile_image/$imageUrl",
                          height: imageRadius,
                          width: imageRadius,
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: () async {
                      //print("tap");
                      //   var res = await ImagesPicker.pick(
                      //       count: 1,
                      //       cropOpt:
                      //           CropOption(aspectRatio: CropAspectRatio(1, 1)),
                      //       pickType: PickType.image);
                      //   if (res != null) {
                      //     File f = File(res[0].path);
                      //     changeImage(f);
                      // }
                      var res =
                          await picker.getImage(source: ImageSource.gallery);

                      if (res != null) {
                        File? croppedFile = await ImageCropper.cropImage(
                            sourcePath: res.path,
                            aspectRatioPresets: [
                              CropAspectRatioPreset.square,
                            ],
                            androidUiSettings: AndroidUiSettings(
                                toolbarTitle: 'Profile Image',
                                toolbarColor: Colors.grey[800],
                                activeControlsWidgetColor: Colors.grey,
                                toolbarWidgetColor: Colors.white,
                                initAspectRatio: CropAspectRatioPreset.square,
                                lockAspectRatio: true),
                            iosUiSettings: IOSUiSettings(
                              minimumAspectRatio: 1.0,
                            ));
                        if (croppedFile != null) {
                          // File f = File(res.path);
                          changeImage(croppedFile);
                        }
                      }
                    },
                    child: Opacity(
                      opacity: percent > 0.01 ? 0 : 1,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[700],
                            borderRadius: BorderRadius.circular(50)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          // Positioned(
          //     right: 0,
          //     left: 0,
          //     top: (180 * (1 - percent)).clamp(10, 180).toDouble(),
          //     child: Opacity(
          //       opacity: (1 * (1 - percent2)).clamp(0, 1).toDouble(),
          //       child: Text(
          //         "oswin",
          //         style: TextStyle(fontSize: 20),
          //         textAlign: TextAlign.center,
          //       ),
          //     ))
        ],
      ),
    );
  }

  @override
  double get maxExtent => 200;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
