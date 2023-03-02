import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inshorts/models/Article.dart';
import 'package:inshorts/utils/styles.dart';
import 'package:timelines/timelines.dart';

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
      topics = data["topic1"];
      selectedItem = 0;
      getArticles(topics[0]);
      setState(() {});
    });
  }

  void getArticles(String topic) {
    data.clear();
    setState(() {

    });
    firestore.collection(topic).orderBy("created").get().then((value) {

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
            title: "Socity on Palm",
            color: Styles.primaryColor,
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
          Expanded(
              child: Timeline.tileBuilder(
                builder: TimelineTileBuilder.fromStyle(
                  contentsAlign: ContentsAlign.alternating,
                  contentsBuilder: (context, index) => Container(

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SizedBox(width: 10,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data[index].title,
                                maxLines: 4,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                data[index].des,
                                maxLines: 8,
                                style:
                                TextStyle(color: Colors.black, fontSize: 13),
                              ),
                              SizedBox(height: 5,),
                              Text(
                                data[index].craeted!.toDate().toString(),
                                maxLines: 1,
                                style:
                                TextStyle(color: Colors.black, fontSize: 10),
                              ),
                            ],
                          ),
                        ),


                      ],
                    ),
                  ),
                  itemCount: data.length,
                ),
              ))
        ],
      ),
    );
  }
}
