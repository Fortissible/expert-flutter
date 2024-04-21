import 'package:equatable/equatable.dart';

class GenreEntities extends Equatable {
  const GenreEntities({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  @override
  List<Object> get props => [id, name];
}
