import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_ui_providers.g.dart';

enum TodoSegment { all, overdue, upcoming, undated }

@riverpod
class TodoFilter extends _$TodoFilter {
  @override
  TodoSegment build() => TodoSegment.all;

  void setSegment(TodoSegment segment) {
    state = segment;
  }
}
