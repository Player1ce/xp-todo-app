import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'page_view_providers.g.dart';

@riverpod
class PageIndex extends _$PageIndex {
  @override
  int build(String id, int initialPage) {
    return initialPage;
  }

  void setPage(int page) {
    state = page;
  }
}
