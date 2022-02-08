import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:customer_portal/Models/Property.dart';
import 'package:customer_portal/Models/RequestCategory.dart';
import 'package:customer_portal/components/customLoader.dart';
import 'package:customer_portal/utils/ApiHelper.dart';
import 'package:customer_portal/utils/Base.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:art_sweetalert/art_sweetalert.dart';

class CreateRequestPage extends StatefulWidget {
  @override
  _CreateRequestPageState createState() => _CreateRequestPageState();
}

class _CreateRequestPageState extends State<CreateRequestPage> {
  List<Property> _properties = [];
  List<RequestCategory> _categories = [];
  bool isLoading = false;
  String _property = "";
  String _description = "";
  String _categoryID = "";
  final _form1 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _getProperties();
    _getCategories();
  }

  _getProperties() async {
    var _pref = await SharedPreferences.getInstance();
    String? _token = _pref.getString("token");
    //print(_token);

    setState(() {
      // isLoading = true;
    });

    ApiHelper()
        .dio
        .get(
          "property",
        )
        .then((value) {
      setState(() {
        isLoading = false;
      });
      value.data['data'].forEach((property) {
        Property pro = Property.fromJson(property);
        setState(() {
          _properties.add(pro);
        });
      });
    });
  }

  _getCategories() async {
    var _pref = await SharedPreferences.getInstance();
    String? _token = _pref.getString("token");
    //print(_token);

    setState(() {
      // isLoading = true;
    });

    ApiHelper().dio.get("request/categories").then((value) {
      setState(() {
        isLoading = false;
      });
      // value.data.forEach((property) {
      //   Property pro = Property.fromJson(property);
      //   setState(() {
      //     _properties.add(pro);
      //   });
      // });

      setState(() {
        _categories = requestCategoryFromJson(jsonEncode(value.data));
      });
    });
  }

  submitRequest() async {
    if (!_form1.currentState!.validate()) {
      return;
    }
    var _pref = await SharedPreferences.getInstance();
    String? _token = _pref.getString("token");
    //print(_token);

    setState(() {
      isLoading = true;
    });

    _form1.currentState!.save();
    ApiHelper()
        .dio
        .post(
          "request",
          data: FormData.fromMap({
            "property_id": _property,
            "discription": _description,
            "request_category_id": _categoryID,
          }),
        )
        .then((value) {
      setState(() {
        isLoading = false;
      });
      //print(value.statusCode);
      if (value.statusCode == 201) {
        ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            title: "Request Submitted",
            confirmButtonColor: Colors.grey,
            // titleStyle: TextStyle(fontSize: 16),
            type: ArtSweetAlertType.success,
            onConfirm: (a) {
              Navigator.pop(context);
              return;
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      opacity: 0.3,
      color: Colors.black,
      progressIndicator: CustomLoader(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text("New Request"),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _form1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // SelectFormField(
                  //   type: SelectFormFieldType.dropdown,
                  //   onSaved: (val) {
                  //     _property = val;
                  //   },
                  //   validator: (val) {
                  //     if (val.isEmpty) {
                  //       return "Field can't be empty";
                  //     }

                  //     return null;
                  //   },
                  //   items: _properties
                  //       .map((e) =>
                  //           {"value": e.id.toString(), "label": e.ownerName})
                  //       .toList(),
                  //   labelText: "My Properties",
                  // ),
                  DropdownButtonFormField(
                    // hintText: "Select a property",
                    // filled: false,
                    value: _property,
                    // titleText: "My Properties",
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
                        _property = s!;
                      });
                    },
                    onSaved: (String? s) {
                      setState(() {
                        _property = s!;
                      });
                    },

                    items: _properties
                        .map((e) => DropdownMenuItem(
                            child: Text(e.propertyName),
                            value: e.id.toString()))
                        .toList(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField(
                    // hintText: "Select a category",
                    // filled: false,
                    value: _categoryID,
                    // titleText: "Category",
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
                        _categoryID = s!;
                      });
                    },
                    onSaved: (String? s) {
                      setState(() {
                        _categoryID = s!;
                      });
                    },
                    items: _categories
                        .map((e) => DropdownMenuItem(
                            child: Text(e.requestCategory),
                            value: e.id.toString()))
                        .toList(),
                  ),
                  TextFormField(
                    onSaved: (s) {
                      _description = s!;
                    },
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "Field can't be empty";
                      }
                      return null;
                    },
                    minLines: 2,
                    maxLines: 5,
                    decoration: InputDecoration(labelText: "Request"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      submitRequest();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text("Submit Request"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
