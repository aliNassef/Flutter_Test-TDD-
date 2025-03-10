import 'package:dio/dio.dart';
import 'network_service.dart';

class NetworkServiceImpl implements NetworkService {
  final dio = Dio();
  @override
  Future<Response> get(String url) async {
    final response = await dio.get(url);
    return response;
  }

  @override
  Future<Response> post(String url, dynamic body) async {
    final response = await dio.post(url, data: body);
    return response;
  }
}
