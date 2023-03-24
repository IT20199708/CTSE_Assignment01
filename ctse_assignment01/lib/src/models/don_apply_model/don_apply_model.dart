import 'package:cloud_firestore/cloud_firestore.dart';

class DonApplyModel {
  String? id;
  DateTime? createdAt;
  String? name;
  String? phoneNo;
  String? contactEmail;
  String? message;
  double? cardNumber;
  String? cvv;
  String? expDate;
  String? postTitle;
  String? userId;
  double? donationAmount;

  DonApplyModel(
      {
        this.id,
        this.createdAt,
        required this.name,
        required this.phoneNo,
        required this.contactEmail,
        required this.postTitle,
        required this.message,
        required this.cardNumber,
        required this.cvv,
        required this.expDate,
        this.userId,
        this.donationAmount,
      });

  DonApplyModel.addPost(
      this.createdAt,
      this.name,
       this.phoneNo,
       this.contactEmail,
       this.postTitle,
       this.message,
       this.cardNumber,
       this.cvv,
       this.expDate,
       this.donationAmount,
      this.userId);

  DonApplyModel.fromJson(Map<String, dynamic> json, String id) {
    this.id = id;
    this.contactEmail = json["contactEmail"];
    this.name = json["name"];
    this.createdAt = (json["createdAt"] as Timestamp).toDate();
    this.phoneNo = json["phoneNo"];
    this.userId = json["userId"];
    this.postTitle = json["postTitle"];
    this.message = json["message"];
    this.cardNumber = json["cardNumber"];
    this.cvv = json["cvv"];
    this.expDate = json["expDate"];
    this.donationAmount = json["donationAmount"];

  }

  Map<String, dynamic> toJSON() => {
    'contactEmail': this.contactEmail,
    'createdAt': this.createdAt,
    'phoneNo': this.phoneNo,
    'name': this.name,
    'userId': this.userId,
    'postTitle': this.postTitle,
    'message': this.message,
    'cardNumber': this.cardNumber,
    'cvv': this.cvv,
    'expDate': this.expDate,
    'donationAmount': this.donationAmount,
  };
}
