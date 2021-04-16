import 'package:flutter/material.dart';
import '../model/product_detail_model.dart';
import '../config/jd_api.dart';
import 'package:jd_app/net/net_request.dart';

class ProductDetailProvider with ChangeNotifier {
  ProductDetailModel model;
  bool isLoading;
  bool isError;
  String errorMsg = "";

  loadProduct({String id}) {
    isLoading = true;
    isError = false;
    errorMsg = "";

    NetRequest().requestData(JdApi.PRODUCTIONS_DETAIL).then((res) {
      //res是原函数中的this,包含,this.code,this.data,this.msg
      isLoading = false;
      if (res.code == 200 && res.data is List) {
        // print(res.data);
        for (var item in res.data) {
          ProductDetailModel tmpModel = ProductDetailModel.fromJson(item);
          // print(tmpModel.partData);
          if (tmpModel.partData.id == id) {
            model = tmpModel;
            // print("白条${model.baitiao[1].select}");
          }
        }
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

  //分期切换
  void changeBaitiaoSelected(int index) {
    // print("44行model：$model");
    // print("45行this.model：${this.model}");
    if (this.model.baitiao[index].select == false) {
      for (int i = 0; i < model.baitiao.length; i++) {
        if (i == index) {
          this.model.baitiao[i].select = true;
        } else {
          this.model.baitiao[i].select = false;
        }
      }

      notifyListeners();
    }
  }

  //数量赋予
  void changeProductCount(int count) {
    if (count > 0 && this.model.partData.count != count) {
      this.model.partData.count = count;
      notifyListeners();
    }
  }
}
