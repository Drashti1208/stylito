class UserProfileModel {
  String name;
  String email;
  String phone;
  String avatarUrl;
  String pincode;
  String address;
  String city;
  String state;
  String country;
  String bankAccountNumber;
  String accountHolderName;
  String ifscCode;

  UserProfileModel({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.avatarUrl = '',
    this.pincode = '',
    this.address = '',
    this.city = '',
    this.state = '',
    this.country = 'India',
    this.bankAccountNumber = '',
    this.accountHolderName = '',
    this.ifscCode = '',
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      avatarUrl: json['avatar_url']?.toString() ?? '',
      pincode: json['pincode']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      country: json['country']?.toString() ?? 'India',
      bankAccountNumber: json['bank_account_number']?.toString() ?? '',
      accountHolderName: json['account_holder_name']?.toString() ?? '',
      ifscCode: json['ifsc_code']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'avatar_url': avatarUrl,
      'pincode': pincode,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'bank_account_number': bankAccountNumber,
      'account_holder_name': accountHolderName,
      'ifsc_code': ifscCode,
    };
  }
}
