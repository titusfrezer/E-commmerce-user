import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:vendor/variables/vars.dart';
class Help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Help'),
          backgroundColor: background_2,
        ),
        body:Column(
          children: <Widget>[
            Icon(
              Icons.live_help,
              size: 150,
            ),

            Text("Developer's Contact",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
            SizedBox(height: 20,),
            Column(children: <Widget>[
              GestureDetector(
                onTap:(){UrlLauncher.launch('tel:0924334695');},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.call),
                    Text('0924334695',style:TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                  onTap:(){UrlLauncher.launch('tel:0962491657');}
                  ,child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.call),
                  Text('0962491657',style:TextStyle(fontWeight: FontWeight.bold)),
                ],
              ))
            ],),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Adminstrator's Contact",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                GestureDetector(
                  child:Row(
                    children: <Widget>[
                      Icon(Icons.subdirectory_arrow_right),
                      Text('0936377294',style:TextStyle(fontWeight: FontWeight.bold,backgroundColor: Colors.grey.shade400)),
                    ],
                  ),
                  onTap: (){
                    UrlLauncher.launch('tel:0936377294');
                  },
                )
              ],
            )

          ],
        )
    );
  }
}