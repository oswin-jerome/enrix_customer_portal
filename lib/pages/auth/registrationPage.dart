import 'dart:convert';
import 'dart:io';

import 'package:cool_stepper/cool_stepper.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dio/dio.dart';
import 'package:customer_portal/components/customLoader.dart';
import 'package:customer_portal/pages/auth/loginPage.dart';
import 'package:customer_portal/utils/ApiHelper.dart';
import 'package:customer_portal/utils/Base.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:time_range/time_range.dart' as tr;
import 'package:time_range_picker/time_range_picker.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressFormKey = GlobalKey<FormState>();
  final _contactFormKey = GlobalKey<FormState>();

  String _email = "";
  String _password = "";
  String _confirmPassword = "";
  String _name = "";
  String _dateofbirth = "";
  String _phone = "";

  // Address Details
  String _currentAddress = "";
  String _state = "";
  String _city = "";
  String _zipcode = "";

  // Contact Details
  TimeRange? _preferedTimeRange = null;
  String _preferedTime = "";
  String _modeOfContact = "Whatsapp";
  String _idproof = "";
  String _timeZone = "India Standard Time";
  late TextEditingController _controller;
  bool _isLoading = false;
  List<DropdownMenuItem<String>> _timeZones = [];
  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController(text: "");
    // tz.initializeTimeZones();

    // print(object)
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

  _register() async {
    setState(() {
      _isLoading = true;
    });
    //print(_name + " sd " + _city);

    var _data = FormData.fromMap({
      "name": _name,
      "email": _email,
      "dob": _dateofbirth,
      "mobile": _phone,
      "phone": _phone,
      "current_address": _currentAddress,
      "city": _city,
      "state": _state,
      "zipcode": _zipcode,
      "time_of_contact": _preferedTime,
      "mode_of_contact": _modeOfContact,
      "password": _password,
      "time_zone": _timeZone,
      "id_proof": await MultipartFile.fromFile(_img!.path)
    });

    ApiHelper().dio.post(Base.baseUrl + "register", data: _data).then((value) {
      setState(() {
        _isLoading = false;
      });
      if (value.statusCode == 200) {
        Future.delayed(Duration(seconds: 3)).then((value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (builder) => LoginPage(),
            ),
          );
        });
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
              title: "Registered Successfully",
              text:
                  "Your Account will be verified & activated in the next 48 hrs.",
              // subtitleTextAlign: TextAlign.center,
              dialogAlignment: Alignment.center,
              confirmButtonColor: Colors.grey,
              // titleStyle: TextStyle(fontSize: 16),

              // style: SweetAlertV2Style.success,
              onConfirm: (a) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (builder) => LoginPage(),
                  ),
                );
                return;
              },
            ));
      }
    }).catchError((e) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  selectIdProof(ImageSource imgsrc) async {
    if (imgsrc == ImageSource.gallery) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'doc'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        setState(() {
          _img = file;
        });
      } else {
        // User canceled the picker
      }
    } else {
      final pickedFile = await picker.getImage(source: imgsrc);
      if (pickedFile != null) {
        //print(pickedFile.path);
        setState(() {
          _img = File(pickedFile.path);
        });
      }
    }
  }

  final picker = ImagePicker();
  File? _img;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   child: Text("test"),
      //   onPressed: () {
      //     print("Localsss");
      //     print(tz.timeZoneDatabase.locations);
      //     // foreach(String ti : tz.timeZoneDatabase.locations.values) {

      //     // }
      //     for (var item in tz.timeZoneDatabase.locations.keys) {
      //       print(item.toString());
      //     }
      //   },
      // ),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: _isLoading,
          opacity: 0.3,
          color: Colors.black,
          progressIndicator: CustomLoader(),
          child: CoolStepper(
              config: CoolStepperConfig(
                headerColor: Colors.grey,
                backText: "Prev",
                iconColor: Colors.grey,
                subtitleTextStyle: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 11,
                ),
              ),
              showErrorSnackbar: true,
              steps: [
                CoolStep(
                  title: "Personal Details",
                  subtitle: "All fields are mandatory",
                  content: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: _email,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Field can't be empty";
                            }

                            if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val)) {
                              return "Enter a valid email address";
                            }

                            return null;
                          },
                          onSaved: (val) {
                            _email = val!;
                          },
                          decoration: InputDecoration(labelText: "Email"),
                        ),
                        TextFormField(
                          initialValue: _password,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Field can't be empty";
                            }

                            if (val.length < 7) {
                              return "Minimum 8 characters required";
                            }

                            return null;
                          },
                          onChanged: (s) {
                            _password = s;
                          },
                          onSaved: (val) {
                            _password = val!;
                          },
                          obscureText: true,
                          decoration: InputDecoration(labelText: "Password"),
                        ),
                        TextFormField(
                          initialValue: _confirmPassword,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Field can't be empty";
                            }
                            if (val.length < 7) {
                              return "Minimum 8 characters required";
                            }

                            if (val != _password) {
                              return "Confirm password didn't match";
                            }

                            return null;
                          },
                          onSaved: (val) {
                            _password = val!;
                          },
                          obscureText: true,
                          decoration:
                              InputDecoration(labelText: "Confirm Password"),
                        ),
                        TextFormField(
                          initialValue: _name,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Field can't be empty";
                            }

                            return null;
                          },
                          onSaved: (val) {
                            _name = val!;
                          },
                          decoration: InputDecoration(labelText: "Client Name"),
                        ),
                        DateTimePicker(
                          type: DateTimePickerType.date,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                          dateLabelText: 'Date of Birth',
                          onSaved: (s) {
                            //print(s);
                            _dateofbirth = s!;
                          },
                          onChanged: (s) {
                            //print(s);
                          },
                          validator: (s) {
                            if (s!.isEmpty) {
                              return "required";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          initialValue: _phone,
                          keyboardType: TextInputType.phone,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Field can't be empty";
                            }
                            if (!RegExp(r"^[0-9]*$").hasMatch(val)) {
                              return "Enter a valid phone number";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            _phone = val!;
                          },
                          decoration: InputDecoration(labelText: "Phone"),
                        )
                      ],
                    ),
                  ),
                  validation: () {
                    if (!_formKey.currentState!.validate()) {
                      return "Kindly fill all fields";
                    } else {
                      setState(() {
                        _formKey.currentState!.save();
                      });
                      //print(_name);
                    }
                    return null;
                  },
                ),
                CoolStep(
                  title: "Address Details",
                  content: Form(
                    key: _addressFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: _currentAddress,
                          minLines: 1,
                          maxLines: 5,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Field can't be empty";
                            }

                            return null;
                          },
                          onSaved: (val) {
                            _currentAddress = val!;
                          },
                          decoration:
                              InputDecoration(labelText: "Current Address"),
                        ),
                        TextFormField(
                          initialValue: _city,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Field can't be empty";
                            }

                            return null;
                          },
                          onSaved: (val) {
                            _city = val!;
                          },
                          decoration: InputDecoration(labelText: "City"),
                        ),
                        TextFormField(
                          initialValue: _state,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Field can't be empty";
                            }

                            return null;
                          },
                          onSaved: (val) {
                            _state = val!;
                          },
                          decoration: InputDecoration(labelText: "State"),
                        ),
                        TextFormField(
                          initialValue: _zipcode,
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Field can't be empty";
                            }

                            // if (!RegExp(r"^[0-9]*$").hasMatch(val)) {
                            //   return "Enter a valid Zip code";
                            // }

                            return null;
                          },
                          onSaved: (val) {
                            _zipcode = val!;
                          },
                          decoration: InputDecoration(labelText: "Zip Code"),
                        )
                      ],
                    ),
                  ),
                  subtitle: "All fields are mandatory",
                  validation: () {
                    if (!_addressFormKey.currentState!.validate()) {
                      return "Kindly fill all fields";
                    } else {
                      setState(() {
                        _addressFormKey.currentState!.save();
                      });
                      //print(_name);
                    }
                    return null;
                  },
                ),
                CoolStep(
                  title: "Contact Details",
                  content: Form(
                    key: _contactFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _controller,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Field can't be empty";
                            }

                            return null;
                          },
                          onSaved: (val) {
                            _preferedTime = val!;
                          },
                          decoration: InputDecoration(
                              labelText: "Prefered time to contact"),
                          onTap: () async {
                            showDialog(
                                context: context,
                                builder: (cs) {
                                  // _isTimeRangeOpen = true;
                                  return Center(
                                    child: Container(
                                      // color: Colors.red,
                                      width: MediaQuery.of(context).size.width,
                                      child: Dialog(
                                        insetPadding: EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Card(
                                              elevation: 0,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 20),
                                                child: tr.TimeRange(
                                                  fromTitle: Text(
                                                    'From',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.grey),
                                                  ),
                                                  toTitle: Text(
                                                    'To',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.grey),
                                                  ),
                                                  titlePadding: 10,
                                                  initialRange:
                                                      tr.TimeRangeResult(
                                                          TimeOfDay(
                                                              hour: 9,
                                                              minute: 00),
                                                          TimeOfDay(
                                                              hour: 18,
                                                              minute: 0)),
                                                  textStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.black87,
                                                      fontSize: 14),
                                                  activeTextStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                  borderColor: Colors.grey,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  activeBackgroundColor:
                                                      Colors.grey,
                                                  firstTime: TimeOfDay(
                                                      hour: 6, minute: 30),
                                                  lastTime: TimeOfDay(
                                                      hour: 22, minute: 00),
                                                  timeStep: 30,
                                                  timeBlock: 30,
                                                  onRangeCompleted: (range) {
                                                    String newValue = range!
                                                            .start
                                                            .format(context) +
                                                        " - " +
                                                        range.end
                                                            .format(context);
                                                    _controller.text = newValue;

                                                    // Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                            ),
                                            Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    right: 15,
                                                  ),
                                                  child: TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        // _isTimeRangeOpen = false;
                                                      },
                                                      child: Text("Close")),
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        DropdownButtonFormField(
                          // hintText: "Select your time zone",
                          // filled: false,
                          value: _timeZone,
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
                              _timeZone = s!;
                            });
                          },
                          onSaved: (String? s) {
                            setState(() {
                              _timeZone = s!;
                            });
                          },
                          items: _timeZones,
                          // textField: 'text',
                          // valueField: 'value',
                        ),
                        SelectFormField(
                          initialValue: _modeOfContact,
                          type: SelectFormFieldType.dropdown,
                          onSaved: (val) {
                            _modeOfContact = val!;
                          },
                          items: [
                            {"value": "Whatsapp", "label": "Whatsapp"},
                            {"value": "Phone", "label": "Phone"},
                          ],
                          labelText: "Prefered Contact mode",
                        ),
                        TextFormField(
                          initialValue: "",
                          validator: (val) {
                            // if (val!.isEmpty) {
                            //   return "Field can't be empty";
                            // }

                            return null;
                          },
                          onSaved: (val) {
                            _idproof = val!;
                          },
                          decoration:
                              InputDecoration(labelText: "Alternate number"),
                        ),
                        TextFormField(
                          initialValue: _idproof,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Field can't be empty";
                            }

                            return null;
                          },
                          onSaved: (val) {
                            _idproof = val!;
                          },
                          decoration:
                              InputDecoration(labelText: "ID Proof Type"),
                        ),
                        _img != null
                            ? Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Column(
                                  children: [
                                    Text(
                                      _img!.path.split("/").last,
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _img = null;
                                          });
                                        },
                                        child: Text("Remove attachment"))
                                  ],
                                ),
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        selectIdProof(ImageSource.gallery);
                                      },
                                      child: Container(
                                        height: 50,
                                        margin: EdgeInsets.only(top: 15),
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: Center(
                                          child: Text("Attach file"),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        selectIdProof(ImageSource.camera);
                                      },
                                      child: Container(
                                        height: 50,
                                        margin: EdgeInsets.only(top: 15),
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: Center(
                                          child: Text("Attach from camera"),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                      ],
                    ),
                  ),
                  subtitle: "All fields are mandatory",
                  validation: () {
                    if (!_contactFormKey.currentState!.validate()) {
                      return "Kindly fill all fields";
                    } else {
                      setState(() {
                        _contactFormKey.currentState!.save();
                      });
                      //print(_name);
                    }
                    return null;
                  },
                ),
              ],
              onCompleted: () {
                _register();
              }),
        ),
      ),
    );
  }
}
