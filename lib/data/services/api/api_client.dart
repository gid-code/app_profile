import 'dart:convert';
import 'dart:io';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:new_my_app/data/services/api/interceptors/auth_interceptor.dart';
import 'package:new_my_app/data/services/api/interceptors/default_headers.dart';
import 'package:new_my_app/data/services/api/interceptors/network_status_interceptor.dart';
import 'package:new_my_app/data/services/api/models/update_profile_request/update_profile_request.dart';
import 'package:new_my_app/utils/result.dart';

class ApiClient{
   String baseUrl = 'https://fixit-testing.tuulbox.app/api';

   InterceptedClient get httpClient => InterceptedClient.build(
    interceptors: [
      NetworkStatusInterceptor(),
      AuthInterceptor(),
      DefalutHeadersInterceptor()
    ],
  );

  Future<Result<void>> updateProfile(UpdateProfileRequest request) async {
    try {
      final response = await httpClient.patch(
        Uri.parse('$baseUrl/accounts/6d475484-c5d6-492d-98c7-27b0733806b1/'),
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return const Result.ok(null);
      } else {
        return const Result.error(HttpException('Failed to update profile'));
      }
    } on SocketException catch (e) {
      return Result.error(e);
    } catch (e) {
      return Result.error(Exception('An unexpected error occurred: ${e.toString()}'));
    }

  }

}