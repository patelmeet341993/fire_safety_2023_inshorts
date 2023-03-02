import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inshorts/models/Article.dart';

import '../../common/components/app_bar.dart';
import 'dart:io' as io;

class AddFile extends StatefulWidget {
  const AddFile({Key? key}) : super(key: key);

  @override
  State<AddFile> createState() => _AddFileState();
}

class _AddFileState extends State<AddFile> {
  List<dynamic> topics = [];

  int selectedItem = 0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Article> data = [];
 // XFile? file;
  TextEditingController title = TextEditingController();
  TextEditingController des = TextEditingController();
  bool isUploading = false;

  getTopics() {
    firestore.collection("admin").doc("data").get().then((value) {
      Map<dynamic, dynamic> data = value.data() as Map;
      topics = data["topic1"];

      selectedItem = 0;
      // getArticles(topics[0]);

      setState(() {});
    });
  }

  void addArticles(String topic) {
    print("add article");
  }

  @override
  void initState() {
    super.initState();
    getTopics();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            MyAppBar(
              title: "Add data ",
              color: Colors.white,
              backbtnVisible: true,
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
                        if (selectedItem != index) {
                          //    getArticles(topics[index]);
                          selectedItem = index;

                          setState(() {});
                        }
                      },
                      child: Container(
                        height: 34,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: selectedItem != index
                              ? Colors.blue
                              : Colors.indigo,
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
            Text("Title"),
            TextField(
              controller: title,
              maxLength: 150,
            ),
            Text("Description"),
            TextField(
              controller: des,
              minLines: 5,
              maxLines: 6,
              maxLength: 400,
            ),
            // Visibility(
            //   visible: file == null,
            //   child: InkWell(
            //     onTap: () async {
            //       file = await ImagePicker()
            //           .pickImage(source: ImageSource.gallery);
            //       setState(() {});
            //     },
            //     child: Container(
            //       padding: EdgeInsets.all(10),
            //       color: Colors.grey,
            //       child: Text("Select File"),
            //     ),
            //   ),
            // ),
            Visibility(
              visible: !isUploading,
              child: InkWell(
                onTap: () async {
                  isUploading = true;
                  setState(() {});
                  String strtitle = title.text;
                  String strdes = des.text;

                  if (strtitle.isEmpty || strdes.isEmpty) return;

                  try {
                    // Reference ref = FirebaseStorage.instance
                    //     .ref()
                    //     .child('images')
                    //     .child('/${file!.name}');
                    //
                    // TaskSnapshot task = await ref.putFile(io.File(file!.path));
                    // String url = await task.ref.getDownloadURL();

                    Map<String, dynamic> data = HashMap();
                    data["img"] = "";
                    data["title"] = strtitle;
                    data["des"] = strdes;
                    data["created"]=FieldValue.serverTimestamp();

                    firestore
                        .collection(topics[selectedItem])
                        .doc()
                        .set(data)
                        .then((value) {

                      title.text = "";
                      des.text = "";
                      setState(() {
                        isUploading = false;
                      });
                    });
                  } catch (e) {
                    print("error : $e");
                  }

                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.grey,
                  child: Text("Upload"),
                ),
              ),
            ),
            Visibility(
                visible: isUploading,
                child: SpinKitCircle(color: Colors.indigo,))
          ],
        ),
      ),
    );
  }
}
