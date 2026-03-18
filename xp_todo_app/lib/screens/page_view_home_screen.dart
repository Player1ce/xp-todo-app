import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:xp_todo_app/const/page_view_configurations.dart';
import 'package:xp_todo_app/providers/auth_providers.dart';
import 'package:xp_todo_app/util/page_layout.dart';
import 'package:xp_todo_app/widgets/custom_page_view_navigation_bar.dart';

// providers
import 'package:xp_todo_app/providers/go_router_provider.dart';
import 'package:xp_todo_app/widgets/sign_in_required_widget.dart';

class PageViewHomeScreen extends ConsumerStatefulWidget {
  final PageLayout pageLayout;

  const PageViewHomeScreen({super.key, required this.pageLayout});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PageViewHomeScreenState();
}

class _PageViewHomeScreenState extends ConsumerState<PageViewHomeScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    debugPrint(
      "Initializing PageViewHomeScreen with pageLayout: ${widget.pageLayout.id}",
    );
    debugPrint(
      "GoRouterProvider state on init: ${ref.read(goRouterProvider).state.matchedLocation}",
    );
    int initialPageIndex = ref.read(
      goRouterProvider.select(
        (router) => widget.pageLayout.pageList.indexWhere(
          (pageData) => pageData.route == router.state.matchedLocation,
        ),
      ),
    );

    if (initialPageIndex == -1) {
      debugPrint(
        "Warning: Initial route ${ref.read(goRouterProvider).state.matchedLocation} not found in pageLayout ${widget.pageLayout.id}. Defaulting to initialPage ${widget.pageLayout.initialPage}",
      );
      initialPageIndex = widget.pageLayout.initialPage;
    }

    _pageController = PageController(initialPage: initialPageIndex);

    // ref
    //     .read(goRouterProvider)
    //     .routeInformationProvider
    //     .addListener(_onRouteChanged);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    // setState(() => _currentIndex = index);
    if (context.mounted) {
      context.go(widget.pageLayout[index].route);
    }
  }

  void _onNavTap(int index) {
    // setState(() => _currentIndex = index);
    // switchPageViewPage(index);
    if (context.mounted) {
      context.go(widget.pageLayout[index].route);
    }
  }

  void switchPageViewPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    final location = GoRouterState.of(context).matchedLocation;
    final locationIndex = widget.pageLayout.routes.indexOf(location);
    debugPrint(
      "Current index: $_currentIndex, GoRouter location: $location, matched index in pageLayout: $locationIndex",
    );
    if (locationIndex != -1 && locationIndex != _currentIndex) {
      // Valid tab route changed externally — sync state and controller
      debugPrint(
        "Syncing PageView to new location index: $locationIndex for route: $location",
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        debugPrint(
          "Post frame callback: syncing PageView to index: $locationIndex for route: $location",
        );
        if (!mounted) {
          debugPrint("context not mounted, skipping page sync");
          return;
        }
        setState(() => _currentIndex = locationIndex);
        switchPageViewPage(locationIndex);
      });
    }

    return authState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => SignInRequiredWidget(
        message: "Failed to load user. Please sign in again.",
      ),
      data: (user) {
        if (user == null) {
          return SignInRequiredWidget(
            message: 'Please sign in to view your library.',
          );
        }
        return AdaptiveScaffold(
          extendBodyBehindAppBar: true,
          body: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            // (index) {
            //   ref
            //       .read(goRouterProvider)
            //       .go(widget.pageLayout.pageList[index].route);
            // },
            children: widget.pageLayout.pageList
                .map((pageData) => pageData.builder(context))
                .toList(),
          ),
          bottomNavigationBar: getCustomPageViewNavigationBar(
            context,
            ref,
            _onNavTap,
            mainPageLayout,
            _currentIndex,
          ),
        );
      },
    );
  }
}

// NOTE: a pageView.builder edition for reference

// PageView.builder(
//   itemBuilder: (context, index) =>
//       widget.pageLayout[index].builder(context),
//   onPageChanged: (index) {
//     ref
//         .read(
//           pageIndexProvider(
//             widget.pageLayout.id,
//             widget.pageLayout.initialPage,
//           ).notifier,
//         )
//         .setPage(index);
//   },
//   controller: _pageController,
// ),
