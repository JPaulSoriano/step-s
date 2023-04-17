import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step/constants.dart';
import 'package:step/models/response_model.dart';
import 'package:step/models/user_model.dart';
import 'package:step/screens/home_screen.dart';
import 'package:step/services/user_service.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading = false;

  void _loginUser() async {
    ApiResponse response = await login(txtEmail.text, txtPassword.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('STEP S LMS'),
      ),
      body: Form(
        key: formkey,
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.all(32),
              children: [
                Center(
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: txtEmail,
                    validator: (val) =>
                        val!.isEmpty ? 'Invalid email address' : null,
                    decoration: kInputDecoration('Email')),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                    controller: txtPassword,
                    obscureText: true,
                    validator: (val) =>
                        val!.length < 6 ? 'Required at least 6 chars' : null,
                    decoration: kInputDecoration('Password')),
                SizedBox(
                  height: 10,
                ),
                loading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : kTextButton('Login', () {
                        if (formkey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                            _loginUser();
                          });
                        }
                      }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
