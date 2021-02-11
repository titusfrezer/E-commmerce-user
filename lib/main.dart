import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vendor/variables/vars.dart';


import 'LoginScreen.dart';
import 'UI/Admin/AddCategory.dart';
import 'UI/User/SingleProductDetail.dart';
import 'auth_service.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_){
    runApp(MyApp());
  });

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/confirm': (BuildContext context) => ConfirmationPage(),
        '/addCategory':(BuildContext context) => AddCategory()
      },
      debugShowCheckedModeBanner: false,
    theme: ThemeData(

      primaryColor: background_2
    ),
      home: Provider(

        auth: AuthService(),
        child: HomeController(),
        ),);

  }
}

