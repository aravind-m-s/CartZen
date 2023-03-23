class UserModel {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final bool status;
  final int wallet;
  final List whishlist;
  final List address;
  final List recents;

  UserModel({
    required this.id,
    this.name = '',
    this.email = '',
    this.mobile = '',
    this.status = true,
    this.wallet = 0,
    this.whishlist = const [],
    this.address = const [],
    this.recents = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
      status: json['status'],
      wallet: json['wallet'],
      whishlist: json['whishlist'],
      address: json['address'],
      recents: json['recents'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'mobile': mobile,
        'status': status,
        'wallet': wallet,
        'whishlist': whishlist,
        'address': address,
        'recents': recents,
      };
}
