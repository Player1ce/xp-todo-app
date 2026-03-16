class RouteConstants {
  // Main tabs
  static const home = '/';
  static const login = '/login';
  static const gameLibrary = '/game_library';
  static const profile = '/profile';

  // Sub-pages
  static const settings = '/settings';
  static const gameView = '/library/:gameId';
  static const editProfile = '/profile/edit';

  // Helper to build parameterised paths
  static String gameViewPath(String gameId) => '/library/$gameId';
}
