import 'package:cloud_firestore/cloud_firestore.dart';

class VolApplyModel {
  String? id;
  DateTime? createdAt;
  String? name;
  String? phoneNo;
  String? educationLevel;
  String? contactEmail;
  String? address;
  double? expectedSalary;
  String? aboutYou;
  String? userId;
  String? postTitle;

  VolApplyModel(
      { this.id,
        this.createdAt,
        required this.name,
        required this.phoneNo,
        required this.educationLevel,
        required this.contactEmail,
        required this.postTitle,
        required this.address,
        required this.expectedSalary,
        required this.aboutYou,
        this.userId});

  VolApplyModel.addPost(
      this.createdAt,
      this.name,
      this.phoneNo,
      this.educationLevel,
      this.contactEmail,
      this.address,
      this.expectedSalary,
      this.aboutYou,
      this.postTitle,
      this.userId);

  VolApplyModel.fromJson(Map<String, dynamic> json, String id) {
    this.id = id;
    this.contactEmail = json["contactEmail"];
    this.name = json["name"];
    this.createdAt = (json["createdAt"] as Timestamp).toDate();
    this.phoneNo = json["phoneNo"];
    this.educationLevel = json["educationLevel"];
    this.userId = json["userId"];
    this.postTitle = json["postTitle"];
    this.address = json["address"];
    this.expectedSalary = json["expectedSalary"];
    this.aboutYou = json["aboutYou"];;

  }

  Map<String, dynamic> toJSON() => {
    'contactEmail': this.contactEmail,
    'createdAt': this.createdAt,
    'phoneNo': this.phoneNo,
    'name': this.name,
    'educationLevel': this.educationLevel,
    'userId': this.userId,
    'postTitle': this.postTitle,
    'address': this.address,
    'expectedSalary': this.expectedSalary,
    'aboutYou': this.aboutYou
  };
}
