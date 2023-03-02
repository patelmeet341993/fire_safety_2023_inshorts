import 'package:cloud_firestore/cloud_firestore.dart';

class Article{

  String id = "", title = "", des = "", img = "";
  Timestamp? craeted;


  Article();

  Article.fromMap(Map<dynamic, dynamic> map,String ids) {
    id = ids;
    title = map['title']?.toString() ?? "";
    des = map['des']?.toString() ?? "";
    img = map['img']?.toString() ?? "";
    craeted=map["created"]??null;

  }


}