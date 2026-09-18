class UpdateProfileRequestBody {
  const UpdateProfileRequestBody({required this.name});

  final String name;

  Map<String, dynamic> toJson() => <String, dynamic>{'name': name};
}
