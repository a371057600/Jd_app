import 'package:flutter/material.dart';
import 'package:jd_app/config/jd_api.dart';
import 'package:jd_app/model/home_page_model.dart';
import 'package:jd_app/net/net_request.dart';

class HomePageProvider with ChangeNotifier {
  HomePageModel model;
  bool isLoading;
  bool isError;
  String errorMsg = "";

  loadHomePageData() {
    isLoading = true;
    isError = false;
    errorMsg = "";
    NetRequest().requestData(JdApi.HOME_PAGE).then((res) {
      //res是原函数中的this,包含,this.code,this.data,this.msg
      isLoading = false;
      if (res.code == 200) {
        model = HomePageModel.fromJson(res.data);
        // print(res.data["swipers"][2]["image"]);
      }
      notifyListeners();
    }).catchError((error) {
      print(error);
      errorMsg = error;
      isLoading = false;
      isError = true;
      notifyListeners();
    });
  }
}
