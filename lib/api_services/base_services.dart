import 'dart:convert';
import 'dart:developer';

import 'package:hiremi/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BaseService {
  Future<String?> getStoredCSRFToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('csrfToken');
  }

  // Future getHttp(String api) async {
  //   final url = ApiUrls.registration;
  //   log(url, name: 'getHttp');
  //
  //   final response = await http.get(
  //     Uri.parse(url),
  //     headers: {
  //       'content-type': 'application/json',
  //       //  'Host': 'suraj.ojha20145@gmail.com',
  //     },
  //   );
  //
  //   return response;
  // }
  Future getHttp(String api) async {
    final url = api;
    log(url, name: 'getHttp');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'content-type': 'application/json',
         'Host': 'suraj.ojha20145@gmail.com',
      },
    );

    return response;
  }
  Future<http.Response> postHttp({required String api, required Map<String, dynamic> data,})
  async {
    final url = api;
    log(url, name: 'postHttp');
    final body = json.encode(data);

    final csrfToken = await getStoredCSRFToken();
    print(csrfToken);
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Cookie': csrfToken.toString(),
        'X-CSRFToken': csrfToken.toString(),
      },
      body: utf8.encode(body),
    );

    return response;
  }
}
class ApiUrls {
  // static const baseUrl = 'http://15.206.79.74:8000/api/';

  static const registration = 'http://13.127.81.177:8000/api/registers/';
  static const corporatetraining= "http://13.127.81.177:8000/api/corporatetraining/";
  static const forgetPaassword = 'http://13.127.81.177:8000/forgot-password/';
  static const otpValidation = 'http://13.127.81.177:8000/otp-validation/';
  static const passwordReset = 'http://13.127.81.177:8000/password-reset/';
  static const verificationDetails ='http://13.127.81.177:8000/verification-details/';
  static const fresherJobs = 'http://13.127.81.177:8000/api/fresherjob/';
  static const jobApplication = 'http://13.127.81.177:8000/job-applications/';
  static const verifiedEmails="http://13.127.81.177:8000/verified-emails/";
  static const mentorship="http://13.127.81.177:8000/api/mentorship/";
  static const payments="http://13.127.81.177:8000/api/payments/";
  static const baseurl="http://13.127.81.177:8000/";
// static const posts = 'registers/';
}