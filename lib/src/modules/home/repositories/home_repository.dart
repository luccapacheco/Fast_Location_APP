import 'package:dio/dio.dart';

class HomeRepository {
  final Dio _dio = Dio();

  Future<Response> getAddressViaCep(String cep) async {
    try {
      final response = await _dio.get('https://viacep.com.br/ws/$cep/json/');
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}
