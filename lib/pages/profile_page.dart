import 'dart:convert';

import 'package:deteksirokok/pages/editdata.dart';
import 'package:deteksirokok/pages/visualisasi.dart';
import 'package:deteksirokok/pages/web_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:deteksirokok/pages/login_page.dart';
import 'package:deteksirokok/pages/splash_screen.dart';
import 'package:deteksirokok/pages/widgets/header_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/theme_helper.dart';
import 'forgot_password_page.dart';
import 'forgot_password_verification_page.dart';
import 'registration_page.dart';
import 'package:http/http.dart' as https;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _nama = '';
  String _email = '';
  TextEditingController _tokenController = TextEditingController();

  void _getUserDetail() async {
    final String token = _tokenController.text;

    final String endpoint = 'http://192.168.193.223:5000/user';

    final preferences = await SharedPreferences.getInstance();
    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await https.get(
      Uri.parse(endpoint),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        _nama = jsonData['nama'];
        _email = jsonData['email'];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User data fetched successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch user data. Please try again!')),
      );
    }
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  double _drawerIconSize = 24;
  double _drawerFontSize = 17;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile Page",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Theme.of(context).primaryColor,
                Theme.of(context).accentColor,
              ])),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt_rounded,
                    size: _drawerIconSize,
                    color: Theme.of(context).accentColor),
                title: Text(
                  'Realtime Deteksi',
                  style: TextStyle(
                      fontSize: _drawerFontSize,
                      color: Theme.of(context).accentColor),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WebviewPage()),
                  );
                },
              ),
              Divider(
                color: Theme.of(context).primaryColor,
                height: 1,
              ),
              ListTile(
                leading: Icon(Icons.data_array_rounded,
                    size: _drawerIconSize,
                    color: Theme.of(context).accentColor),
                title: Text(
                  'Visualisasi',
                  style: TextStyle(
                      fontSize: _drawerFontSize,
                      color: Theme.of(context).accentColor),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChartWidget()),
                  );
                },
              ),
              Divider(
                color: Theme.of(context).primaryColor,
                height: 1,
              ),
              ListTile(
                leading: Icon(
                  Icons.password_rounded,
                  size: _drawerIconSize,
                  color: Theme.of(context).accentColor,
                ),
                title: Text(
                  'Ubah Password',
                  style: TextStyle(
                      fontSize: _drawerFontSize,
                      color: Theme.of(context).accentColor),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordPage()),
                  );
                },
              ),              
              Divider(
                color: Theme.of(context).primaryColor,
                height: 1,
              ),
              ListTile(
                leading: Icon(
                  Icons.logout_rounded,
                  size: _drawerIconSize,
                  color: Theme.of(context).accentColor,
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(
                      fontSize: _drawerFontSize,
                      color: Theme.of(context).accentColor),
                ),
                onTap: () {
                  SystemNavigator.pop();
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 100,
              child: HeaderWidget(100, false, Icons.house_rounded),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(width: 5, color: Colors.white),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20,
                          offset: const Offset(5, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _tokenController,
                    decoration: InputDecoration(
                      labelText: 'Authorization Token',
                    ),
                  ),
                  // Text(
                  //   'Mr. Donald Trump',
                  //   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Former User',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding:
                              const EdgeInsets.only(left: 8.0, bottom: 4.0),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "User Information",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        // Card(
                        //   child: Container(
                        //     alignment: Alignment.topLeft,
                        //     padding: EdgeInsets.all(15),
                        //     child: Column(
                        //       children: <Widget>[
                        //         Column(
                        //           children: <Widget>[
                        //             ...ListTile.divideTiles(
                        //               color: Colors.grey,
                        //               tiles: [
                        ElevatedButton(
                          onPressed: _getUserDetail,
                          child: Text('Get User Detail'),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Nama: $_nama',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Email: $_email',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => EditDataPage()),
                                (Route<dynamic> route) => false);
                          },
                          child: Text('ubah data'),
                        ),
                        // ListTile(
                        //   contentPadding: EdgeInsets.symmetric(
                        //       horizontal: 12, vertical: 4),
                        //   leading: Icon(Icons.my_location),
                        //   title: Text("Location"),
                        //   subtitle: Text("USA"),
                        // ),
                        // ListTile(
                        //   leading: Icon(Icons.email),
                        //   title: Text("Email"),
                        //   subtitle:
                        //       Text("donaldtrump@gmail.com"),
                        // ),
                        // ListTile(
                        //   leading: Icon(Icons.phone),
                        //   title: Text("Phone"),
                        //   subtitle: Text("99--99876-56"),
                        // ),
                        // ListTile(
                        //   leading: Icon(Icons.person),
                        //   title: Text("About Me"),
                        //   subtitle: Text(
                        //       "This is a about me link and you can khow about me in this section."),
                        // ),
                        // Container(
                        //   decoration: ThemeHelper()
                        //       .buttonBoxDecoration(context),
                        //   child: ElevatedButton(
                        //     style: ThemeHelper().buttonStyle(),
                        //     child: Padding(
                        //       padding: EdgeInsets.fromLTRB(
                        //           40, 10, 40, 10),
                        //       child: Text(
                        //         'edit data'.toUpperCase(),
                        //         style: TextStyle(
                        //             fontSize: 20,
                        //             fontWeight: FontWeight.bold,
                        //             color: Colors.white),
                        //       ),
                        //     ),
                        //     onPressed: () {
                        //       Navigator.of(context)
                        //           .pushAndRemoveUntil(
                        //               MaterialPageRoute(
                        //                   builder: (context) =>
                        //                       EditDataPage()),
                        //               (Route<dynamic> route) =>
                        //                   false);
                        //     },
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           ],
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
