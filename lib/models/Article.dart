class Article{

  String id = "", title = "", des = "", img = "";


  Article();

  Article.fromMap(Map<dynamic, dynamic> map,String ids) {
    id = ids;
    title = map['title']?.toString() ?? "";
    des = map['des']?.toString() ?? "";
    img = map['img']?.toString() ?? "";
  }


}