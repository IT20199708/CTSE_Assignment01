import 'package:cloud_firestore/cloud_firestore.dart';

class EduApplyModel {
  String? id;
  DateTime? createdAt;
  String? name;
  String? phoneNo;
  String? educationLevel;
  String? contactEmail;
  String? userId;
  String? postTitle;

  EduApplyModel(
      {this.createdAt,
      required this.name,
      required this.phoneNo,
      required this.educationLevel,
      required this.contactEmail,
        required this.postTitle,
      this.userId});

  EduApplyModel.addPost(
      this.createdAt,
      this.name,
      this.phoneNo,
      this.educationLevel,
      this.postTitle,
      this.contactEmail,
      this.userId);

  EduApplyModel.fromJson(Map<String, dynamic> json, String id) {
    this.id = id;
    this.contactEmail = json["contactEmail"];
    this.name = json["name"];
    this.createdAt = (json["createdAt"] as Timestamp).toDate();
    this.phoneNo = json["phoneNo"];
    this.educationLevel = json["educationLevel"];
    this.userId = json["userId"];
    this.postTitle = json["postTitle"];
  }

  Map<String, dynamic> toJSON() => {
        'contactEmail': this.contactEmail,
        'createdAt': this.createdAt,
        'phoneNo': this.phoneNo,
        'name': this.name,
        'educationLevel': this.educationLevel,
        'userId': this.userId,
        'postTitle': this.postTitle
      };
}
