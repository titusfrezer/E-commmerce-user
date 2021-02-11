import 'package:flutter/material.dart';

import 'package:vendor/variables/vars.dart';


import 'LoginScreen.dart';
import 'UI/User/fetchCategory.dart';



class LoginUi extends StatefulWidget {
  @override
  _LoginUiState createState() => _LoginUiState();
}

class _LoginUiState extends State<LoginUi> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: background_2,
        body:Container(
          decoration: BoxDecoration(

              image: DecorationImage(image: AssetImage('assets/images/cart.jpg'),fit: BoxFit.cover)
          ),
          alignment: Alignment.center,
          child: Container(
          color: Colors.white70,
            height: 275,
            width: 275,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Afroel E-commerce",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 50,
                ),
                Text("Continue as...", style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 25,
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  splashColor: Colors.black,
                  textColor: Colors.white,
                  color: background,
                  shape:  RoundedRectangleBorder(
                      borderRadius:  BorderRadius.circular(30.0)),
                  child: Text("A Vendor", style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  )),
                ),
                SizedBox(
                  height: 25,
                ),
                FlatButton(
                  onPressed: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) =>fetchCategory() ));
                  },
                  padding: EdgeInsets.only(
                      top: 10, bottom: 10, right: 15, left: 15),
                  color: Colors.white,
                  splashColor: Colors.deepOrange,
                  shape:  RoundedRectangleBorder(
                      borderRadius:  BorderRadius.circular(30.0)),
                  child: Text("A Buyer",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
