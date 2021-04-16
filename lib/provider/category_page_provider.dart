import 'package:flutter/material.dart';
import 'package:jd_app/model/category_content_model.dart';
import '../config/jd_api.dart';
import '../net/net_request.dart';

class CategoryProvider with ChangeNotifier {
  bool isLoading;
  bool isError;
  String errorMsg = "";
  List<String> categoryNavList = [];
  List<CategoryContentModel> categoryContentList = [];
  int tabIndex = 0;
//分类左侧
  loadCategoryPageData() {
    isLoading = true;
    isError = false;
    errorMsg = "";
    NetRequest().requestData(JdApi.CATEGORY_NAV).then((res) {
      //res是原函数中的this,包含,this.code,this.data,this.msg
      if (res.data is List) {
        for (var i = 0; i < res.data.length; i++) {
          categoryNavList.add(res.data[i]);
        }
        loadCategoryContentData(this.tabIndex);
      }
      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      print(error);
      errorMsg = error;
      isLoading = false;
      isError = true;
      notifyListeners();
    });
  }

//分类右侧
  loadCategoryContentData(int index) {
    this.tabIndex = index;
    isLoading = true;
    categoryContentList.clear();
    var data = {"title": categoryNavList[index]};

    NetRequest()
        .requestData(JdApi.CATEGORY_CONTENT, data: data, method: "post")
        .then((res) {
      isLoading = false;
      //res是原函数中的this,包含,this.code,this.data,this.msg
      if (res.data is List) {
        for (var item in res.data) {
          CategoryContentModel tmpModel = CategoryContentModel.fromJson((item));
          categoryContentList.add(tmpModel);
        }
      }
      print("名称:${categoryContentList[index].desc.length}");
      notifyListeners();
    }).catchError((error) {
      print(error);
      errorMsg = error;
      isLoading = false;
      isError = true;
      notifyListeners();
    });
    notifyListeners();
  }
}
