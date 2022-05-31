import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mobile_quran/models/user.dart';
import 'package:mobile_quran/views/home.dart';
import 'package:mobile_quran/views/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameFilter = TextEditingController();
  final TextEditingController _passwordFilter = TextEditingController();
  String username = "";
  String password = "";
  bool isRegisterSuccess = true;

  late final Box box;

  _RegisterPageState() {
    _usernameFilter.addListener(_usernameListen);
    _passwordFilter.addListener(_passwordListen);
  }

  _addUser() async {
    String message = "";
    bool isRegistered = false;
    User newUser = User(username: username, password: password);

    var index = box.length;
    for (var i = 0; i < index; i++) {
      var user = box.getAt(i);
      if (user.username == username) {
        message = "Username is exist";
        SnackBar snackBar = SnackBar(
          content: Text(message),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        isRegistered = true;
        setState(() {
          isRegisterSuccess = false;
        });
        break;
      }
    }

    if (isRegistered == false) {
      setState(() {
        isRegisterSuccess = true;
      });
      box.add(newUser);
      message = "Register success";
      SnackBar snackBar = SnackBar(
        content: Text(message),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) {
          return LoginPage();
        }),
        (route) => false,
      );
    }
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
  void initState() {
    super.initState();
    // Get reference to an already opened box
    box = Hive.box('userBox');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          _logo(),
          _usernameField(),
          _passwordField(),
          _registerButton(context),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return LoginPage();
                    }),
                    (route) => false,
                  );
                },
                child: Text(
                  "Sudah punya akun? login disini",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Color.fromARGB(255, 16, 74, 121)),
                )),
          ),
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
          child: Image.asset(
            'logo.png',
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.height / 3,
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
        controller: _usernameFilter,
        decoration: InputDecoration(
          hintText: 'Username',
          contentPadding: const EdgeInsets.all(8.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(
                color: (isRegisterSuccess) ? Colors.green : Colors.red),
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
        obscureText: true,
        controller: _passwordFilter,
        decoration: InputDecoration(
          hintText: 'Password',
          contentPadding: const EdgeInsets.all(8.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(
                color: (isRegisterSuccess) ? Colors.green : Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _registerButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 48, right: 48, bottom: 10),
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: (isRegisterSuccess) ? Colors.green : Colors.red,
          onPrimary: Colors.white,
        ),
        onPressed: () {
          if (username != "" || password != "") {
            _addUser();
          } else {
            setState(() {
              isRegisterSuccess = false;
            });
            SnackBar snackBar = SnackBar(
              content: Text("Username or password can't be empty"),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: const Text('Register'),
        ),
      ),
    );
  }
}
