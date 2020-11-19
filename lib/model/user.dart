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

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        //Factory method will be used to convert JSON objects that
        //are coming from querying the database and converting
        //it into an Ingredient object
        id: json['uid'],
        name: json['name'],
        image: json['image'],
        isMain: json['is_main'] == 0 ? false : true,
        houseID: json['house_id'],
      );

  // AppUser.fromJSON(Map<String, dynamic> json) {
  //   try {
  //     id = json['uid'].toString();
  //     name = json['name'] != null ? json['name'] : '';
  //     houseID = json['house_id'] != null ? json['house_id'] : '';
  //     image = json['image'] != null ? json['image'] : '';
  //   } catch (e) {
  //     print(e);
  //   }
  // }

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
