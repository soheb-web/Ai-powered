import 'dart:convert';

JobDetailModel jobDetailModelFromJson(String str) =>
    JobDetailModel.fromJson(json.decode(str));

String jobDetailModelToJson(JobDetailModel data) =>
    json.encode(data.toJson());

class JobDetailModel {
  final bool status;
  final String message;
  final Data data;

  JobDetailModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory JobDetailModel.fromJson(Map<String, dynamic> json) => JobDetailModel(
    status: json["status"] ?? false,
    message: json["message"] ?? "",
    data: Data.fromJson(json["data"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  final int id;
  final String title;
  final String company;
  final String? description;
  final List<String>? requirements; // Changed from String? to List<String>?
  final String? location;
  final String? salaryRange;
  final String? employmentType;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? minExperience;
  final int? maxExperience;
  final String? salaryMin; // Changed to String? to match JSON
  final String? salaryMax; // Changed to String? to match JSON
  final DateTime? postedDate;
  final DateTime? applicationDeadline;
  final int? employerId;

  Data({
    required this.id,
    required this.title,
    required this.company,
    this.description,
    this.requirements,
    this.location,
    this.salaryRange,
    this.employmentType,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.minExperience,
    this.maxExperience,
    this.salaryMin,
    this.salaryMax,
    this.postedDate,
    this.applicationDeadline,
    this.employerId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"] ?? 0,
    title: json["title"] ?? "",
    company: json["company"] ?? "",
    description: json["description"],
    requirements: json["requirements"] != null
        ? (json["requirements"] is List
        ? List<String>.from(json["requirements"].map((x) => x.toString()))
        : [json["requirements"].toString()])
        : null,
    location: json["location"],
    salaryRange: json["salary_range"],
    employmentType: json["employment_type"],
    status: json["status"],
    createdAt: json["created_at"] != null
        ? DateTime.tryParse(json["created_at"])
        : null,
    updatedAt: json["updated_at"] != null
        ? DateTime.tryParse(json["updated_at"])
        : null,
    minExperience: json["min_experience"],
    maxExperience: json["max_experience"],
    salaryMin: json["salary_min"]?.toString(), // Convert to String
    salaryMax: json["salary_max"]?.toString(), // Convert to String
    postedDate: json["posted_date"] != null
        ? DateTime.tryParse(json["posted_date"])
        : null,
    applicationDeadline: json["application_deadline"] != null
        ? DateTime.tryParse(json["application_deadline"])
        : null,
    employerId: json["employer_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "company": company,
    "description": description,
    "requirements": requirements,
    "location": location,
    "salary_range": salaryRange,
    "employment_type": employmentType,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "min_experience": minExperience,
    "max_experience": maxExperience,
    "salary_min": salaryMin,
    "salary_max": salaryMax,
    "posted_date": postedDate?.toIso8601String(),
    "application_deadline": applicationDeadline?.toIso8601String(),
    "employer_id": employerId,
  };
}