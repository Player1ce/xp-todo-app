import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xp_todo_app/providers/auth_providers.dart';

part 'todo_ui_providers.g.dart';

@Riverpod(keepAlive: true)
class SelectedTodoGameId extends _$SelectedTodoGameId {
  @override
  String? build() {
    ref.watch(activeUserIdProvider);
    state = null;
    return null;
  }

  // Mutate state + save to persistent storage
  void updateValue(String newValue) {
    if (state == newValue) return;
    state = newValue;
  }
}

class PageState {
  const PageState({required this.value, this.counter = 0});
  final String value;
  final int counter;

  PageState copyWith({String? value, int? counter}) =>
      PageState(value: value ?? this.value, counter: counter ?? this.counter);

  Map<String, dynamic> toJson() => {'value': value, 'counter': counter};
  factory PageState.fromJson(Map<String, dynamic> json) =>
      PageState(value: json['value'], counter: json['counter']);
}

enum TodoSegment { all, overdue, upcoming, undated }

@riverpod
class TodoFilter extends _$TodoFilter {
  @override
  TodoSegment build() => TodoSegment.all;

  void setSegment(TodoSegment segment) {
    state = segment;
  }
}
