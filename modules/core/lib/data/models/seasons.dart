import 'package:equatable/equatable.dart';

class Seasons extends Equatable{
  Seasons({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  List<String> expandedValue;
  String headerValue;
  bool isExpanded;

  @override
  List<Object?> get props => [
    expandedValue, headerValue, isExpanded
  ];
}