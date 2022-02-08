import 'package:dio/dio.dart';
import 'package:customer_portal/utils/ApiHelper.dart';
import 'package:customer_portal/utils/Base.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:art_sweetalert/art_sweetalert.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool _isLoading = false;
  String email = "";

  final _key = GlobalKey<FormState>();

  _submit() {
    setState(() {
      _isLoading = true;
    });
    ApiHelper()
        .dio
        .post(Base.baseUrlWithoutApi + "password-reset",
            data: FormData.fromMap({"email": email}))
        .then((value) {
      //print(value.data);
      setState(() {
        _isLoading = false;
      });
      if (value.statusCode == 200) {
        //print(value.data);
        if (value.data == "passwords.sent") {
          ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
              title: "Password Reset",
              text: "Reset link has been sent to your email",
              confirmButtonColor: Colors.grey,
              dialogPadding: const EdgeInsets.all(10),
            ),
          );
        }

        if (value.data == "passwords.user") {
          ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
              title: "No user associated with this email",
              text: "Register a new account",
              confirmButtonColor: Colors.grey,
              dialogPadding: EdgeInsets.all(10),
            ),
          );
        }

        if (value.data == "passwords.throttled") {
          ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                title: "Try after sometime",
                text: "Your password reset limit excided",
                confirmButtonColor: Colors.grey,
                dialogPadding: EdgeInsets.all(10),
              ));
        }

        return;
      }

      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            title: "Something went wrong",
            text: "",
            confirmButtonColor: Colors.grey,
            dialogPadding: EdgeInsets.all(10),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      opacity: 0.3,
      color: Colors.black,
      progressIndicator: CircularProgressIndicator(
        backgroundColor: Colors.blue,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 30,
              ),
              Center(
                child: Image.network(
                  "https://img1.wsimg.com/isteam/ip/26716100-deb6-4b52-954e-0b81071eaad9/Logo-0002.png/:/rs=h:120/ll",
                  height: 80,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                "Password reset",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Form(
                  key: _key,
                  child: TextFormField(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter a email";
                      }

                      return null;
                    },
                    onSaved: (val) {
                      email = val!;
                    },
                    decoration: InputDecoration(labelText: "Email..."),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (!_key.currentState!.validate()) return;
                    _key.currentState!.save();
                    _submit();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text("Reset Password"),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
