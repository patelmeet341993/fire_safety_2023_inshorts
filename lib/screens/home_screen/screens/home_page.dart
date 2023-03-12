import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:inshorts/models/Article.dart';

import '../../common/components/app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> topics = [];

  int selectedItem = 0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Article> data = [];

  bool isFan=false;
  bool isLight=false;

  final  database=FirebaseDatabase.instance;
  void getdata(){

    print("calling get daya");

    database.ref("fan").get().then((value) {
     dynamic number= value.value.toString();
     print("get data :  $number");

     if(number=="1")
       {
         isFan=true;
       }
     else
       {
         isFan=false;
       }
     setState(() {

     });
    });

    database.ref("light").get().then((value) {
      dynamic number= value.value.toString();
      print("get data :  $number");
      if(number=="1")
      {
        isLight=true;
      }
      else
      {
        isLight=false;
      }
      setState(() {

      });
    });

  }


  @override
  void initState() {
    super.initState();
    getdata();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MyAppBar(
            title: "Table Controller App",
            color: Colors.white,
            backbtnVisible: false,
          ),
          SizedBox(
            height: 100,
          ),
          InkWell(
            onTap: (){
        onOffFan();
            },
            child: Container(
              color: isFan?Colors.green:Colors.blueGrey,
              padding: EdgeInsets.all(50),
              child: Icon(Icons.flip_camera_android,size: 50,),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          InkWell(
            onTap: (){
      onOffLight();
            },
            child: Container(
              color: isLight?Colors.green:Colors.blueGrey,
              padding: EdgeInsets.all(50),
              child: Icon(Icons.light_mode,size: 50,),
            ),
          ),
        ],
      ),
    );
  }


  void onOffLight(){
    if(isLight)
      {
        database.ref("light").set(0);
      }
    else
      {
        database.ref("light").set(1);
      }
    isLight=!isLight;
    setState(() {

    });
  }

  void onOffFan(){
    if(isFan)
    {
      database.ref("fan").set(0);
    }
    else
    {
      database.ref("fan").set(1);
    }
    isFan=!isFan;
    setState(() {

    });
  }

}
