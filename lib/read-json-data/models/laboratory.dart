class Laboratory {
  const Laboratory({
    required this.id,
    required this.name,
    required this.phone,
    required this.isActive,
  });

  factory Laboratory.fromJson(Map<String, dynamic> json) {
    return Laboratory(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      isActive: json['is_active'],
    );
  }

  final int id;
  final String name;
  final String phone;
  final bool isActive;
}
