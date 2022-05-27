import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mobile_quran/models/user.dart';
import 'package:mobile_quran/views/home.dart';
import 'package:mobile_quran/views/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<RegisterPage> {
  final TextEditingController _usernameFilter = TextEditingController();
  final TextEditingController _passwordFilter = TextEditingController();
  final _userFormKey = GlobalKey<FormState>();
  String username = "";
  String password = "";
  bool isRegisterSuccess = true;

  late final Box box;

  // _LoginPageState() {
  //   _usernameFilter.addListener(_usernameListen);
  //   _passwordFilter.addListener(_passwordListen);
  // }

  _addUser() async {
    User newUser = User(
      username: _usernameFilter.text,
      password: _passwordFilter.text
    );

    box.add(newUser);
    print('User added to database!');
  }

  String? _fieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field can\'t be empty';
    }
    return null;
  }

  void _usernameListen() {
    if (_usernameFilter.text.isEmpty) {
      username = "";
    } else {
      username = _usernameFilter.text;
    }
  }

  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      password = "";
    } else {
      password = _passwordFilter.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Register Page"),
        ),
        body: Column(children: [
          _logo(),
          _usernameField(),
          _passwordField(),
          _loginButton(context),
        ]),
      ),
    );
  }

  Widget _logo() {
    return Padding(
      padding: EdgeInsets.all(32),
      child: Column(children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 96),
          child: FlutterLogo(
            size: 50,
          ),
        ),
      ]),
    );
  }

  Widget _usernameField() {
    return Container(
      padding: EdgeInsets.only(left: 48, right: 48, bottom: 10),
      child: TextFormField(
        enabled: true,
        // onChanged: (value) {
        //   username = value;
        // },
        controller: _usernameFilter,
        validator: _fieldValidator,
        decoration: InputDecoration(
          hintText: 'Username',
          contentPadding: const EdgeInsets.all(8.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide:
                BorderSide(color: (isRegisterSuccess) ? Colors.green : Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      padding: EdgeInsets.only(left: 48, right: 48, bottom: 10),
      child: TextFormField(
        enabled: true,
        // onChanged: (value) {
        //   password = value;
        // },
        obscureText: true,
        controller: _passwordFilter,
        validator: _fieldValidator,
        decoration: InputDecoration(
          hintText: 'Password',
          contentPadding: const EdgeInsets.all(8.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide:
                BorderSide(color: (isRegisterSuccess) ? Colors.green : Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 48, right: 48, bottom: 10),
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: (isRegisterSuccess) ? Colors.green : Colors.red,
          onPrimary: Colors.white,
        ),
        onPressed: () {
          String text = "";
        if (_userFormKey.currentState!.validate()) {
            _addUser();
            Navigator.of(context).pop();
            isRegisterSuccess = true;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) {
              return LoginPage();
            }),
            (route) => false,
            );
        }
        SnackBar snackBar = SnackBar(
            content: Text(text),
          );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: const Text('Register'),
        ),
      ),
    );
  }
}
