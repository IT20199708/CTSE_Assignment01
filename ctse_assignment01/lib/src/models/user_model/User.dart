class UserModel {
  String? firstName;
  String? lastName;
  String? ContactNo;
  String? Email;
  String? Address;
  String? imgUrl;
  String? userRole;

  bool? newUser = true;
  List<dynamic>? offeringAreas;


  UserModel(
      {this.firstName,
       this.lastName,
       this.ContactNo,
       this.Email,
       this.Address,
      this.imgUrl,
      this.userRole = 'org',
      this.newUser = true,
      this.offeringAreas});

  UserModel.fromJson(Map<String, dynamic> json) {
    firstName = json["firstName"];
    lastName = json["lastName"];
    ContactNo = json["ContactNo"];
    Email = json["Email"];
    Address = json["Address"];
    imgUrl = json["imgUrl"];
    userRole = json["userRole"];
    newUser = json["newUser"];
    offeringAreas = json["offeringAreas"];
  }



  Map<String, dynamic> toJSON() => {
        'firstName': this.firstName,
        'lastName': this.firstName,
        'ContactNo': this.ContactNo,
        'Email': this.Email,
        'Address': this.Address,
        'imgUrl': this.imgUrl,
        'userRole': this.userRole,
        'newUser': this.newUser,
        'offeringAreas': this.offeringAreas
      };
}
