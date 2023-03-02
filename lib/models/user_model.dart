import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id = "", name = "", image = "", mobile = "", email = "",type="sop",house="";
  Timestamp? createdTime;

  UserModel();

  UserModel.fromMap(Map<dynamic, dynamic> map) {
    id = map['id']?.toString() ?? "";
    name = map['name']?.toString() ?? "";
    image = map['image']?.toString() ?? "";
    mobile = map['mobile']?.toString() ?? "";
    email = map['email']?.toString() ?? "";
    type=map["type"]?.toString()??"";
    house=map["house"]?.toString()??"";
    createdTime = map['createdTime'];
  }

  void updateFromMap(Map<String, dynamic> map) {
    id = map['id']?.toString() ?? "";
    name = map['name']?.toString() ?? "";
    image = map['image']?.toString() ?? "";
    mobile = map['mobile']?.toString() ?? "";
    email = map['email']?.toString() ?? "";
    house=map["house"]?.toString()??"";
    type=map["type"]?.toString()??"";
    createdTime = map['createdTime'];
  }

  Map<String, dynamic> tomap() {
    return {
      "id" : id,
      "name" : name,
      "image" : image,
      "mobile" : mobile,
      "email" : email,
      "createdTime" : createdTime,
      "type":type,
      "house":house
    };
  }

  @override
  String toString() {
    return "id:${id}, name:$name, image:$image, mobile:$mobile, email:$email, createdTime:$createdTime";
  }
}