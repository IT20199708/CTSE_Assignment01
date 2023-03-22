import 'package:cloud_firestore/cloud_firestore.dart';

class DonPostModel {
  String? id;
  String? thumbnailUrl;
  DateTime? createdAt;
  String? createdBy;
  String? details;
  List<dynamic>? interest;
  String? phoneNo;
  String? searchTag;
  String? title;
  String? contactEmail;
  String? userAvatar;

  DonPostModel(
      {
        required this.thumbnailUrl,
        required this.contactEmail,
        this.createdAt,
        required this.createdBy,
        required this.details,
        required this.interest,
        required this.phoneNo,
        required this.searchTag,
        required this.title,
        required this.userAvatar
      });


  DonPostModel.addPost(
      this.thumbnailUrl,
      this.contactEmail,
      this.createdAt,
      this.createdBy,
      this.details,
      this.interest,
      this.phoneNo,
      this.searchTag,
      this.title,
      this.userAvatar
      );

  DonPostModel.fromJson(Map<String, dynamic> json, String id) {
    this.id = id;
    this.thumbnailUrl = json["thumbnailUrl"];
    this.contactEmail = json["contactEmail"];
    this.createdAt = (json["createdAt"] as Timestamp).toDate() ;
    this.createdBy = json["createdBy"];
    this.details = json["details"];
    this.interest = json["interest"];
    this.phoneNo = json["phoneNo"];
    this.searchTag = json["searchTag"];
    this.title = json["title"];
    this.userAvatar = json["userAvatar"];
  }

  Map<String, dynamic> toJSON() => {
    'thumbnailUrl': this.thumbnailUrl,
    'contactEmail': this.contactEmail,
    'createdAt': this.createdAt,
    'createdBy': this.createdBy,
    'details': this.details,
    'interest': this.interest,
    'phoneNo': this.phoneNo,
    'searchTag': this.searchTag,
    'title': this.title,
    'userAvatar': this.userAvatar
  };
}
