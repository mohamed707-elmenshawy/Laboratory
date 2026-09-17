class Branch {
  final int id;
  final String name;
  final String? address;
  final bool isMain;
  final String? managerName;

  const Branch({
    required this.id,
    required this.name,
    this.address,

    required this.isMain,
    this.managerName,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'],
      name: json['name'],
      isMain: json['is_main'] as bool? ?? false,
      managerName: json['manager_name'],
      address: json['address'],
    );
  }
}
