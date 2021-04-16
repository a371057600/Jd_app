import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:jd_app/model/home_page_model.dart';
import '../provider/home_page_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // NetRequest();

    return ChangeNotifierProvider<HomePageProvider>(
        create: (context) {
          var provider = new HomePageProvider();
          provider.loadHomePageData();
          return provider;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text("首页"),
            ),
            body: Container(
              color: Color(0xFFf4f4f4),
              child: Consumer<HomePageProvider>(builder: (_, provider, __) {
                print(provider.isLoading);
                //加载动画
                if (provider.isLoading) {
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
                          provider.loadHomePageData();
                        },
                      )
                    ],
                  ));
                }
                HomePageModel model = provider.model;
                Image itemBuildrMethod(BuildContext context, int index) {
                  return Image.asset("assets${model.swipers[index].image}");
                }

                // print(model.toJson());
                return ListView(
                  children: <Widget>[
                    //轮播图
                    buildAspectRatio(model, itemBuildrMethod),
                    //图标分类
                    buildLogos(model),
                    //掌上秒杀头部
                    buildMSHeaderContainer(),
                    //掌上秒杀商品
                    buildGoodMSContainer(model),
                    //广告1
                    buildAds(model.pageRow.ad1),
                    //广告2
                    buildAds(model.pageRow.ad2),
                  ],
                );
                // return Container();
              }),
            )));
  }

//logos轮播图
  Container buildLogos(HomePageModel model) {
    List<Widget> list = [];
    //遍历model中的logos数组
    for (var i = 0; i < model.logos.length; i++) {
      list.add(Container(
          width: 60,
          child: Column(
            children: <Widget>[
              Image.asset(
                "assets${model.logos[i].image}",
                width: 50,
                height: 50,
              ),
              Text("${model.logos[i].title}"),
            ],
          )));
    }
    return Container(
      color: Colors.white,
      height: 170,
      padding: EdgeInsets.all(20),
      child: Wrap(
        spacing: 7,
        runSpacing: 10,
        alignment: WrapAlignment.spaceEvenly,
        children: list,
      ),
    );
  }

// 广告
  Widget buildAds(List<String> ads) {
    List<Widget> list = [];
    for (var i = 0; i < ads.length; i++) {
      list.add(Expanded(
        child: Image.asset("assets${ads[i]}"),
      ));
    }
    return Row(
      children: list,
    );
  }

//商品秒杀
  Container buildGoodMSContainer(HomePageModel model) {
    return Container(
      height: 120,
      color: Colors.white,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: model.quicks.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "assets${model.quicks[index].image}",
                    width: 85,
                    height: 85,
                  ),
                  Text(
                    "${model.quicks[index].price}",
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  )
                ],
              ),
            );
          }),
    );
  }

//掌上秒杀头部
  Container buildMSHeaderContainer() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Image.asset(
            "assets/image/bej.png",
            width: 90,
            height: 20,
          ),
          Spacer(),
          Text("更多秒杀"),
          Icon(
            CupertinoIcons.right_chevron,
            size: 14,
          )
        ],
      ),
      color: Colors.white,
      height: 50,
    );
  }

//掌上秒杀商品

  AspectRatio buildAspectRatio(HomePageModel model,
      Image itemBuildrMethod(BuildContext context, int index)) {
    return AspectRatio(
      aspectRatio: 72 / 35,
      child: Swiper(
        itemCount: model.swipers.length,
        pagination: SwiperPagination(),
        autoplay: true,
        itemBuilder: itemBuildrMethod,
        duration: 800,
      ),
    );
  }
}
