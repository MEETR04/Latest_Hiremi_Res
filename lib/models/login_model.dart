class userModel {
  int? id;
  String? uid;
  String? fullName;
  String? fatherName;
  String? email;
  String? dateOfBirth;
  String? gender;
  String? address;
  String? phoneNumber;
  String? whatsappNumber;
  String? collegeState;
  String? collegeName;
  String? branchName;
  int? passingYear;
  String? password;
  bool? verified;
  int? otp;
  String? candidateStatus;
  String? paymentStatus;

  userModel(
      {this.id,
        this.uid,
        this.fullName,
        this.fatherName,
        this.email,
        this.dateOfBirth,
        this.gender,
        this.address,
        this.phoneNumber,
        this.whatsappNumber,
        this.collegeState,
        this.collegeName,
        this.branchName,
        this.passingYear,
        this.password,
        this.verified,
        this.otp,
        this.candidateStatus,
        this.paymentStatus});

  userModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    fullName = json['full_name'];
    fatherName = json['father_name'];
    email = json['email'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    address = json['address'];
    phoneNumber = json['phone_number'];
    whatsappNumber = json['whatsapp_number'];
    collegeState = json['college_state'];
    collegeName = json['college_name'];
    branchName = json['branch_name'];
    passingYear = json['passing_year'];
    password = json['password'];
    verified = json['verified'];
    otp = json['otp'];
    candidateStatus = json['candidate_status'];
    paymentStatus = json['payment_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['full_name'] = this.fullName;
    data['father_name'] = this.fatherName;
    data['email'] = this.email;
    data['date_of_birth'] = this.dateOfBirth;
    data['gender'] = this.gender;
    data['address'] = this.address;
    data['phone_number'] = this.phoneNumber;
    data['whatsapp_number'] = this.whatsappNumber;
    data['college_state'] = this.collegeState;
    data['college_name'] = this.collegeName;
    data['branch_name'] = this.branchName;
    data['passing_year'] = this.passingYear;
    data['password'] = this.password;
    data['verified'] = this.verified;
    data['otp'] = this.otp;
    data['candidate_status'] = this.candidateStatus;
    data['payment_status'] = this.paymentStatus;
    return data;
  }
}
