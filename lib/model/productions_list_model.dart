class ProductionsList {
  int code;
  String msg;
  List<Data> data;

  ProductionsList({this.code, this.msg, this.data});

  ProductionsList.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      // ignore: deprecated_member_use
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['data'] = this.data.map((v) => v.toJson()).toList();
    return data;
  }
}

class Data {
  String id;
  String cover;
  String title;
  String price;
  String comment;
  String rate;

  Data({this.id, this.cover, this.title, this.price, this.comment, this.rate});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cover = json['cover'];
    title = json['title'];
    price = json['price'];
    comment = json['comment'];
    rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cover'] = this.cover;
    data['title'] = this.title;
    data['price'] = this.price;
    data['comment'] = this.comment;
    data['rate'] = this.rate;
    return data;
  }
}
