class Client {
  final String id;
  final String name;
  final String nic;
  final String address;
  final String mobile;
  final String typeOfInsurance;
  final String presentInsurer;
  final int spouseAge;
  final int noOfFamilyMembers;
  final int noOfChild;
  final String statusType;
  final int monthlyIncome;
  final int monthlyExpenses;
  final String remark;
  final String createdBy;
  final String createdDateTime;
  final String modifiedBy;
  final String modifiedDateTime;
  final String branchId;
  final String regionId;

  Client({
    required this.id,
    required this.name,
    required this.nic,
    required this.address,
    required this.mobile,
    required this.typeOfInsurance,
    required this.presentInsurer,
    required this.spouseAge,
    required this.noOfFamilyMembers,
    required this.noOfChild,
    required this.statusType,
    required this.monthlyIncome,
    required this.monthlyExpenses,
    required this.remark,
    required this.createdBy,
    required this.createdDateTime,
    required this.modifiedBy,
    required this.modifiedDateTime,
    required this.branchId,
    required this.regionId,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      name: json['name'],
      nic: json['nic'],
      address: json['address'],
      mobile: json['mobile'],
      typeOfInsurance: json['typeOfInsurance'],
      presentInsurer: json['presentInsurer'],
      spouseAge: json['spouseAge'],
      noOfFamilyMembers: json['noOfFamilyMembers'],
      noOfChild: json['noOfChild'],
      statusType: json['statusType'],
      monthlyIncome: json['monthlyIncome'],
      monthlyExpenses: json['monthlyExpences'],
      remark: json['remark'],
      createdBy: json['createdBy'],
      createdDateTime: json['createdDateTime'],
      modifiedBy: json['modifiedBy'],
      modifiedDateTime: json['modifiedDateTime'],
      branchId: json['branchId'],
      regionId: json['regionId'],
    );
  }
}
