class ApplicationStatus {
  int? id;
  String? userEmail;
  String? jobProfile;
  String? applicationDate;
  bool? accept;

  ApplicationStatus(
      {this.id,
        this.userEmail,
        this.jobProfile,
        this.applicationDate,
        this.accept});

  ApplicationStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userEmail = json['user_email'];
    jobProfile = json['job_profile'];
    applicationDate = json['application_date'];
    accept = json['accept'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_email'] = this.userEmail;
    data['job_profile'] = this.jobProfile;
    data['application_date'] = this.applicationDate;
    data['accept'] = this.accept;
    return data;
  }
}
