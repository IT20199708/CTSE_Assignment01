import 'package:cloud_firestore/cloud_firestore.dart';

class VolPostModel {
  String? id;
  String? thumbnailUrl;
  String? closingDate;
  DateTime? createdAt;
  String? createdBy;
  String? details;
  String? educationLevel;
  List<dynamic>? interest;
  String? phoneNo;
  String? searchTag;
  String? title;
  String? workLocation;
  String? contactEmail;
  String? userAvatar;

  VolPostModel(
      {
        required this.thumbnailUrl,
        required this.closingDate,
        required this.contactEmail,
        required this.workLocation,
        this.createdAt,
        required this.createdBy,
        required this.details,
        required this.educationLevel,
        required this.interest,
        required this.phoneNo,
        required this.searchTag,
        required this.title,
        required this.userAvatar
      });


  VolPostModel.addPost(
      this.thumbnailUrl,
      this.closingDate,
      this.contactEmail,
      this.workLocation,
      this.createdAt,
      this.createdBy,
      this.details,
      this.educationLevel,
      this.interest,
      this.phoneNo,
      this.searchTag,
      this.userAvatar,
      this.title);

  VolPostModel.fromJson(Map<String, dynamic> json, String id) {
    this.id = id;
    this.thumbnailUrl = json["thumbnailUrl"];
    this.closingDate = json["closingDate"] ;
    this.contactEmail = json["contactEmail"];
    this.workLocation = json["workLocation"];
    this.createdAt = (json["createdAt"] as Timestamp).toDate() ;
    this.createdBy = json["createdBy"];
    this.details = json["details"];
    this.educationLevel = json["educationLevel"];
    this.interest = json["interest"];
    this.phoneNo = json["phoneNo"];
    this.searchTag = json["searchTag"];
    this.title = json["title"];
    this.userAvatar = json["userAvatar"];
  }

  Map<String, dynamic> toJSON() => {
    'thumbnailUrl': this.thumbnailUrl,
    'closingDate': this.closingDate,
    'contactEmail': this.contactEmail,
    'workLocation': this.workLocation,
    'createdAt': this.createdAt,
    'createdBy': this.createdBy,
    'details': this.details,
    'educationLevel': this.educationLevel,
    'interest': this.interest,
    'phoneNo': this.phoneNo,
    'searchTag': this.searchTag,
    'title': this.title,
    'userAvatar': this.userAvatar,
  };
}
