import 'dart:convert';
import 'dart:developer';

import 'package:hiremi/api_services/base_services.dart';
import 'package:hiremi/models/application_status_model.dart';
import 'package:hiremi/models/fresher_job_model.dart';
import 'package:hiremi/models/login_model.dart';
import 'package:http/http.dart';
import 'package:hiremi/models/fresher_job_model.dart';



class UserService extends BaseService {

  Future<Response> createPostApi( Map<String, dynamic> body,  String apiUrl)
  async
  {
    final response = await postHttp( data: body,api: apiUrl);

    log(response.body);

    return response;
  }
  List<FresherJobModel> fresherJobList = [];

  Future<List<FresherJobModel>> getJobListApi() async {
    try {
      final response = await getHttp(ApiUrls.fresherJobs);
      var data = jsonDecode(response.body.toString());
      log(response.body, name: 'getJobListApi');
      if (response.statusCode == 200) {
        for (Map<String, dynamic> i in data) {
          fresherJobList.add(FresherJobModel.fromJson(i));
        }
        print(fresherJobList.toString());
        return fresherJobList;
      } else {
        print("${response.statusCode}");
        return fresherJobList;
      }
    } catch (e, s) {


      log(e.toString(), name: 'error getJobListApi', stackTrace: s);
      return []; // or throw an exception based on your error handling
    }
  }
  jobCodeRequired(int id) {
    for (FresherJobModel user in fresherJobList) {
      if (user.id == id) {
        return user.jobCodeRequired;
      }
    }
  }
  jobcode(int id) {
    for (FresherJobModel user in fresherJobList) {
      if (user.id == id) {
        return user.jobCode;
      }
    }
  }
  List<ApplicationStatus> applicationList = [];

  Future<List<ApplicationStatus>> getApplicationStatus() async {
    try {
      final response = await getHttp(ApiUrls.jobApplication);
      var data = jsonDecode(response.body.toString());
      log(response.body, name: 'getJobListApi');
      if (response.statusCode == 200) {
        for (Map<String, dynamic> i in data) {
          applicationList.add(ApplicationStatus.fromJson(i));
        }
        print(applicationList.toString());
        return applicationList;
      } else {
        return applicationList;
      }
    } catch (e, s) {
      log(e.toString(), name: 'error getJobListApi', stackTrace: s);
      return []; // or throw an exception based on your error handling
    }
  }


}

