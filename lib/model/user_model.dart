class UserModel {
  final int id;
  final String bucode;
  final String percode;
  final String name;
  final String soflevelcode;
  final String sotdesc;
  final String branch;
  final String contactno;
  final String overrider;
  final String address;
  final String brId;
  final String regonid;
  final String zoneid;
  final String? pw;
  final String? status;

  UserModel({
    required this.id,
    required this.bucode,
    required this.percode,
    required this.name,
    required this.soflevelcode,
    required this.sotdesc,
    required this.branch,
    required this.contactno,
    required this.overrider,
    required this.address,
    required this.brId,
    required this.regonid,
    required this.zoneid,
    this.pw,
    this.status,
  });

  // Factory constructor for creating a UserModel from a JSON object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      bucode: json['bucode'],
      percode: json['percode'],
      name: json['name'],
      soflevelcode: json['soflevelcode'],
      sotdesc: json['sotdesc'],
      branch: json['branch'],
      contactno: json['contactno'],
      overrider: json['overrider'],
      address: json['address'],
      brId: json['brId'],
      regonid: json['regonid'],
      zoneid: json['zoneid'],
      pw: json['pw'],
      status: json['status'],
    );
  }

  // Method to convert the model back to JSON if needed
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bucode': bucode,
      'percode': percode,
      'name': name,
      'soflevelcode': soflevelcode,
      'sotdesc': sotdesc,
      'branch': branch,
      'contactno': contactno,
      'overrider': overrider,
      'address': address,
      'brId': brId,
      'regonid': regonid,
      'zoneid': zoneid,
      'pw': pw,
      'status': status,
    };
  }
}
