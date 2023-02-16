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

  getTopics() {
    firestore.collection("admin").doc("data").get().then((value) {
      Map<dynamic, dynamic> data = value.data() as Map;
      topics = data["topics"];
      selectedItem = 0;
      getArticles(topics[0]);
      setState(() {});
    });
  }

  void getArticles(String topic) {
    data.clear();
    setState(() {

    });
    firestore.collection(topic).get().then((value) {

     List<QueryDocumentSnapshot> documentSnapshot= value.docs;
     for(int i=0;i<documentSnapshot.length;i++)
       {
         Map<dynamic, dynamic> map = documentSnapshot[i].data() as Map;
         data.add(Article.fromMap(map, documentSnapshot[i].id));
         print("article : $map");
       }
      setState(() {

      });
    });
  }

  @override
  void initState() {
    super.initState();
    getTopics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MyAppBar(
            title: "Fire Safety",
            color: Colors.white,
            backbtnVisible: false,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            child: ListView.builder(
                itemCount: topics.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onTap: () {
                      selectedItem = index;
                      getArticles(topics[selectedItem]);
                      setState(() {});
                    },
                    child: Container(
                      height: 34,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                            selectedItem != index ? Colors.blue : Colors.indigo,
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      margin: EdgeInsets.only(left: 10),
                      child: Center(
                          child: Text(
                        topics[index],
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  );
                }),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(child: PageView.builder(
                itemCount: data.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (ctx, index) {

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(imageUrl: data[index].img,fit: BoxFit.fitWidth,),
                Padding(
                  padding:  EdgeInsets.only(left: 15,top: 10,right: 15,bottom: 10),
                  child: Text(data[index].title,style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 15,top: 10,right: 15,bottom: 10),
                  child: Text(data[index].des,style: TextStyle(color: Colors.black,fontSize: 13),),
                )
              ],
            );

          }))
        ],
      ),
    );
  }
}
