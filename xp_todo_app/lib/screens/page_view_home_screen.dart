import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xp_todo_app/const/page_view_configurations.dart';
import 'package:xp_todo_app/util/page_layout.dart';
import 'package:xp_todo_app/widgets/custom_page_view_navigation_bar.dart';

// providers
import 'package:xp_todo_app/providers/go_router_provider.dart';

class PageViewHomeScreen extends ConsumerStatefulWidget {
  final PageLayout pageLayout;

  const PageViewHomeScreen({super.key, required this.pageLayout});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PageViewHomeScreenState();
}

class _PageViewHomeScreenState extends ConsumerState<PageViewHomeScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.pageLayout.initialPage,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void switchPageViewPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
    ref.read(goRouterProvider).go(widget.pageLayout.pageList[index].route);
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      extendBodyBehindAppBar: true,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          ref
              .read(goRouterProvider)
              .go(widget.pageLayout.pageList[index].route);
        },
        children: widget.pageLayout.pageList
            .map((pageData) => pageData.builder(context))
            .toList(),
      ),
      bottomNavigationBar: getCustomPageViewNavigationBar(
        context,
        ref,
        switchPageViewPage,
        mainPageLayout,
      ),
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
