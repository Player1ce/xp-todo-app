import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/gestures.dart';
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

    _currentIndex = initialPageIndex;
    _pageController = PageController(initialPage: initialPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
    }

    if (!context.mounted) {
      return;
    }

    final targetRoute = widget.pageLayout[index].route;
    final currentRoute = GoRouterState.of(context).matchedLocation;
    if (currentRoute != targetRoute) {
      context.go(targetRoute);
    }
  }

  void _onNavTap(int index) {
    if (index != _currentIndex) {
      _pageController.jumpToPage(index);
    }

    if (!context.mounted) {
      return;
    }

    final targetRoute = widget.pageLayout[index].route;
    final currentRoute = GoRouterState.of(context).matchedLocation;
    if (currentRoute != targetRoute) {
      context.go(targetRoute);
    }
  }

  void switchPageViewPage(int index, [milliseconds = 200]) {
    if (!_pageController.hasClients) {
      return;
    }

    final currentPage = _pageController.page;
    if (currentPage != null && (currentPage - index).abs() < 0.01) {
      return;
    }

    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: milliseconds),
      curve: Curves.easeOutCubic,
    );
  }

  // TODO: idk if this actually works. testing in progress
  ScrollPhysics _pagePhysics(BuildContext context) {
    final platform = Theme.of(context).platform;
    final isApplePlatform =
        platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;

    if (isApplePlatform) {
      return const BouncingScrollPhysics(parent: PageScrollPhysics());
    }

    return const PageScrollPhysics();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    final int locationIndex = ref.watch(
      goRouterProvider.select(
        (router) => widget.pageLayout.pageList.indexWhere(
          (pageData) => pageData.route == router.state.matchedLocation,
        ),
      ),
    );
    if (locationIndex != -1 && locationIndex != _currentIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }

        setState(() => _currentIndex = locationIndex);

        if (!_pageController.hasClients) {
          return;
        }

        final currentPage = _pageController.page;
        if (currentPage == null || (currentPage - locationIndex).abs() > 0.01) {
          _pageController.jumpToPage(locationIndex);
        }
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
            physics: _pagePhysics(context),
            dragStartBehavior: DragStartBehavior.start,
            pageSnapping: true,
            allowImplicitScrolling: false,
            children: widget.pageLayout.pageList
                .map((pageData) => pageData.builder(context))
                .toList(growable: false),
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
