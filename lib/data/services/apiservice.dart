import 'dart:convert';
import 'package:http/http.dart' as http;

class Apiservice {

  String url = 'https://fixit-testing.tuulbox.app/api/accounts/6d475484-c5d6-492d-98c7-27b0733806b1/';

  Future<http.Response> updateProfile(String firtname,
  String lastname, String address) async {
    final response = await http.patch(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzQ0ODEwODQ3LCJpYXQiOjE3NDQyMDYwNDcsImp0aSI6ImMwOTdiMjQxOWFiYTRhOWNhZmI3NThlODE5MzUwNWE1IiwidXNlcl9pZCI6IjZkNDc1NDg0LWM1ZDYtNDkyZC05OGM3LTI3YjA3MzM4MDZiMSJ9.5rbz-kYzy3HiSs-VizQd38L21oIbxyNWJM0NXgkgYKE'
      },
      body: jsonEncode({
        'firstName': firtname,
        'lastName': lastname,
        'address': address,
      }),
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load data');
    }
  }

}