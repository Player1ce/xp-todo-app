import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xp_todo_app/providers/auth_providers.dart';

part 'quest_ui_providers.g.dart';

@Riverpod(keepAlive: true)
class SelectedQuestGameId extends _$SelectedQuestGameId {
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

enum QuestSegment { all, overdue, upcoming, undated }

@riverpod
class QuestFilter extends _$QuestFilter {
  @override
  QuestSegment build() => QuestSegment.all;

  void setSegment(QuestSegment segment) {
    state = segment;
  }
}
