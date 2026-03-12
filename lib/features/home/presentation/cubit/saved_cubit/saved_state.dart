import 'package:equatable/equatable.dart';

enum SavedPageState {initial, loading, success, failure}

class SavedState extends Equatable {
  final SavedPageState savedPageState;
  final String? errorMessage;
  const SavedState({required this.savedPageState, this.errorMessage});

  SavedState copyWith({SavedPageState? savedPageState, String? errorMessage}) {
    return SavedState(savedPageState: savedPageState ?? this.savedPageState, errorMessage: errorMessage ?? this.errorMessage);
  }

  factory SavedState.initial() {
    return SavedState(savedPageState: SavedPageState.initial);
  }

  @override
  List<Object?> get props => [savedPageState, errorMessage];
}