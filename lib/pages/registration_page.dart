
import 'dart:convert';

import 'package:deteksirokok/pages/forgot_password_verification_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:deteksirokok/common/theme_helper.dart';
import 'package:deteksirokok/pages/widgets/header_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as https;

import 'profile_page.dart';

class RegistrationPage extends  StatefulWidget{
  @override
  State<StatefulWidget> createState() {
     return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage>{

  // final _formKey = GlobalKey<FormState>();
  // bool checkedValue = false;
  // bool checkboxValue = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();

  Future<void> _register() async {
    final String username = _usernameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;
    final String repassword = _password2Controller.text;

    final response = await https.post(
      Uri.parse('http://192.168.193.223:5000/register'),
      body: jsonEncode({
        'nama': username,
        'email': email,
        'password': password,
        'confirm_password': repassword
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {      
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ForgotPasswordVerificationPage()),
      );
      // TODO: Handle successful login and navigate to another page
    } else {
      final Map<String, dynamic> errorData = json.decode(response.body);
      final String errorMessage = errorData['message'];
      // TODO: Display login error message
    }
  }

  bool passVisible = false;
  @override
  void initState() {
    super.initState();
    passVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
                  "assets/img/image1.png",
                  height: 200,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(25, 20, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    // key: _formKey,
                    child: Column(
                      children: [                    
                        SizedBox(height: 30,),
                        Container(
                          child: TextFormField(
                            controller: _usernameController,
                            decoration: ThemeHelper().textInputDecoration('First Name', 'Enter your first name'),
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),                        
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: _emailController,
                            decoration: ThemeHelper().textInputDecoration("E-mail address", "Masukkan Email Anda"),
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if(!(val!.isEmpty) && !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(val)){
                                return "Enter a valid email address";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration(
                                "Password*", "Masukkan Password Anda"),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Masukkan Password Anda";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: _password2Controller,
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration(
                                "Re-Password*", "Masukkan Password Anda"),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Masukkan Password Anda";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),                        
                          // validator: (value) {
                          //   if (!checkboxValue) {
                          //     return 'Maaf anda harus menyetujui ketentuan yang ada';
                          //   } else {
                          //     return null;
                          //   }
                          // },                        
                        SizedBox(height: 20.0),
                        Container(
                          decoration: ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "Daftar".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: _register, 
                            // () {
                            //   if (_formKey.currentState!.validate()) {
                            //     Navigator.of(context).pushAndRemoveUntil(
                            //         MaterialPageRoute(
                            //             builder: (context) => ForgotPasswordVerificationPage()
                            //         ),
                            //             (Route<dynamic> route) => false
                            //     );
                            //   }
                            // },
                          ),
                        ),                        
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}