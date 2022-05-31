import 'package:flutter/material.dart';
import 'package:mobile_quran/views/home.dart';
import 'package:mobile_quran/views/register_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameFilter = TextEditingController();
  final TextEditingController _passwordFilter = TextEditingController();
  String username = "";
  String password = "";
  bool isLoginSuccess = true;
  bool isChecked = false;

  late final Box box;

  _LoginPageState() {
    _usernameFilter.addListener(_usernameListen);
    _passwordFilter.addListener(_passwordListen);
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
    createOpenBox();
  }

  void createOpenBox() async {
    box = await Hive.openBox('userBox');
    getdata();
  }

  void getdata() async {
    if (box.get('username') != null) {
      _usernameFilter.text = box.get('username');
      isChecked = true;
      setState(() {});
    }
    if (box.get('password') != null) {
      _passwordFilter.text = box.get('password');
      isChecked = true;
      setState(() {});
    }
  }

  void login() async {
    String text1 = "";
    // perform your login authentication
    // is login success then save the credential if remember me is on
    // box.put('username', _usernameFilter.value.text);
    // box.put('password', _passwordFilter.value.text);
    var index = box.length;
    for (var i = 0; i < index; i++) {
      var user = box.getAt(i);
      if (user.username == username && user.password == password) {
        text1 = "Login Success";
        setState(() {
          isLoginSuccess = true;
        });
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return Home(username: username);
        }));
        break;
      } else {
        text1 = "Login Failed";
        setState(() {
          isLoginSuccess = false;
        });
      }
    }

    SnackBar snackBar = SnackBar(
      content: Text(text1),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text("Login Page"),
        // ),
        body: Column(children: [
          _logo(),
          _usernameField(),
          _passwordField(),
          _loginButton(context),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return RegisterPage();
                    }),
                    (route) => false,
                  );
                },
                child: Text(
                  "Belum punya akun? daftar disini",
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
        // onChanged: (value) {
        //   username = value;
        // },
        controller: _usernameFilter,
        decoration: InputDecoration(
          hintText: 'Username',
          contentPadding: const EdgeInsets.all(8.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide:
                BorderSide(color: (isLoginSuccess) ? Colors.green : Colors.red),
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
        decoration: InputDecoration(
          hintText: 'Password',
          contentPadding: const EdgeInsets.all(8.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide:
                BorderSide(color: (isLoginSuccess) ? Colors.green : Colors.red),
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
          primary: (isLoginSuccess) ? Colors.green : Colors.red,
          onPrimary: Colors.white,
        ),
        onPressed: () {
          String text1 = "";
          // perform your login authentication
          // is login success then save the credential if remember me is on
          login();
          // String text = "";
          // if (password == "123") {
          //   setState(() {
          //     text = "Login Success";
          //     isLoginSuccess = true;
          //   });
          //   Navigator.pushReplacement(context,
          //       MaterialPageRoute(builder: (context) {
          //     return Home(username: username);
          //   }));
          // } else {
          //   setState(() {
          //     text = "Login Failed";
          //     isLoginSuccess = false;
          //   });
          // }
          // login();
          //
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: const Text('Login'),
        ),
      ),
    );
  }
}
