import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inshorts/models/Article.dart';
import 'package:inshorts/screens/home_screen/screens/add_file.dart';

import '../../common/components/app_bar.dart';

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({Key? key}) : super(key: key);

  @override
  State<HomePageAdmin> createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
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
    print("get article");
    data.clear();
    setState(() {

    });
    firestore.collection(topic).get().then((value) {
      List<QueryDocumentSnapshot> documentSnapshot = value.docs;
      for (int i = 0; i < documentSnapshot.length; i++) {
        print("id ${documentSnapshot[i].id}");
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
            title: "Fire Safety Admin App",
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

                      if(selectedItem!=index) {
                        getArticles(topics[index]);
                        selectedItem = index;

                        setState(() {});
                      }
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
              child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (ctx, index) {
                    return Container(
                      height: 160,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width:100,
                            child: CachedNetworkImage(
                              imageUrl: data[index].img,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data[index].title,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  data[index].des,
                                  maxLines: 3,
                                  style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                                ),
                                SizedBox(height: 5,),
                                InkWell(
                                  onTap: (){

                                    print("id : ${data[index].id}");

                                    firestore.collection(topics[selectedItem]).doc(data[index].id).delete().then((value) {
                                      getArticles(topics[selectedItem]);
                                    });


                                  },
                                  child: Container(
                                    color: Colors.red,
                                    padding: EdgeInsets.all(10),
                                    child: Text("Delete"),
                                  ),
                                )
                              ],
                            ),
                          ),


                        ],
                      ),
                    );
                  }))
        ],
      ),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add),onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (ctx)=>AddFile()));
      },)
    );
  }
}
