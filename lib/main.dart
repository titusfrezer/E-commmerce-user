import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vendor/variables/vars.dart';


import 'LoginScreen.dart';
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
//    List <Slide>slide = List();
//    slide.add(
//       Slide(
//      title:"hi",
//           description:
//            "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. ",
//         backgroundImage: "assets/images/men1.jpeg"
//
//      ),
//
//    );
//    slide.add(
//      Slide(
//          title:"hi",
//          description:
//          "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. ",
//          backgroundImage: "assets/images/men1.jpeg"
//
//      ),
//
//    );
//    void onDonePress() {
//    //Do what you want
//    Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => HomeController()),
//    );
//  }
//      Widget renderNextBtn() {
//    return Icon(
//      Icons.navigate_next,
//      color: Color(0xffD02090),
//      size: 35.0,
//    );
//  }
//
//  Widget renderDoneBtn() {
//    return Icon(
//      Icons.done,
//      color: Color(0xffD02090),
//    );
//  }
//
//  Widget renderSkipBtn() {
//    return Icon(
//      Icons.skip_next,
//      color: Color(0xffD02090),
//    );
//  }
    return MaterialApp(
      routes: {
        //'/': (BuildContext context) => AuthPage(),
        '/confirm': (BuildContext context) => ConfirmationPage(),

      },
      debugShowCheckedModeBanner: false,
//    home:IntroSlider(
//      slides: slide,
//      renderSkipBtn: renderSkipBtn(),
//      colorSkipBtn: Color(0x33000000),
//      highlightColorSkipBtn: Color(0xff000000),
//
//      // Next button
//      renderNextBtn: renderNextBtn(),
//        onDonePress: onDonePress,
//      // Done button
//      renderDoneBtn: renderDoneBtn(),
//    ));
    theme: ThemeData(

      primaryColor: background_2
    ),
      home: Provider(

        auth: AuthService(),
        child: HomeController(),
        ),);

  }
}

