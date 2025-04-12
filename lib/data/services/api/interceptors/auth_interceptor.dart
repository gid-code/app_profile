import 'dart:async';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:new_my_app/data/services/shared_preferences_service.dart';
import 'package:new_my_app/utils/result.dart';

class AuthInterceptor implements InterceptorContract {

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    if (request.headers.containsKey('No-Authentication')) return request;
    
    final token = await SharedPreferencesService().fetchToken().then((result) {
      switch (result) {
        case Ok():
          return result.value;
        case Error():
          return null;
      }
    });

    if (token != null){
      request.headers['Authorization'] = 'Bearer $token';
    }

    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({required BaseResponse response}) async {
    if (response.statusCode == 401) {
      // Handle 401 Unauthorized response
      // Navigate to login screen
      // navigatorKey.currentState?.pushReplacementNamed('/login');
    }

    return response;
  }
  
  @override
  FutureOr<bool> shouldInterceptRequest() {
    return true;
  }
  
  @override
  FutureOr<bool> shouldInterceptResponse() {
    return true;
  }
}