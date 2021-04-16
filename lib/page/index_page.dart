import 'package:flutter/material.dart';
import '../page/home_page.dart';
import '../page/user_page.dart';
import '../page/category_page.dart';
import '../page/cart_page.dart';

import '../provider/bottom_navi_provider.dart';
import 'package:provider/provider.dart';

class IndexPage extends StatefulWidget {
  IndexPage({Key key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          Consumer<BottomNaviProvider>(builder: (_, mProvider, __) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: mProvider.bottomNaviIndex,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "首页",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: "分类",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: "购物车",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: "用户",
            ),
          ],
          onTap: (index) {
            mProvider.changeBottomNaviIndex(index);
          },
        );
      }),
      body: Consumer<BottomNaviProvider>(
        builder: (_, mProvider, __) => IndexedStack(
          index: mProvider.bottomNaviIndex,
          children: <Widget>[
            HomePage(),
            CategoryPage(),
            CartPage(),
            UserPage(),
          ],
        ),
      ),
    );
  }
}
