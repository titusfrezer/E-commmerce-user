import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:vendor/UI/User/fetchCategory.dart';

import 'package:vendor/variables/vars.dart';

import 'UI/Admin/AddCategory.dart';
import 'auth_service.dart';

bool signedIn;
class HomeController extends StatefulWidget {
  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  DatabaseReference userRef =
      FirebaseDatabase.instance.reference().child("Users");

  FirebaseAuth _auth;

  FirebaseUser user;

  var connectivity;

  getCurrentUser() async {
    user = await _auth.currentUser();
    connectivity = await (Connectivity().checkConnectivity());
    //print(user.email.toString());
  }

  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    getCurrentUser();
   // checkIdentity();
  }

  bool check = false;
//
//  checkIdentity() async {
//
//    await userRef.once().then((DataSnapshot snap) {
//      var KEYS = snap.value.keys;
//      var DATA = snap.value;
//      print(DATA);
//
//      for (var individualKey in KEYS) {
//        if (DATA[individualKey]['email'] == user.email) {
//          identity = DATA[individualKey]['identity'];
//          check = true;
//          print("Signed emil ${user.email}");
//          print("Identity ${identity}");
//          print("Email from db ${DATA[individualKey]['email']}");
//        }
//      }
//    });
//  }

  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;

    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot) {
        print(snapshot.connectionState);
        if (snapshot.connectionState == ConnectionState.active) {
         signedIn = snapshot.hasData;
          print("fgdssds${snapshot.data}");
//          if (signedIn && identity == "Buyer") {
//            return fetchCategory();
//          }
//          else if (signedIn && identity == "Vendor") {
//            return AddCategory();
//          }
//          else if (!signedIn) {
//            return LoginScreen();
//          }
//
//        } return  Center(child: CircularProgressIndicator());;
          return  signedIn? AddCategory(): fetchCategory();

        }
        return CircularProgressIndicator();
      }
    );
  }
}

class Provider extends InheritedWidget {
  final AuthService auth;

  Provider({Key key, Widget child, this.auth}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static Provider of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(Provider) as Provider);
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //TextEditingController email = TextEditingController();
  TextEditingController controller = TextEditingController();
  //TextEditingController passowrd = TextEditingController();
  bool check = false;
  //TextEditingController confirmPassword = TextEditingController();


  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String> _authUser(LoginData data) {
    userName = data.name;



      // await FirebaseAuth.instance.signInWithEmailAndPassword(email: data.name, password: data.password)
    return Future.delayed(loginTime).then((_) async {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: data.name, password: data.password);
//        await userRef.once().then((DataSnapshot snap) {
//          var KEYS = snap.value.keys;
//          var DATA = snap.value;
//          print(DATA);
//
//
//          for (var individualKey in KEYS) {
//            if ((DATA[individualKey]['email'] == data.name) &&
//                (DATA[individualKey]['identity'] == identity)) {
//              check = true;
//              print("Email ${DATA[individualKey]['email']}");
//              FirebaseAuth.instance.signInWithEmailAndPassword(
//                  email: data.name, password: data.password);
//            }
//          }
//        });
      }
       catch (Exception) {

        if (Exception.toString() ==
            "PlatformException(ERROR_NETWORK_REQUEST_FAILED, A network error (such as timeout, interrupted connection or unreachable host) has occurred., null)") {
          return 'Connection Error Please try again';
        }


        return "Email doesn't exist";
      }

      return null;
    });
  }

  Future<String> _signupUser(LoginData data) {
//  print('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
//    if (users.containsKey(data.name)) {
//      return 'Username exists';
//    }
//    if (users[data.name] != data.password) {
//      return 'Password does not match';
//    }
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: data.name,
          password: data.password,
        );

          //return 'Valid phone Number Required';

      } catch (e) {
        print(e);
        if (e.toString() ==
            "PlatformException(ERROR_NETWORK_REQUEST_FAILED, A network error (such as timeout, interrupted connection or unreachable host) has occurred., null)") {
          return 'Connection Error Please try again';
        }

        return 'Email already exists';
      }
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) async {
//      if (!users.containsKey(name)) {
//        return 'Username not exists';
//      }
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: name);
        print('user');
      } catch (e) {
        if (e.toString() ==
            "PlatformException(ERROR_NETWORK_REQUEST_FAILED, A network error (such as timeout, interrupted connection or unreachable host) has occurred., null)") {
          return 'Connection Error Please try again';
        }
        return 'Email not exists';
      }
      return null;
    });
  }

  List<String> who = ['Buyer', 'Vendor'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body:SafeArea(
      child: Container(

        child: Stack(
          children: <Widget>[
            FlutterLogin(
              theme: LoginTheme(
                buttonTheme: LoginButtonTheme(backgroundColor: background),
                primaryColor: background_2,
              ),
              title: 'E-commerce',
              logo: 'assets/images/ecorp-lightblue.png',
              onLogin: _authUser,
              onSignup: _signupUser,
              onSubmitAnimationCompleted: () {

               Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddCategory()));
              },
              onRecoverPassword: _recoverPassword,
            ),

          ],
        ),
      ),
    ));
  }
}

