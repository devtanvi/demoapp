import 'dart:ffi';

class Address {
  String? country;
  String? name;
  String? phone;
  String? add1;
  String? add2;
  String? landmark;
  String? pinCode;
  String? city;
  String? state;
  Bool?isEdit;
  Address({
    this.country,
    this.name,
    this.phone,
    this.add1,
    this.add2,
    this.landmark,
    this.pinCode,
    this.city,
    this.state,
    this.isEdit
  });

  // Add a toJson method to serialize the Address to a Map
  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'name': name,
      'phone': phone,
      'add1': add1,
      'add2': add2,
      'landmark': landmark,
      'pinCode': pinCode,
      'city': city,
      'state': state,
      'isEdit':isEdit
    };
  }

  // Add a factory method to create an Address object from a JSON Map
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      country: json['country'],
      name: json['name'],
      phone: json['phone'],
      add1: json['add1'],
      add2: json['add2'],
      landmark: json['landmark'],
      pinCode: json['pinCode'],
      city: json['city'],
      state: json['state'],
      isEdit: json['isEdit'],
    );
  }
}
