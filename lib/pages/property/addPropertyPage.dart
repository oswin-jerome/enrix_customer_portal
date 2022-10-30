import 'dart:io';

import 'package:cool_stepper/cool_stepper.dart';
import 'package:dio/dio.dart';
import 'package:customer_portal/components/customLoader.dart';
import 'package:customer_portal/pages/extras/SignPage.dart';
import 'package:customer_portal/utils/ApiHelper.dart';
import 'package:customer_portal/utils/Base.dart';
import 'package:customer_portal/utils/GenerateAuthLetter.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AddPropertyPage extends StatefulWidget {
  @override
  _AddPropertyPageState createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<AddPropertyPage> {
  final _form1 = GlobalKey<FormState>();
  final _form2 = GlobalKey<FormState>();
  final _form3 = GlobalKey<FormState>();
  final _form4 = GlobalKey<FormState>();

  bool isLoading = false;

  String _propertyName = "";
  String _legalOwnerName = "";
  String _propertyType = "";
  int _totalUnits = 1;
  String _propertyAddress = "";
  String _propertyCity = "";
  String _propertyLandmark = "";
  String _yearOfConstruction = "";
  int _totalSquarFeet = 0;
  int _totalfloors = 0;
  String _facing = "";

  String _contactName = "";
  String _phone = "";
  String _email = "";
  String _contactAddress = "";
  String _contactCity = "";
  String _contactState = "";
  String _contactRelationship = "";
  String _contactId = "";

  String _rented_status = "";
  String _eb_number = "";
  String _tax_number = "";
  String _water_tax = "";
  String _survey_number = "";
  String _other_details = "";
  String _loan_status = "";

  File? auth_letter = null;
  FileSystemEntity? _signature = null;
  String _signaturePath = "";
  bool _is_confirm = false;
  setForTesting() {
    _propertyName = "House";
    _legalOwnerName = "Oswin Jerome";
    _propertyType = "flat";
    _totalUnits = 1;
    _propertyAddress = "My Address";
    _propertyCity = "Nagercoil";
    _propertyLandmark = "Gate";
    _yearOfConstruction = "2021";
    _totalSquarFeet = 1800;
    _totalfloors = 1;
    _facing = "North";

    _contactName = "Jerome";
    _phone = "83444441";
    _email = "oswin@gmail.com";
    _contactAddress = "address of contact";
    _contactCity = "Nagercoil";
    _contactState = "TN";
    _contactRelationship = "Bro";
    _contactId = "1928";

    _rented_status = "0";
    _eb_number = "123";
    _tax_number = "123";
    _water_tax = "124";
    _survey_number = "132";
    _other_details = "2323";
    _loan_status = "0";
  }

  initState() {
    super.initState();
    // setForTesting();
  }

  _submitForm() async {
    var _pref = await SharedPreferences.getInstance();
    String? _token = _pref.getString("token");
    //print(_token);
    setState(() {
      isLoading = true;
    });
    FormData _data = new FormData.fromMap({
      "property_name": _propertyName,
      "owner_name": _legalOwnerName,
      "property_type": _propertyType,
      "no_of_units": _totalUnits,
      "property_address": _propertyAddress,
      "pcity": _propertyCity,
      "plandmark": _propertyLandmark,
      "year_of_construction": _yearOfConstruction,
      "total_sq_ft": _totalSquarFeet,
      "no_of_floors": _totalfloors,
      "facing": _facing,
      "contact_pname": _contactName,
      "mobile_no": _phone,
      "email_id": _email,
      "paddress": _contactAddress,
      "contact_pcity": _contactCity,
      "pstate": _contactState,
      "pidproof": "",
      "relationship": _contactRelationship,
      "currently_rented": _rented_status,
      "eb_consumer_no": _eb_number,
      "property_tax_no": _tax_number,
      "water_tax_no": _water_tax,
      "survey_no": _survey_number,
      "pdetails": _other_details,
      "bankloan": _loan_status,
      "authorization_letter": await MultipartFile.fromFile(auth_letter!.path)
    });

    ApiHelper()
        .dio
        .post(
          "property",
          data: _data,
        )
        .then((value) {
      setState(() {
        isLoading = false;
      });
      if (value.statusCode == 200) {
        Navigator.pop(context);
      }
    });
  }

  loadFile() async {
    Directory tempDirectory = await getApplicationDocumentsDirectory();

    File file = new File(tempDirectory.path + "/authletter.pdf");
    if (file.existsSync()) {
      setState(() {
        auth_letter = file;
      });
    }

    FileSystemEntity sign;
    Directory signatures = new Directory(tempDirectory.path + "/signatires");
    sign = signatures.listSync().elementAt(0);
    if (file.existsSync()) {
      setState(() {
        _signature = sign;
        _signaturePath = sign.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          opacity: 0.3,
          color: Colors.black,
          progressIndicator: CustomLoader(),
          child: CoolStepper(
            config: CoolStepperConfig(iconColor: Colors.transparent),
            showErrorSnackbar: true,
            onCompleted: () {
              _submitForm();
            },
            steps: [
              CoolStep(
                title: "Property Intake Form",
                subtitle: "Property Details 1/2",
                content: Form(
                  key: _form1,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _propertyName,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Field can't be empty";
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _propertyName = val!;
                        },
                        decoration: InputDecoration(labelText: "Property Name"),
                      ),
                      TextFormField(
                        initialValue: _legalOwnerName,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Field can't be empty";
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _legalOwnerName = val!;
                        },
                        decoration:
                            InputDecoration(labelText: "Legal Owner Name"),
                      ),
                      SelectFormField(
                        initialValue: _propertyType,
                        type: SelectFormFieldType.dropdown,
                        onSaved: (val) {
                          _propertyType = val!;
                        },
                        validator: (s) {
                          if (s!.isEmpty) {
                            return "Select a property type";
                          }
                          return null;
                        },
                        items: [
                          {"value": "flat", "label": "Flat"},
                          {
                            "value": "independent house",
                            "label": "Independent House"
                          },
                          {"value": "commercial", "label": "Commercial"},
                          {"value": "empty plot", "label": "Plot"},
                        ],
                        labelText: "Property Type",
                      ),
                      TextFormField(
                        initialValue: _totalUnits.toString(),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Field can't be empty";
                          }
                          if (!RegExp(r"^[0-9]*$").hasMatch(val)) {
                            return "Enter a number";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        onSaved: (val) {
                          _totalUnits = int.parse(val!);
                        },
                        decoration:
                            InputDecoration(labelText: "Total Number of Units"),
                      ),
                      TextFormField(
                        initialValue: _propertyAddress,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Field can't be empty";
                          }
                          return null;
                        },
                        maxLines: 5,
                        minLines: 1,
                        onSaved: (val) {
                          _propertyAddress = val!;
                        },
                        decoration:
                            InputDecoration(labelText: "Property Address"),
                      ),
                      TextFormField(
                        initialValue: _propertyCity,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Field can't be empty";
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _propertyCity = val!;
                        },
                        decoration: InputDecoration(labelText: "City"),
                      ),
                      TextFormField(
                        initialValue: _propertyLandmark,
                        validator: (val) {
                          // if (val!.isEmpty) {
                          //   return "Field can't be empty";
                          // }
                          return null;
                        },
                        onSaved: (val) {
                          _propertyLandmark = val!;
                        },
                        decoration: InputDecoration(labelText: "Landmark"),
                      ),
                    ],
                  ),
                ),
                validation: () {
                  if (!_form1.currentState!.validate()) {
                    return "Fill form correctly";
                  } else {
                    setState(() {
                      _form1.currentState!.save();
                    });
                  }
                  return null;
                },
              ),
              CoolStep(
                title: "Property Intake Form",
                subtitle: "Property Details 2/2",
                content: Form(
                  key: _form2,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _yearOfConstruction,
                        validator: (val) {
                          // if (val!.isEmpty) {
                          //   return "Field can't be empty";
                          // }
                          return null;
                        },
                        keyboardType: TextInputType.datetime,
                        onSaved: (val) {
                          _yearOfConstruction = val!;
                        },
                        decoration:
                            InputDecoration(labelText: "Year of Construction"),
                      ),
                      TextFormField(
                        initialValue: _totalSquarFeet.toString(),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Field can't be empty";
                          }
                          if (!RegExp(r"^[0-9]*$").hasMatch(val)) {
                            return "Enter a number";
                          }

                          if (val == "0") {
                            return "Should be greater than 0";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        onSaved: (val) {
                          _totalSquarFeet = int.parse(val!);
                        },
                        decoration: InputDecoration(labelText: "Total Sq. ft "),
                      ),
                      TextFormField(
                        initialValue: _totalfloors.toString(),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Field can't be empty";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        onSaved: (val) {
                          _totalfloors = int.parse(val!);
                        },
                        decoration:
                            InputDecoration(labelText: "No. of floor(s)"),
                      ),
                      TextFormField(
                        initialValue: _facing,
                        validator: (val) {
                          // if (val!.isEmpty) {
                          //   return "Field can't be empty";
                          // }
                          return null;
                        },
                        onSaved: (val) {
                          _facing = val!;
                        },
                        decoration: InputDecoration(labelText: "Facing"),
                      ),
                    ],
                  ),
                ),
                validation: () {
                  if (!_form2.currentState!.validate()) {
                    return "Fill form correctly";
                  } else {
                    setState(() {
                      _form2.currentState!.save();
                    });
                  }
                  return null;
                },
              ),
              CoolStep(
                title: "Property Intake Form",
                subtitle: "Contact person details",
                validation: () {
                  if (!_form3.currentState!.validate()) {
                    return "Fill form correctly";
                  } else {
                    setState(() {
                      _form3.currentState!.save();
                    });
                  }
                  return null;
                },
                content: Form(
                  key: _form3,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _contactName,
                        validator: (val) {
                          // if (val!.isEmpty) {
                          //   return "Field can't be empty";
                          // }
                          return null;
                        },
                        onSaved: (val) {
                          _contactName = (val!);
                        },
                        decoration: InputDecoration(labelText: "Name"),
                      ),
                      TextFormField(
                        initialValue: _phone,
                        keyboardType: TextInputType.phone,
                        validator: (val) {
                          // if (val!.isEmpty) {
                          //   return "Field can't be empty";
                          // }
                          return null;
                        },
                        onSaved: (val) {
                          _phone = (val!);
                        },
                        decoration: InputDecoration(labelText: "Mobile"),
                      ),
                      TextFormField(
                        initialValue: _email,
                        validator: (val) {
                          // if (val!.isEmpty) {
                          //   return "Field can't be empty";
                          // }
                          return null;
                        },
                        onSaved: (val) {
                          _email = (val)!;
                        },
                        decoration: InputDecoration(labelText: "Email"),
                      ),
                      TextFormField(
                        initialValue: _contactAddress,
                        maxLines: 5,
                        minLines: 1,
                        validator: (val) {
                          // if (val!.isEmpty) {
                          //   return "Field can't be empty";
                          // }
                          return null;
                        },
                        onSaved: (val) {
                          _contactAddress = (val)!;
                        },
                        decoration: InputDecoration(labelText: "Address"),
                      ),
                      TextFormField(
                        initialValue: _contactCity,
                        validator: (val) {
                          // if (val!.isEmpty) {
                          //   return "Field can't be empty";
                          // }
                          return null;
                        },
                        onSaved: (val) {
                          _contactCity = (val)!;
                        },
                        decoration: InputDecoration(labelText: "City"),
                      ),
                      TextFormField(
                        initialValue: _contactState,
                        validator: (val) {
                          // if (val!.isEmpty) {
                          //   return "Field can't be empty";
                          // }
                          return null;
                        },
                        onSaved: (val) {
                          _contactState = (val)!;
                        },
                        decoration: InputDecoration(labelText: "State"),
                      ),
                      TextFormField(
                        initialValue: _contactId,
                        validator: (val) {
                          // if (val!.isEmpty) {
                          //   return "Field can't be empty";
                          // }
                          return null;
                        },
                        onSaved: (val) {
                          _contactId = (val)!;
                        },
                        decoration: InputDecoration(labelText: "ID Proof"),
                      ),
                      TextFormField(
                        initialValue: _contactRelationship,
                        validator: (val) {
                          // if (val!.isEmpty) {
                          //   return "Field can't be empty";
                          // }
                          return null;
                        },
                        onSaved: (val) {
                          _contactRelationship = (val)!;
                        },
                        decoration: InputDecoration(
                          labelText: "Relationship",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CoolStep(
                title: "Property Intake Form",
                subtitle: "Additional Information",
                validation: () {
                  if (_signature == null) {
                    return "Enter your signature";
                  }
                  if (!_form4.currentState!.validate()) {
                    return "Fill form correctly";
                  } else {
                    setState(() {
                      _form4.currentState!.save();
                    });
                  }
                  return null;
                },
                content: Form(
                  key: _form4,
                  child: Column(
                    children: [
                      SelectFormField(
                        initialValue: _rented_status,
                        type: SelectFormFieldType.dropdown,
                        onSaved: (val) {
                          _rented_status = val!;
                        },
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Field can't be empty";
                          }

                          return null;
                        },
                        items: [
                          {"value": "1", "label": "Yes"},
                          {"value": "0", "label": "No"},
                        ],
                        labelText: "Currently rented",
                      ),
                      TextFormField(
                        initialValue: _eb_number,
                        validator: (val) {
                          // if (val!.isEmpty) {
                          //   return "Field can't be empty";
                          // }
                          return null;
                        },
                        onSaved: (val) {
                          _eb_number = (val)!;
                        },
                        decoration:
                            InputDecoration(labelText: "EB Consumer No."),
                      ),
                      TextFormField(
                        initialValue: _tax_number,
                        validator: (val) {
                          // if (val!.isEmpty) {
                          //   return "Field can't be empty";
                          // }
                          return null;
                        },
                        onSaved: (val) {
                          _tax_number = (val!);
                        },
                        decoration:
                            InputDecoration(labelText: "Property Tax No. "),
                      ),
                      TextFormField(
                        initialValue: _water_tax,
                        validator: (val) {
                          // if (val!.isEmpty) {
                          //   return "Field can't be empty";
                          // }
                          return null;
                        },
                        onSaved: (val) {
                          _water_tax = (val!);
                        },
                        decoration:
                            InputDecoration(labelText: "Water Tax No. "),
                      ),
                      TextFormField(
                        initialValue: _survey_number,
                        validator: (val) {
                          // if (val!.isEmpty) {
                          //   return "Field can't be empty";
                          // }
                          return null;
                        },
                        onSaved: (val) {
                          _survey_number = (val)!;
                        },
                        decoration: InputDecoration(labelText: "Survey No. "),
                      ),
                      SelectFormField(
                        initialValue: _loan_status,
                        type: SelectFormFieldType.dropdown,
                        onSaved: (val) {
                          _loan_status = val!;
                        },
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Field can't be empty";
                          }

                          return null;
                        },
                        items: [
                          {"value": "1", "label": "Yes"},
                          {"value": "0", "label": "No"},
                        ],
                        labelText: "Is the Property under Bank Loan ?",
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      _signature == null
                          ? ElevatedButton(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (s) => SignPage(),
                                    maintainState: true,
                                    fullscreenDialog: true,
                                  ),
                                );
                                await GenerateAuthLetter().makeAndSave(
                                  customerName: _legalOwnerName,
                                  address:
                                      _propertyAddress + ", " + _propertyCity,
                                );
                                await loadFile();
                                setState(() {});
                              },
                              child: Text("Add Signature"),
                            )
                          : GestureDetector(
                              onDoubleTap: () async {
                                _signature = null;
                                _signaturePath = "";
                                setState(() {});
                                setState(() {});
                              },
                              child: Column(
                                children: [
                                  Image.file(
                                    new File(_signaturePath),
                                    gaplessPlayback: false,
                                  ),
                                  Text(
                                    "Double tap to reset",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  )
                                ],
                              )),
                    ],
                  ),
                ),
              ),
              CoolStep(
                title: "Property Intake Form",
                subtitle: "Authorization letter",
                content: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.76,
                  child: auth_letter != null
                      ? SfPdfViewer.file(auth_letter!)
                      : Container(),
                ),
                validation: () {},
              ),
              CoolStep(
                title: "Property Intake Form",
                subtitle: "Confirmation",
                content: Container(
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      buildConfirmTile("Property Name", _propertyName),
                      buildConfirmTile("Property Type", _propertyType),
                      buildConfirmTile("Legal Owner Name", _legalOwnerName),
                      buildConfirmTile("Property Address", _propertyAddress),
                      buildConfirmTile("Property City", _propertyCity),
                      buildConfirmTile("Property landmark", _propertyLandmark),
                      buildConfirmTile("Total units", _totalUnits.toString()),
                      buildConfirmTile(
                          "Year of construction", _yearOfConstruction),
                      buildConfirmTile(
                          "Total Sq.ft", _totalSquarFeet.toString()),
                      buildConfirmTile("Total Floors", _totalfloors.toString()),
                      buildConfirmTile("Facing", _facing),
                      Divider(),
                      ListTile(
                        title: Text("Contact Person details:"),
                      ),
                      buildConfirmTile("Name", _contactName),
                      //  _contactName = "Jerome";
                      buildConfirmTile("Phone", _phone),
                      // _phone = "83444441";
                      buildConfirmTile("Email", _email),
                      // _email = "oswin@gmail.com";
                      buildConfirmTile("Address", _contactAddress),
                      // _contactAddress = "address of contact";
                      buildConfirmTile("City", _contactCity),
                      // _contactCity = "Nagercoil";
                      buildConfirmTile("State", _contactState),
                      // _contactState = "TN";
                      buildConfirmTile("Relations", _contactRelationship),
                      Divider(),
                      ListTile(
                        title: Text("Additional Information"),
                      ),
                      // _rented_status = "0";
                      buildConfirmTile(
                          "Rented?", _rented_status == "0" ? "No" : "Yes"),
                      // _eb_number = "123";
                      buildConfirmTile("EB Number", _eb_number),
                      // _tax_number = "123";
                      buildConfirmTile("Tax Number", _tax_number),
                      // _water_tax = "124";
                      buildConfirmTile("Water Tax Number", _water_tax),
                      // _survey_number = "132";
                      buildConfirmTile("Survey Number", _survey_number),
                      // _other_details = "2323";
                      // _loan_status = "0";
                      buildConfirmTile("Is Property Under Bank Loan?",
                          _loan_status == "0" ? "No" : "Yes"),

                      ListTile(
                        dense: true,
                        isThreeLine: true,
                        title: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            // color: Colors.red,
                            child: SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child: Checkbox(
                                value: _is_confirm,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                onChanged: (val) {
                                  setState(() {
                                    _is_confirm = val!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        subtitle: Text(
                            "I hereby declare that the above particulars of facts and information stated are correct to the best of my knowledge and belief."),
                      )
                    ],
                  ),
                ),
                validation: () {
                  if (!_is_confirm) {
                    return "Please confirm the information";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListTile buildConfirmTile(String label, String value) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      subtitle: Text(value),
    );
  }
}
