// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:xp_todo_app/screens/games_screen.dart';
import 'package:xp_todo_app/screens/main_todo_screen.dart';
import 'package:xp_todo_app/screens/profile_screen.dart';

import 'package:xp_todo_app/util/page_layout.dart';

// mainPage
Widget _buildMainPage_Todo(BuildContext context) => const MainTodoScreen();
Widget _buildMainPage_Games(BuildContext context) => const GamesScreen();
Widget _buildMainPage_Profile(BuildContext context) => const ProfileScreen();

const mainPageList = [
  PageData(
    'checkmark.square.fill',
    'Quests',
    CupertinoIcons.check_mark_circled_solid,
    _buildMainPage_Todo,
  ),
  PageData(
    'square.grid.2x2.fill',
    'Library',
    CupertinoIcons.square_grid_2x2_fill,
    _buildMainPage_Games,
  ),
  PageData(
    'person.crop.circle.fill',
    'Profile',
    CupertinoIcons.person,
    _buildMainPage_Profile,
  ),
];

const PageLayout mainPageLayout = PageLayout(
  id: 'MainPage',
  pageList: mainPageList,
  initialPage: 1,
);
