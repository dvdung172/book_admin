import 'package:client/core/theme.dart';
import 'package:client/data/repositories/authentiation_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../core/responsive.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({Key? key}) : super(key: key);
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forgot password ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: CustomColor.white,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back, color: CustomColor.black)),
          title: Text(
            "Forgot password",
            style: TextStyle(color: CustomColor.black),
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Receive an email to reset password", style: CustomTheme.mainTheme.textTheme.headline2,),
              const Padding(
                padding: EdgeInsets.only(top: 24),
              ),
              SizedBox(
                  width: Responsive.isDesktop(context) ? 500 : double.infinity,
                  child: TextField(
                    controller: _controller,
                    decoration:
                        const InputDecoration(hintText: 'Enter email to reset'),
                  )),
              const Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              ElevatedButton(
                onPressed: () async {
                  await AuthenticationRepository().resetPassword(email: _controller.text.trim());
                },
                child: const Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
