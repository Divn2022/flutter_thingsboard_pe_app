import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thingsboard_app/constants/assets_path.dart';
import 'package:thingsboard_client/thingsboard_client.dart';

import 'package:thingsboard_app/core/context/tb_context.dart';
import 'package:thingsboard_app/core/context/tb_context_widget.dart';

class LoginPage extends TbPageWidget<LoginPage, _LoginPageState> {

  LoginPage(TbContext tbContext) : super(tbContext) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.light
    ));
  }

  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends TbPageState<LoginPage, _LoginPageState> {

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Login to ThingsBoard'),
        ),
        body: ValueListenableBuilder(
            valueListenable: loadingNotifier,
            builder: (BuildContext context, bool loading, child) {
              List<Widget> children = [
                SingleChildScrollView(
                    child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(top: 60.0),
                              child: Center(
                                  child: Container(
                                      width: 300,
                                      height: 150,
                                      child: SvgPicture.asset(ThingsboardImage.thingsBoardLogoBlue,
                                          semanticsLabel: 'ThingsBoard Logo')
                                  )
                              )
                          ),
                          Padding(
                            //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: TextField(
                              enabled: !loading,
                              controller: usernameController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Username (email)',
                                  hintText: 'Enter valid email id as abc@gmail.com'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 15, bottom: 0),
                            //padding: EdgeInsets.symmetric(horizontal: 15),
                            child: TextField(
                              enabled: !loading,
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Password',
                                  hintText: 'Enter secure password'),
                            ),
                          ),
                          TextButton(
                            onPressed: loading ? null : () {
                              //TODO FORGOT PASSWORD SCREEN GOES HERE
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(color: loading ? Colors.black12 : Theme.of(context).colorScheme.primary, fontSize: 15),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 250,
                            decoration: BoxDecoration(
                                color: loading ? Colors.black12 : Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(4)),
                            child: TextButton(
                              onPressed: loading ? null : () {
                                tbClient.login(
                                    LoginRequest(usernameController.text, passwordController.text));
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(color: Colors.white, fontSize: 25),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 130,
                          ),
                          Text('New User? Create Account')
                        ]
                    )
                )
              ];
              if (loading) {
                children.add(
                    SizedBox.expand(
                        child: ClipRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                child: Container(
                                    decoration: new BoxDecoration(
                                        color: Colors.grey.shade200.withOpacity(0.2)
                                    ),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                  ),
                                )
                            )
                        )
                    )
                );
                //children.add(Center(child: CircularProgressIndicator()));
              }
              return Stack(
                children: children,
              );
        })
    );
  }
}