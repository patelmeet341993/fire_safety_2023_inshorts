import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inshorts/controllers/user_controller.dart';
import 'package:inshorts/models/user_model.dart';

import '../../common/components/app_bar.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {

  List<UserModel> users = [];

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void getUsers() {
    print("get article");
    users.clear();
    setState(() {

    });
    firestore.collection("users1").get().then((value) {
      List<QueryDocumentSnapshot> documentSnapshot = value.docs;
      for (int i = 0; i < documentSnapshot.length; i++) {
        print("id ${documentSnapshot[i].id}");
        Map<dynamic, dynamic> map = documentSnapshot[i].data() as Map;
        users.add(UserModel.fromMap(map));
      //  users.add(UserModel.fromMap(map));users.add(UserModel.fromMap(map));
        print("article : $map");
      }
      setState(() {

      });
      print("users : ${users.length}");
    });
  }



  @override
  void initState() {
    super.initState();
    getUsers();
  }


  @override
  Widget build(BuildContext context) {

    return  SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            MyAppBar(
              title: "User list",
              color: Colors.white,
              backbtnVisible: true,
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (ctx, index) {
                    TextEditingController editor=TextEditingController();
                    editor.text=users[index].house;
                    return InkWell(
                      onTap: () {

                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Material(
                          elevation: 5,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text("Name : ${users[index].name}"),
                                Text("Mobile : ${users[index].mobile}"),
                                Text("Email : ${users[index].email}"),
                                Text("House : ${users[index].house}"),
                                TextField(
                                  controller:editor,
                                  decoration: InputDecoration(
                                    hintText: "Enter House Number"
                                  ),
                                ),
                                MaterialButton(onPressed: ()async{
                                  UserModel model=users[index];
                                  model.house=editor.text;
                                 bool uopdat=await UserController().updateUser(context, model);
                                  if(uopdat){
                                    getUsers();
                                  }
                                },child: Text("Update"),)
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),

          ],
        ),
      ),
    );
  }
}
