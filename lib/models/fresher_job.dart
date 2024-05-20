class FresherJob {
  final String title;
  final String company;
  final String panIndia;
  final String lpa;

  FresherJob({required this.title, required this.company, required this.panIndia, required this.lpa});

  factory FresherJob.fromJson(Map<String, dynamic> json) {
    return FresherJob(
      title: json['title'],
      company: json['company'],
      panIndia: json['panIndia'],
      lpa: json['lpa'],
    );
  }
}
