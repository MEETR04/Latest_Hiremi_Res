class FresherJobModel {
  int? id;
  String? jobProfile;
  String? jobLocation;
  String? jobCodeRequired;
  int? jobCode;
  String? companyName;
  String? jobCtc;
  String? education;
  String? skillsRequired;
  String? AboutCompany;
  String? jobDescription;
  String? termsAndConditions;

  FresherJobModel(
      {this.id,
        this.jobProfile,
        this.jobLocation,
        this.jobCodeRequired,
        this.jobCode,
        this.companyName,
        this.jobCtc,
        this.AboutCompany,
        this.education,
        this.skillsRequired,
        this.jobDescription,
        this.termsAndConditions});

  FresherJobModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobProfile = json['job_profile'];
    jobLocation = json['job_location'];
    jobCodeRequired = json['job_code_required'];
    jobCode = json['job_code'];
    companyName = json['company_name'];
    jobCtc = json['job_ctc'];
    education = json['education'];
    skillsRequired = json['skills_required'];
    jobDescription = json['job_description'];
    termsAndConditions = json['terms_and_conditions'];
    AboutCompany=json['About_company'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['job_profile'] = this.jobProfile;
    data['job_location'] = this.jobLocation;
    data['job_code_required'] = this.jobCodeRequired;
    data['job_code'] = this.jobCode;
    data['company_name'] = this.companyName;
    data['job_ctc'] = this.jobCtc;
    data['education'] = this.education;
    data['skills_required'] = this.skillsRequired;
    data['job_description'] = this.jobDescription;
    data['terms_and_conditions'] = this.termsAndConditions;
    data['About_company']=this.AboutCompany;
    return data;
  }
}

/// id : 1
/// job_profile : "as"
/// job_location : "as"
/// job_code_required : "Yes"
/// job_code : 1234
/// company_name : "crtd"
/// job_ctc : "3.00"
/// education : "assa"
/// skills_required : "dccd"
/// job_description : "cc"
/// terms_and_conditions : "xcxc"

// class FresherJobModel {
//   FresherJobList({
//     num? id,
//     String? jobProfile,
//     String? jobLocation,
//     String? jobCodeRequired,
//     num? jobCode,
//     String? companyName,
//     String? jobCtc,
//     String? education,
//     String? skillsRequired,
//     String? jobDescription,
//     String? termsAndConditions,}){
//     _id = id;
//     _jobProfile = jobProfile;
//     _jobLocation = jobLocation;
//     _jobCodeRequired = jobCodeRequired;
//     _jobCode = jobCode;
//     _companyName = companyName;
//     _jobCtc = jobCtc;
//     _education = education;
//     _skillsRequired = skillsRequired;
//     _jobDescription = jobDescription;
//     _termsAndConditions = termsAndConditions;
//   }
//
//   FresherJobModel.fromJson(dynamic json) {
//     _id = json['id'];
//     _jobProfile = json['job_profile'];
//     _jobLocation = json['job_location'];
//     _jobCodeRequired = json['job_code_required'];
//     _jobCode = json['job_code'];
//     _companyName = json['company_name'];
//     _jobCtc = json['job_ctc'];
//     _education = json['education'];
//     _skillsRequired = json['skills_required'];
//     _jobDescription = json['job_description'];
//     _termsAndConditions = json['terms_and_conditions'];
//   }
//   num? _id;
//   String? _jobProfile;
//   String? _jobLocation;
//   String? _jobCodeRequired;
//   num? _jobCode;
//   String? _companyName;
//   String? _jobCtc;
//   String? _education;
//   String? _skillsRequired;
//   String? _jobDescription;
//   String? _termsAndConditions;
//   FresherJobModel copyWith({  num? id,
//     String? jobProfile,
//     String? jobLocation,
//     String? jobCodeRequired,
//     num? jobCode,
//     String? companyName,
//     String? jobCtc,
//     String? education,
//     String? skillsRequired,
//     String? jobDescription,
//     String? termsAndConditions,
//   }) => FresherJobList(  id: id ?? _id,
//     jobProfile: jobProfile ?? _jobProfile,
//     jobLocation: jobLocation ?? _jobLocation,
//     jobCodeRequired: jobCodeRequired ?? _jobCodeRequired,
//     jobCode: jobCode ?? _jobCode,
//     companyName: companyName ?? _companyName,
//     jobCtc: jobCtc ?? _jobCtc,
//     education: education ?? _education,
//     skillsRequired: skillsRequired ?? _skillsRequired,
//     jobDescription: jobDescription ?? _jobDescription,
//     termsAndConditions: termsAndConditions ?? _termsAndConditions,
//   );
//   num? get id => _id;
//   String? get jobProfile => _jobProfile;
//   String? get jobLocation => _jobLocation;
//   String? get jobCodeRequired => _jobCodeRequired;
//   num? get jobCode => _jobCode;
//   String? get companyName => _companyName;
//   String? get jobCtc => _jobCtc;
//   String? get education => _education;
//   String? get skillsRequired => _skillsRequired;
//   String? get jobDescription => _jobDescription;
//   String? get termsAndConditions => _termsAndConditions;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['job_profile'] = _jobProfile;
//     map['job_location'] = _jobLocation;
//     map['job_code_required'] = _jobCodeRequired;
//     map['job_code'] = _jobCode;
//     map['company_name'] = _companyName;
//     map['job_ctc'] = _jobCtc;
//     map['education'] = _education;
//     map['skills_required'] = _skillsRequired;
//     map['job_description'] = _jobDescription;
//     map['terms_and_conditions'] = _termsAndConditions;
//     return map;
//   }
//
// }