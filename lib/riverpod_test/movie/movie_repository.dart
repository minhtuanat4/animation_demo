import 'package:animation_demo/getx_demo/service/api_service.dart';
import 'package:animation_demo/riverpod_test/base_provider.dart';
import 'package:animation_demo/riverpod_test/model/return_model.dart';
import 'package:riverpod/riverpod.dart';

class MovieRepository {
  Future<ReturnModel> getMovies(Ref ref) async {
    final apiService = ref.read(apiServiceProvider);
    apiService.sendRequest(
        requestFromBaseUrl: RequestFromBaseUrl.requestFromVTCPay,
        requestMethod: RequestMethod.requestPost,
        requestPath: 'requestPath',
        params: {});
    await Future.delayed(Duration(milliseconds: 100));
    return ReturnModel('Minh Tuan', 1);
  }
}
