import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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




  @override
  void initState() {
    super.initState();

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
          Container(
            color: Colors.blueGrey,
            padding: EdgeInsets.all(50),
            child: Icon(Icons.flip_camera_android,size: 50,),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            color: Colors.blueGrey,
            padding: EdgeInsets.all(50),
            child: Icon(Icons.light_mode,size: 50,),
          ),
        ],
      ),
    );
  }
}
