class UserModel {
  final int id;
  final String name;
  final bool isActive;
  UserModel({required this.name, required this.id, required this.isActive});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      isActive: json['is_active'],
    );
  }

  @override
  String toString() => 'UserModel(id: $id, name: $name, isActive: $isActive)';
}
