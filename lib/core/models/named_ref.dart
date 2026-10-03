import 'package:equatable/equatable.dart';

/// A `{id, name}` pair as the API returns for related records
/// (a category's laboratory or branch, for example).
class NamedRef extends Equatable {
  const NamedRef({required this.id, required this.name});

  factory NamedRef.fromJson(Map<String, dynamic> json) => NamedRef(
    id: (json['id'] as num?)?.toInt() ?? 0,
    name: json['name']?.toString() ?? '',
  );

  static NamedRef? maybeFrom(Object? value) => switch (value) {
    final Map<dynamic, dynamic> map => NamedRef.fromJson(
      Map<String, dynamic>.from(map),
    ),
    _ => null,
  };

  final int id;
  final String name;

  @override
  List<Object?> get props => <Object?>[id, name];
}
