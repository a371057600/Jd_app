import 'package:flutter/material.dart';
import 'package:jd_app/model/product_info_model.dart';
import '../config/jd_api.dart';
import 'package:jd_app/net/net_request.dart';

class ProductListProvider with ChangeNotifier {
  ProductListProvider model;
  bool isLoading;
  bool isError;
  String errorMsg = "";
  List<ProductInfoModel> list = [];
  loadProductList() {
    isLoading = true;
    isError = false;
    errorMsg = "";

    NetRequest().requestData(JdApi.PRODUCTIONS_LIST).then((res) {
      //res是原函数中的this,包含,this.code,this.data,this.msg
      isLoading = false;
      // print(res.data);
      if (res.code == 200 && res.data is List) {
        for (var item in res.data) {
          ProductInfoModel tmpModel = ProductInfoModel.fromJson(item);
          list.add(tmpModel);
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
}
