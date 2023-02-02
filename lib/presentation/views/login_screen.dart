import 'package:client/core/di.dart';
import 'package:client/data/repositories/authentiation_repository.dart';
import 'package:client/presentation/views/login/forgot_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/responsive.dart';
import '../../core/theme.dart';
import '../providers/side_bar_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailEditingController =
      TextEditingController(text: dotenv.env['USERNAME'] ?? '');
  final TextEditingController _passwordEditingController =
      TextEditingController(text: dotenv.env['PASSWORD'] ?? '');

  final FocusNode _emailNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _viewNode = FocusNode();

  bool _obscureText = true;
  bool _emailCheck = true;
  bool _passwordCheck = true;

  late bool isChecked = false;

  var provider = sl<SideBarProvider>();
  @override
  void initState() {
    super.initState();
    provider.currentIndex = 0;
    _obscureText = true;
    _emailCheck = true;
    _passwordCheck = true;
    SharedPreferences.getInstance().then((prefValue) => {
      setState(() {
        if(prefValue.getString('username')!= null ){
          isChecked = true;
        }
        _emailEditingController.text = prefValue.getString('username')?? "";
        _passwordEditingController.text = prefValue.getString('password')?? "";

      })
    });

  }

  @override
  void dispose() {
    _emailNode.dispose();
    _passwordNode.dispose();
    _viewNode.dispose();
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isKeyboardOpen = (MediaQuery.of(context).viewInsets.bottom > 0);
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _buildHeader(isKeyboardOpen),
                SizedBox(
                    width: Responsive.isDesktop(context) ? 500:   double.infinity,
                    child: _buildEmailField(context)),
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                ),
                SizedBox(
                    width: Responsive.isDesktop(context) ? 500:   double.infinity,
                    child: _buildPasswordField(context)),
                SizedBox(
                  width: Responsive.isDesktop(context) ? 500:   double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        value: isChecked,
                        activeColor: CustomTheme.mainTheme.primaryColor,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      Text(tr('screens.login.remember_me')),
                    ],
                  ),
                ),
                SizedBox(
                  width: Responsive.isDesktop(context) ? 500:   double.infinity,
                  height: 40,
                  child: _buildLoginButton(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(tr('screens.login.dont_have_account')),
                    TextButton(
                        onPressed: () async {
                          final Uri _url = Uri.parse("https://console.firebase.google.com/u/0/project/books-app-98299/authentication/users");
                          if (!await launchUrl(_url)) {
                            throw Exception('Could not launch $_url');
                          }
                        },
                        child: Text(
                          tr('screens.login.signup'),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CustomTheme.mainTheme.primaryColor),
                        ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't remember password?"),
                    TextButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ForgotPassword()),
                          );
                        },
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CustomTheme.mainTheme.primaryColor),
                        ))
                  ],
                ),
                // SizedBox(
                //   child: Text(tr('screens.login.signin_with')),
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     SizedBox(
                //       width: 70.0,
                //       height: 70.0,
                //       child: TextButton(
                //         style: ButtonStyle(
                //           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //           minimumSize: MaterialStateProperty.all(
                //               const Size(double.infinity, 44)),
                //           shape: MaterialStateProperty.all(
                //             RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(40.0)),
                //           ),
                //         ),
                //         child: Image.asset(
                //           'assets/image/login_google.png',
                //           fit: BoxFit.cover,
                //         ),
                //         onPressed: () {},
                //       ),
                //     ),
                //     SizedBox(
                //       width: 70.0,
                //       height: 70.0,
                //       child: TextButton(
                //         style: ButtonStyle(
                //           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //           minimumSize: MaterialStateProperty.all(
                //               const Size(double.infinity, 44)),
                //           shape: MaterialStateProperty.all(
                //             RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(40.0)),
                //           ),
                //         ),
                //         child: Image.asset(
                //           'assets/image/login_facebook.png',
                //           fit: BoxFit.cover,
                //         ),
                //         onPressed: () {},
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isKeyboardOpen) {
    if (!isKeyboardOpen) {
      return Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 74),
          ),
          const SizedBox(
            width: 60,
            height: 60,
            child: Icon(
              Icons.flutter_dash_rounded,
              size: 60,
            ),
            // Image(
            //   image: AssetImage("images/logo.png"),
            // ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Text(
            tr('screens.login.signin'),
            style: CustomTheme.mainTheme.textTheme.headline2,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 14),
          ),
        ],
      );
    }
    return const Padding(
      padding: EdgeInsets.only(top: 74),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      focusNode: _viewNode,
      key: const Key("login"),
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(CustomColor.logoBlue),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return CustomColor.logoBlue.withOpacity(0.04);
            }
            if (states.contains(MaterialState.focused) ||
                states.contains(MaterialState.pressed)) {
              return CustomColor.logoBlue.withOpacity(0.12);
            }
            return CustomColor.logoBlue;
          },
        ),
      ),
      onPressed: () async {
        final prefs = await SharedPreferences.getInstance();
        print('Validating before login');
        var emailValid = _emailEditingController.text.isNotEmpty;
        var passwordValid = _passwordEditingController.text.isNotEmpty;
        setState(() {
          _emailCheck = emailValid;
          _passwordCheck = passwordValid;
        });

        if (emailValid && passwordValid) {
          try {
            await AuthenticationRepository().signInWithEmailAndPassword(
                email: _emailEditingController.text, password: _passwordEditingController.text);
            if(isChecked == true){
              await prefs.setString('username', _emailEditingController.text);
              await prefs.setString('password', _passwordEditingController.text);
            }
            else{
              await prefs.remove('username');
              await prefs.remove('password');
            }
          } on FirebaseAuthException catch (e) {
            if (e.code == 'weak-password') {
              print('The password provided is too weak.');
            } else if (e.code == 'email-already-in-use') {
              print('The account already exists for that email.');
            }
          } catch (e) {
            print(e);
          }
        }
      },
      child: Text(
        tr('common.login'),
        style: CustomTheme.mainTheme.textTheme.button,
      ),
    );
  }

  TextFormField _buildEmailField(BuildContext context) {
    return TextFormField(
      focusNode: _emailNode,
      controller: _emailEditingController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        errorText: _emailCheck == false
            ? tr('messages.invalid_item', args: ['email'])
            : null,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(
            color: CustomColor.textFieldBackground,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(
            color: CustomColor.textFieldBackground,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(
            color: CustomColor.textFieldBackground,
          ),
        ),
        focusColor: CustomColor.hintColor,
        hoverColor: CustomColor.hintColor,
        fillColor: CustomColor.textFieldBackground,
        filled: true,
        labelText: tr('screens.login.email'),
        labelStyle: CustomTheme.mainTheme.textTheme.headline6,
      ),
      cursorColor: CustomColor.hintColor,
      onTap: () {
        setState(() {});
      },
      onFieldSubmitted: (term) {
        if (_emailEditingController.text.isNotEmpty) {
          setState(() {
            _emailCheck = true;
          });
        }
        _fieldFocusChange(context, _emailNode, _passwordNode);
      },
    );
  }

  TextFormField _buildPasswordField(BuildContext context) {
    return TextFormField(
        focusNode: _passwordNode,
        controller: _passwordEditingController,
        obscureText: _obscureText,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          errorText: _passwordCheck == false
              ? tr('messages.invalid_item', args: ['password'])
              : null,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: const BorderSide(
              color: CustomColor.textFieldBackground,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: const BorderSide(
              color: CustomColor.textFieldBackground,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: const BorderSide(
              color: CustomColor.textFieldBackground,
            ),
          ),
          focusColor: CustomColor.hintColor,
          hoverColor: CustomColor.hintColor,
          fillColor: CustomColor.textFieldBackground,
          filled: true,
          labelText: tr('screens.login.password'),
          labelStyle: CustomTheme.mainTheme.textTheme.headline5,
          suffixIcon: IconButton(
            icon: _obscureText == true
                ? const Icon(Icons.remove_red_eye)
                : const Icon(Icons.visibility_off),
            color: CustomColor.hintColor,
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
        cursorColor: CustomColor.hintColor,
        onTap: () => setState(() {}),
        onFieldSubmitted: (term) {
          if (_passwordEditingController.text.isNotEmpty) {
            setState(() {
              _passwordCheck = true;
            });
          }
          _fieldFocusChange(context, _passwordNode, _viewNode);
        });
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
