import 'dart:convert';

import 'package:deteksirokok/pages/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:deteksirokok/common/theme_helper.dart';

import 'forgot_password_verification_page.dart';
import 'login_page.dart';
import 'widgets/header_widget.dart';
import 'package:http/http.dart' as https;

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _name2Controller = TextEditingController();

  Future<void> _ubahData() async {
    final String basicAuth = _codeController.text;
    final String current = _nameController.text;
    final String newpw = _name2Controller.text;

    final response = await https.put(
      Uri.parse('http://192.168.193.223:5000/editpassword'),
      headers: {
        'Authorization': 'bearer $basicAuth',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'current_password': current,
        'new_password': newpw,
      }),
    );
    print(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Update User Success'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
              ),
            ],
          );
        },
      );
      // TODO: Handle successful update and navigate to another page
    } else {
      final Map<String, dynamic> errorData = json.decode(response.body);
      final String errorMessage = errorData['message'];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
      // TODO: Display error message
    }
  }

  Future<void> _showPopup() async {
    final TextEditingController popupController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Your Code'),
          content: TextField(
            controller: popupController,
            decoration: InputDecoration(
              labelText: 'Your Code',
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Assign the value to the main code controller
                _codeController.text = popupController.text;
              },
            ),
          ],
        );
      },
    );
  }

  bool passVisible = false;
  bool passVisible1 = false;
  @override
  void initState() {
    super.initState();
    passVisible = true;
    passVisible1 = true;
  }

  @override
  Widget build(BuildContext context) {
    double _headerHeight = 300;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: _headerHeight,
                child:
                    HeaderWidget(_headerHeight, true, Icons.password_rounded),
              ),
              SafeArea(
                child: Container(
                  margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ubah Password',
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                              // textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Enter the email address associated with your account.',
                              style: TextStyle(
                                  // fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                              // textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // Text(
                            //   'We will email you a verification code to check your authenticity.',
                            //   style: TextStyle(
                            //     color: Colors.black38,
                            //     // fontSize: 20,
                            //   ),
                            //   // textAlign: TextAlign.center,
                            // ),

                            ElevatedButton(
                              onPressed: _showPopup,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.purple,
                                backgroundColor: Colors.purple[900],
                                padding:
                                    const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                // ElevatedButton.styleFrom(
                                //   foregroundColor: Colors.white,
                                //   backgroundColor: Colors.green,
                                //   minimumSize: Size(400, 50),
                                //   padding: EdgeInsets.all(10),
                                //   textStyle: TextStyle(fontSize: 18),
                              ),
                              child: Text(
                                "Enter Code".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Form(
                        // key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      passVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        passVisible = !passVisible;
                                      });
                                    },
                                  ),
                                  labelText: 'Password Lama',
                                  border: OutlineInputBorder(),
                                ),
                                // validator: (val) {
                                //   if (val!.isEmpty) {
                                //     return "Email can't be empty";
                                //   } else if (!RegExp(
                                //           r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                //       .hasMatch(val)) {
                                //     return "Enter a valid email address";
                                //   }
                                //   return null;
                                // },
                                obscureText: passVisible,
                              ),
                              decoration:
                                  ThemeHelper().inputBoxDecorationShaddow(),
                            ),
                            SizedBox(height: 40.0),
                            Container(
                              child: TextFormField(
                                controller: _name2Controller,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      passVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        passVisible = !passVisible;
                                      });
                                    },
                                  ),
                                  labelText: 'Password Baru',
                                  border: OutlineInputBorder(),
                                ),
                                // validator: (val) {
                                //   if (val!.isEmpty) {
                                //     return "Email can't be empty";
                                //   } else if (!RegExp(
                                //           r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                //       .hasMatch(val)) {
                                //     return "Enter a valid email address";
                                //   }
                                //   return null;
                                // },
                                obscureText: passVisible,
                              ),
                              decoration:
                                  ThemeHelper().inputBoxDecorationShaddow(),
                            ),
                            SizedBox(height: 40.0),
                            Container(
                              decoration:
                                  ThemeHelper().buttonBoxDecoration(context),
                              child: ElevatedButton(
                                style: ThemeHelper().buttonStyle(),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text(
                                    "Ubah Password".toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onPressed: _ubahData,
                                // () {
                                //   if (_formKey.currentState!.validate()) {
                                //     Navigator.pushReplacement(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) =>
                                //               ForgotPasswordVerificationPage()),
                                //     );
                                //   }
                                // },
                              ),
                            ),
                            SizedBox(height: 30.0),
                            // Text.rich(
                            //   TextSpan(
                            //     children: [
                            //       TextSpan(text: "Remember your password? "),
                            //       TextSpan(
                            //         text: 'Login',
                            //         recognizer: TapGestureRecognizer()
                            //           ..onTap = () {
                            //             Navigator.push(
                            //               context,
                            //               MaterialPageRoute(
                            //                   builder: (context) =>
                            //                       LoginPage()),
                            //             );
                            //           },
                            //         style:
                            //             TextStyle(fontWeight: FontWeight.bold),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
