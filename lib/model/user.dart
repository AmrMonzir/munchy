class AppUser {
  String id;
  String name;
  String image;
  String houseID;
  bool isMain;

  AppUser({
    this.name,
    this.id,
    this.houseID,
    this.image,
    this.isMain,
  });

  AppUser.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['uid'].toString();
      name = jsonMap['name'] != null ? jsonMap['name'] : '';
      houseID = jsonMap['house_id'] != null ? jsonMap['house_id'] : '';
      image = jsonMap['image'] != null ? jsonMap['image'] : '';
      isMain = jsonMap['is_main'] == 0 ? false : true;
    } catch (e) {
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["uid"] = id;
    map["name"] = name;
    map["image"] = image;
    map["house_id"] = houseID;
    map["is_main"] = isMain == false ? 0 : 1;
    return map;
  }
}
