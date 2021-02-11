
import 'package:flutter/material.dart';
import 'package:vendor/variables/vars.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        backgroundColor: background_2,
      ),
      body: Column(
        children: <Widget>[
          Icon(
            Icons.alternate_email,
            size: 150,
          ),
          Column(
            children: <Widget>[
              Container(child: Center(child: Text('Run by Digital Center ......'))),
              SizedBox(height: 20,),
              Container(child:Center(child:Padding(padding:EdgeInsets.all(10),child:Text('This app is designed and developed to meet your shoping interest:')))),
              SizedBox(height: 20,),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.comment),
                      SizedBox(width: 10,),
                      Text('1 If you want to give comment on our service')
                    ],

                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: <Widget>[
                      Icon(Icons.report_problem),
                      SizedBox(width: 10,),
                      Text('2 If you want to report any problem')
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(padding:EdgeInsets.all(20),child:
                  Column(
                    children: [
                      Text("Afroel Shopping (Addis Ababa)",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),

                      SizedBox(height:10),

                      GestureDetector(
                        child:Text('0942113449',style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                        onTap: (){
                          UrlLauncher.launch('tel:0942113449');
                        },
                      ),

                      SizedBox(height:10),

                      GestureDetector(
                        child:Text('0924181462',style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                        onTap: (){
                          UrlLauncher.launch('tel:0924181462');
                        },
                      ),
                        SizedBox(height: 10,),



                    ],
                  ))

                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
