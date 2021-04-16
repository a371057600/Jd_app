import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jd_app/page/product_list_page.dart';
import 'package:jd_app/provider/product_list_provider.dart';
import '../model/category_content_model.dart';
import 'package:provider/provider.dart';
import '../provider/category_page_provider.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    // NetRequest();

    return ChangeNotifierProvider<CategoryProvider>(
        create: (context) {
          var provider = new CategoryProvider();
          provider.loadCategoryPageData();
          return provider;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text("分类页面"),
            ),
            body: Container(
              color: Color(0xFFf4f4f4),
              child: Consumer<CategoryProvider>(builder: (_, provider, __) {
                print(provider.isLoading);
                //加载动画
                if (provider.isLoading &&
                    provider.categoryNavList.length == 0) {
                  return Center(child: CupertinoActivityIndicator());
                }
                //捕获异常
                if (provider.isError) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(provider.errorMsg),
                      OutlinedButton(
                        child: Text("刷新"),
                        onPressed: () {
                          provider.loadCategoryPageData();
                        },
                      )
                    ],
                  ));
                }

                // print(model.toJson());
                return Row(
                  children: <Widget>[
                    //分类左侧
                    buildNavLeftContainer(provider),
                    //分类右侧
                    Expanded(
                        child: Stack(
                      children: [
                        buildCategoryContent(provider.categoryContentList),
                        provider.isLoading
                            ? Center(
                                child: CupertinoActivityIndicator(),
                              )
                            : Container()
                      ],
                    ))
                  ],
                );
              }),
            )));
  }

//右侧商品
  Widget buildCategoryContent(List<CategoryContentModel> contentList) {
    List<Widget> list = [];
    //处理title
    for (var i = 0; i < contentList.length; i++) {
      list.add(Container(
        height: 30.0,
        margin: const EdgeInsets.only(left: 10.0, top: 10.0),
        child: Text(
          "${contentList[i].title}",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
      ));
      List<Widget> descList = [];
      for (var j = 0; j < contentList[i].desc.length; j++) {
        descList.add(InkWell(
          child: Container(
            width: 60.0,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Image.asset(
                  "assets${contentList[i].desc[j].img}",
                  width: 50,
                  height: 50,
                ),
                Text("${contentList[i].desc[j].text}")
              ],
            ),
          ),
          onTap: () {
            // 前往商品页面
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ChangeNotifierProvider<ProductListProvider>(
                      create: (context) {
                        ProductListProvider provider = ProductListProvider();
                        provider.loadProductList();
                        return provider;
                      },
                      child: Consumer<ProductListProvider>(
                        builder: (_, provider, __) {
                          return Container(
                            child: ProductListPage(
                              title: contentList[i].desc[j].text,
                            ),
                          );
                        },
                      ),
                    )));
          },
        ));
      }
      list.add(Padding(
        padding: const EdgeInsets.all(15.0),
        child: Wrap(
          spacing: 22.0,
          runSpacing: 10.0,
          alignment: WrapAlignment.start,
          children: descList,
        ),
      ));
    }
    // 将descList追加到list数据中

    return Container(
      width: double.infinity,
      color: Colors.white,
      child: ListView(
        children: list,
      ),
    );
  }

//分类左侧
  Container buildNavLeftContainer(CategoryProvider provider) {
    return Container(
        width: 90,
        child: ListView.builder(
            itemCount: provider.categoryNavList.length,
            itemBuilder: (context, index) {
              return InkWell(
                child: Container(
                    padding: EdgeInsets.only(top: 15),
                    color: provider.tabIndex == index
                        ? Colors.white
                        : Color(0xFFF8F8F8),
                    height: 50,
                    child: Text(
                      provider.categoryNavList[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: provider.tabIndex == index
                              ? Color(0xFFe93b3d)
                              : Color(0xFF333333),
                          fontWeight: FontWeight.w500),
                    )),
                onTap: () {
                  // print("147行$index");
                  // print("148行的测试结果：${index > 1 ? "超出范围了！" : index}");
                  provider.loadCategoryContentData(index > 1 ? 1 : index);
                },
              );
            }));
  }
}
