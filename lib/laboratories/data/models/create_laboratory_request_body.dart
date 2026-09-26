class CreateLaboratoryRequestBody {
  const CreateLaboratoryRequestBody({required this.lang, required this.name});

  final String lang;
  final String name;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'lang': lang,
    'name': name,
  };
}
