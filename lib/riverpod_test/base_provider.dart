import 'package:animation_demo/getx_demo/service/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'base_provider.g.dart';

@riverpod
ApiService apiService(ApiServiceRef ref) {
  return ApiService();
}
