import 'package:dio/dio.dart';
import 'package:laboratory/test/repo/laboratoryt_response.dart';

class LaboratorytRepo {
  final Dio _dio;
  LaboratorytRepo(this._dio);

  Future<LaboratorytResponse> getLabt() async {
    final resposne = await _dio.get('laboratories');

    LaboratorytResponse laboratorytResponse = LaboratorytResponse.fromJson(
      resposne.data,
    );
    print('___________________________________________________________12');

    print(laboratorytResponse.items[0].name);
    print('___________________________________________________________12');
    return laboratorytResponse;
  }
}
