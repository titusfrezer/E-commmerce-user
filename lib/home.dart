//import 'package:flutter/material.dart';
//import 'package:vendor/auth_service.dart';
//
//import 'main.dart';
//
//class Home extends StatefulWidget {
//  @override
//  _HomeState createState() => _HomeState();
//}
//
//class _HomeState extends State<Home> {
//
//  @override
//  Widget build(BuildContext context) {
//    final AuthService auth = Provider.of(context).auth;
//    return Container(
//     child:Center(
//       child:  RaisedButton(
//         child: Text("press here to log out",style: TextStyle(color: Colors.white70),),
//         onPressed: ()=>auth.signOut(),
//       ),
//     )
//    );
//  }
//}
