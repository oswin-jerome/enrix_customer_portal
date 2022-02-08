class Customer {
  Customer(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.dob,
      this.email,
      this.mobile,
      this.phone,
      this.currentAddress,
      this.city,
      this.state,
      this.zipcode,
      this.timeOfContact,
      this.modeOfContact,
      this.idProof,
      this.profileImage,
      this.customerId});

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        city: json['city'],
        createdAt: json['created_at'],
        currentAddress: json['current_address'],
        dob: json['dob'],
        email: json['email'],
        id: json['id'],
        idProof: json['idProof'],
        mobile: json['mobile'],
        modeOfContact: json['mode_of_contact'],
        name: json['name'],
        phone: json['phone'],
        state: json['state'],
        timeOfContact: json['time_of_contact'],
        zipcode: json['zipcode'],
        profileImage: json['profile_image'],
        customerId: json['unique_id'],
      );

  int? id;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? dob;
  String? email;
  String? mobile;
  String? phone;
  String? currentAddress;
  String? city;
  String? state;
  String? zipcode;
  String? timeOfContact;
  String? modeOfContact;
  String? idProof;
  String? profileImage;
  String? customerId;
}
