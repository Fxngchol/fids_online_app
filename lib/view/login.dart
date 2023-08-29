// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/color.dart';
import '../widget/app_button.dart';
import '../widget/text_field_widget_with_icon.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isConnectivity = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isPhone = Device.get().isPhone;

  String? username = '';
  String? password = '';
  bool isLoggedIn = false;
  String? userId;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    autoLogIn(context);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();

    super.dispose();
  }

  void autoLogIn(BuildContext maincontext) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userId');
    if (userId != null) {
      setState(() {
        isLoggedIn = true;
        this.userId = userId;
        prefs.setString('userId', userId);
      });
      Navigator.pushNamed(maincontext, '/home');
      return;
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/bgNew.png"), fit: BoxFit.cover)),
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          body: Center(child: bodyView()),
        ),
      ),
    );
  }

  Widget bodyView() {
    // if (isLoading) {
    //   return Container(
    //     child: Center(child: CircularProgressIndicator()),
    //   );
    // }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        titleView(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        Padding(
          padding: isPhone
              ? const EdgeInsets.all(32)
              : const EdgeInsets.only(left: 64, right: 64),
          child: Column(
            children: [
              usernameView(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.020,
              ),
              passwordView(),
              forgetPasswordButton(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.025,
              ),
              loginButton(context),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    'Version 2.0(32)',
                    textAlign: TextAlign.end,
                    style: GoogleFonts.prompt(
                      textStyle: TextStyle(
                        color: Colors.white,
                        letterSpacing: .5,
                        fontSize: MediaQuery.of(context).size.height * 0.015,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget titleView() {
    return Text(
      'ระบบเชื่อมโยงฐานข้อมูลนิติวิทยาศาสตร์\n(Forensic Integrated Database System)',
      textAlign: TextAlign.center,
      maxLines: 2,
      style: GoogleFonts.prompt(
        textStyle: TextStyle(
          color: Colors.white,
          letterSpacing: .5,
          fontSize: isPhone
              ? MediaQuery.of(context).size.height * 0.018
              : MediaQuery.of(context).size.height * 0.03,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget usernameView() {
    return InputFieldWithIcon(
        label: 'กรอกชื่อผู้ใช้',
        prefixIcon: Icons.person,
        onChanged: (value) {
          setState(() {
            username = value?.trim();
          });
        });
  }

  Widget passwordView() {
    return InputFieldWithIcon(
      label: 'กรอกรหัสผ่าน',
      prefixIcon: Icons.lock,
      obscureText: true,
      onChanged: (value) {
        setState(() {
          password = value?.trim();
        });
      },
      onSubmitted: (value) {
        if (kDebugMode) {
          print('onSubmitted');
        }
      },
    );
  }

  Widget forgetPasswordButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          child: Text(
            'ลืมรหัสผ่าน?',
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: Colors.white,
                letterSpacing: .5,
                fontSize: MediaQuery.of(context).size.height * 0.02,
              ),
            ),
          ),
          onPressed: () {
            if (kDebugMode) {
              print('ลืมรหัสผ่าน');
            }
          },
        ),
      ],
    );
  }

  Widget loginButton(BuildContext maincontext) {
    return Builder(builder: (context) {
      return AppButton(
          color: pinkButton,
          textColor: Colors.white,
          text: 'เข้าสู่ระบบ',
          onPressed: () async {
            await initConnectivity();
            if (isConnectivity) {
              if (username == '') {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: const Duration(seconds: 3),
                    content: Text(
                      'กรุณากรอกชื่อผู้ใช้',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.prompt(
                        textStyle: TextStyle(
                          color: Colors.white,
                          letterSpacing: .5,
                          fontSize: MediaQuery.of(context).size.height * 0.02,
                        ),
                      ),
                    )));
              } else if (password == '') {
                // ignore: deprecated_member_use
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: const Duration(seconds: 3),
                    content: Text(
                      'กรุณากรอกรหัสผ่าน',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.prompt(
                        textStyle: TextStyle(
                          color: Colors.white,
                          letterSpacing: .5,
                          fontSize: MediaQuery.of(context).size.height * 0.02,
                        ),
                      ),
                    )));
              } else {
                setState(() {
                  isLoading = true;
                });
                login(username, password, maincontext);
                // Navigator.pushNamed(maincontext, '/home');
              }
            } else {
              _displaySnackBarConnection(maincontext);
            }
          });
    });
  }

  void login(
      String? username, String? password, BuildContext maincontext) async {
    await get(
        Uri.parse(
            'https://crimescene.fids.police.go.th/mobile/api/User/$username:$password'),
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Credentials': 'true',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
        }).then((response) async {
      if (response.statusCode == 200) {
        try {
          if (kDebugMode) {
            print(response.body);
          }
          if ('[]' == response.body) {
            _displaySnackBar(context);
          } else {
            await SharedPreferences.getInstance().then((prefs) async {
              await prefs
                  .setString('user_info', response.body)
                  .then((value) async {
                Map mapRes = json.decode(response.body);
                String? uid = mapRes['userid'];
                String? uGroup = mapRes['departmentid'];
                String? username = mapRes['username'];
                String? userId = mapRes['userid'];

                if ('$uid' == '') {
                  _displaySnackBar(context);
                } else {
                  if (kDebugMode) {
                    print(' uGroup $uGroup');
                  }
                  await prefs.setString('uid', uid ?? '');
                  await prefs.setString('uGroup', uGroup ?? '');
                  await prefs.setString('username', username ?? '');
                  await prefs.setString('userId', userId ?? '');
                  Navigator.pushNamed(maincontext, '/home');
                }
              });
            });
          }
        } catch (ex) {
          //   print('>>response.statusCode : ${response.statusCode}');
          //  print('>>response.body : ${response.body}');
          //  print('ex  $ex');

          _displaySnackBar(context);
        }
      } else {
        if (kDebugMode) {
          print('response.statusCode : ${response.statusCode}');

          print('response.body : ${response.body}');
        }
        _displaySnackBar(context);
        throw Exception('เข้าสู่ระบบไม่สำเร็จ');
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  _displaySnackBar(BuildContext context) {
    const snackBar = SnackBar(content: Text('เข้าสู่ระบบไม่สำเร็จ'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _displaySnackBarConnection(BuildContext context) {
    const snackBar = SnackBar(content: Text('ไม่ได้เชื่อมต่ออินเทอร์เน็ต'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        setState(() {
          isConnectivity = true;
        });
        break;
      case ConnectivityResult.none:
        setState(() {
          isConnectivity = false;
        });
        break;
      default:
        setState(() {
          isConnectivity = false;
        });
        break;
    }
  }
}
