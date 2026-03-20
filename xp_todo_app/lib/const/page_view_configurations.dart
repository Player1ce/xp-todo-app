// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:xp_todo_app/const/route_constants.dart';
import 'package:xp_todo_app/screens/games_screen.dart';
import 'package:xp_todo_app/screens/quest_screen.dart';
import 'package:xp_todo_app/screens/profile_screen.dart';

import 'package:xp_todo_app/util/page_layout.dart';

// mainPage
Widget _buildMainPage_Games(BuildContext context) => const GamesScreen();
Widget _buildMainPage_Quest(BuildContext context) => const QuestScreen();
Widget _buildMainPage_Profile(BuildContext context) => const ProfileScreen();

const mainPageList = [
  PageData(
    route: RouteConstants.gameLibrary,
    iconString: 'square.grid.2x2.fill',
    label: 'Library',
    iconData: CupertinoIcons.square_grid_2x2_fill,
    builder: _buildMainPage_Games,
  ),
  PageData(
    route: RouteConstants.home,
    iconString: 'checkmark.square.fill',
    label: 'Quests',
    iconData: CupertinoIcons.check_mark_circled_solid,
    builder: _buildMainPage_Quest,
  ),
  PageData(
    route: RouteConstants.profile,
    iconString: 'person.crop.circle.fill',
    label: 'Profile',
    iconData: CupertinoIcons.person,
    builder: _buildMainPage_Profile,
  ),
];

const PageLayout mainPageLayout = PageLayout(
  id: 'MainPage',
  pageList: mainPageList,
  initialPage: 1,
);
