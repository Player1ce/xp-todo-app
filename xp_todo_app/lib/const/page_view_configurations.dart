// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:xp_todo_app/screens/my_demo_home_screen.dart';

import 'package:xp_todo_app/util/page_layout.dart';

// mainPage
Widget _buildMainPage_HomePage(BuildContext context) =>
    MyDemoHomePage(title: "Title");
Widget _buildMainPage_HomePage2(BuildContext context) =>
    MyDemoHomePage(title: "Title2");

const mainPageList = [
  PageData(
    "gearshape.fill",
    "Settings",
    CupertinoIcons.settings,
    _buildMainPage_HomePage,
  ),
  PageData(
    "house.fill",
    "Home",
    CupertinoIcons.house,
    _buildMainPage_HomePage2,
  ),
  PageData(
    "person.fill",
    "Profile",
    CupertinoIcons.person,
    _buildMainPage_HomePage,
  ),
];

const PageLayout mainPageLayout = PageLayout(
  id: 'MainPage',
  pageList: mainPageList,
  initialPage: 1,
);
