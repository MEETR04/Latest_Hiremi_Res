class InternshipJobModel {
  int? id;
  String? InternshipProfile;
  String? InternshipLocation;
  String? InternshipCodeRequired;
  int? InternshipCode;
  String? companyName;
  String? InternshipCtc;
  String? education;
  String? skillsRequired;
  String? InternshipDescription;
  String? termsAndConditions;

  InternshipJobModel(
      {this.id,
        this.InternshipProfile,
        this.InternshipLocation,
        this.InternshipCodeRequired,
        this.InternshipCode,
        this.companyName,
        this.InternshipCtc,
        this.education,
        this.skillsRequired,
        this.InternshipDescription,
        this.termsAndConditions});

  InternshipJobModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    InternshipProfile = json['Internship_profile'];
    InternshipLocation = json['Internship_location'];
    InternshipCodeRequired = json['Internship_code_required'];
    InternshipCode = json['Internship_code'];
    companyName = json['company_name'];
    InternshipCtc = json['Internship_ctc'];
    education = json['education'];
    skillsRequired = json['skills_required'];
    InternshipDescription = json['Internship_description'];
    termsAndConditions = json['terms_and_conditions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Internship_profile'] = this.InternshipProfile;
    data['Internship_location'] = this.InternshipLocation;
    data['Internship_code_required'] = this.InternshipCodeRequired;
    data['Internship_code'] = this.InternshipCode;
    data['company_name'] = this.companyName;
    data['Internship_ctc'] = this.InternshipCtc;
    data['education'] = this.education;
    data['skills_required'] = this.skillsRequired;
    data['job_description'] = this.InternshipDescription;
    data['terms_and_conditions'] = this.termsAndConditions;
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