import 'package:equatable/equatable.dart';

class MainState extends Equatable {
  final int selectedIndex;

  const MainState({this.selectedIndex = 0});

  @override
  List<Object> get props => [selectedIndex];

  MainState copyWith({int? selectedIndex}) {
    return MainState(selectedIndex: selectedIndex ?? this.selectedIndex);
  }
}
