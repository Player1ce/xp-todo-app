class RouteConstants {
  // Main tabs
  static const home = '/';
  static const login = '/login';
  static const gameLibrary = '/game_library';
  static const profile = '/profile';
  static const splash = '/splash';

  // Sub-pages
  static const settings = '/settings';
  static const gameView = '/library/:gameId';
  static const editProfile = '/profile/edit';

  static const adminPage = '/adminPage';

  // Helper to build parameterised paths
  static String gameViewPath(String gameId) => '/library/$gameId';
  static String questViewPath(String questId) => '/quest/$questId';
}
