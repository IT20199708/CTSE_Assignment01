import 'package:cloud_firestore/cloud_firestore.dart';

class EduPostModel {
  String? id;
  String? thumbnailUrl;
  String? closingDate;
  String? contactEmail;
  String? courseDuration;
  num? courseFee;
  DateTime? createdAt;
  String? createdBy;
  String? details;
  String? educationLevel;
  List<dynamic>? interest;
  String? phoneNo;
  String? searchTag;
  String? title;
  String? userAvatar;

  EduPostModel(
      {required this.courseFee,
      required this.thumbnailUrl,
      required this.closingDate,
      required this.contactEmail,
      required this.courseDuration,
      this.createdAt,
      required this.createdBy,
      required this.details,
      required this.educationLevel,
      required this.interest,
      required this.phoneNo,
      required this.searchTag,
      required this.title,
      required this.userAvatar});

  EduPostModel.addPost(
      this.courseFee,
      this.thumbnailUrl,
      this.closingDate,
      this.contactEmail,
      this.courseDuration,
      this.createdAt,
      this.createdBy,
      this.details,
      this.educationLevel,
      this.interest,
      this.phoneNo,
      this.searchTag,
      this.title,
      this.userAvatar);

  EduPostModel.fromJson(Map<String, dynamic> json, String id) {
    this.id = id;
    this.courseFee = json["courseFee"];
    this.thumbnailUrl = json["thumbnailUrl"];
    this.closingDate = json["closingDate"];
    this.contactEmail = json["contactEmail"];
    this.courseDuration = json["courseDuration"];
    this.createdAt = (json["createdAt"] as Timestamp).toDate();
    this.createdBy = json["createdBy"];
    this.details = json["details"];
    this.educationLevel = json["educationLevel"];
    this.interest = json["interest"];
    this.phoneNo = json["phoneNo"];
    this.searchTag = json["searchTag"];
    this.title = json["title"];
    this.userAvatar = json['userAvatar'];
  }

  Map<String, dynamic> toJSON() => {
        'courseFee': this.courseFee,
        'thumbnailUrl': this.thumbnailUrl,
        'closingDate': this.closingDate,
        'contactEmail': this.contactEmail,
        'courseDuration': this.courseDuration,
        'createdAt': this.createdAt,
        'createdBy': this.createdBy,
        'details': this.details,
        'educationLevel': this.educationLevel,
        'interest': this.interest,
        'phoneNo': this.phoneNo,
        'searchTag': this.searchTag,
        'title': this.title,
        'userAvatar': this.userAvatar
      };
}
