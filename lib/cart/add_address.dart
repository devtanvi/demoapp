import 'dart:convert';
import 'dart:ffi';
import 'package:demoapp/cart/address_model.dart';
import 'package:demoapp/cart/select_address.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAddress extends StatefulWidget {
  final Address? addressToEdit;

  AddAddress({
    super.key,
    required this.addressToEdit,
  });

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  bool isEditing = false;

  Future<List<Address>> loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final addressesJson = prefs.getStringList('addresses') ?? [];

    return addressesJson.map((addressJson) {
      final addressMap = json.decode(addressJson);
      return Address(
        country: addressMap['country'],
        name: addressMap['name'],
        phone: addressMap['phone'],
        add1: addressMap['add1'],
        add2: addressMap['add2'],
        landmark: addressMap['landmark'],
        pinCode: addressMap['pinCode'],
        city: addressMap['city'],
        state: addressMap['state'],
      );
    }).toList();
  }

  Future<void> saveAddresses(List<Address> addresses) async {
    final prefs = await SharedPreferences.getInstance();
    final addressesJson = addresses.map((address) {
      return json.encode({
        'country': address.country,
        'name': address.name,
        'phone': address.phone,
        'add1': address.add1,
        'add2': address.add2,
        'landmark': address.landmark,
        'pinCode': address.pinCode,
        'city': address.city,
        'state': address.state,
      });
    }).toList();
    await prefs.setStringList('addresses', addressesJson);
  }

  void saveAddress() async {
    isEditing = false;
    if (_formKey.currentState!.validate()) {
      Address newAddress = Address(
        country: countryDropDown,
        name: nameController.text,
        phone: phoneController.text,
        add1: add1Controller.text,
        add2: add2Controller.text,
        landmark: landmarkController.text,
        pinCode: pinCodeController.text,
        city: cityController.text,
        state: stateDropDownValue,
      );
      List<Address> existingAddresses = await loadAddresses();
      existingAddresses.add(newAddress);
      saveAddresses(existingAddresses);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SelectAddress()),
      );
    }
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController add1Controller = TextEditingController();
  final TextEditingController add2Controller = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  var mobileFocus = FocusNode();
  var nameFocus = FocusNode();
  var phoneFocus = FocusNode();
  var add1Focus = FocusNode();
  var add2Focus = FocusNode();
  var landmarkFocus = FocusNode();
  var pinFocus = FocusNode();
  var cityFocus = FocusNode();
  String? stateDropDownValue;
  String? countryDropDown;

  void saveEditedAddress() {
    if (_formKey.currentState!.validate()) {
      if (isEditing = false) {
        Address updatedAddress = Address(
          country: countryDropDown,
          name: nameController.text,
          phone: phoneController.text,
          add1: add1Controller.text,
          add2: add2Controller.text,
          landmark: landmarkController.text,
          pinCode: pinCodeController.text,
          city: cityController.text,
          state: stateDropDownValue,
        );
        Navigator.pop(context, updatedAddress);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'ADDRESS UPDATED',
            style: TextStyle(color: Colors.white),
          ),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Something wrong',
            style: TextStyle(color: Colors.white),
          ),
        ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    print('object:${widget.addressToEdit}');
    if (widget.addressToEdit != null) {
      countryDropDown = widget.addressToEdit?.country ?? "";
      nameController.text = widget.addressToEdit?.name ?? '';
      phoneController.text = widget.addressToEdit?.phone ?? '';
      add1Controller.text = widget.addressToEdit?.add1 ?? '';
      add2Controller.text = widget.addressToEdit?.add2 ?? '';
      landmarkController.text = widget.addressToEdit?.landmark ?? '';
      pinCodeController.text = widget.addressToEdit?.pinCode ?? '';
      cityController.text = widget.addressToEdit?.city ?? '';
      stateDropDownValue = widget.addressToEdit?.state ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Enter shipping Address',
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade300,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  borderRadius: BorderRadius.circular(5),
                  hint: countryDropDown == null
                      ? const Text(
                          'Select country',
                          style: TextStyle(color: Colors.black),
                        )
                      : Text(
                          countryDropDown ?? "",
                          style: TextStyle(color: Colors.black),
                        ),
                  isExpanded: true,
                  iconSize: 30.0,
                  style: const TextStyle(color: Colors.black),
                  itemHeight: 50,
                  items: [
                    'India',
                    'United Kingdom',
                    'United states',
                    'Canada',
                    'Brazil',
                    'France',
                    'Russia'
                  ].map(
                    (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val),
                      );
                    },
                  ).toList(),
                  validator: (value) => value == null ? 'field required' : null,
                  onChanged: (val) {
                    setState(() {
                      isEditing = false;
                      countryDropDown = val;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "Full name (First and Last Name)",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: TextFormField(
                  controller: nameController,
                  focusNode: nameFocus,
                  onFieldSubmitted: (value) {
                    mobileFocus.requestFocus();
                  },
                  onChanged: (value) {
                    setState(() {
                      isEditing = false;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Full Name';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "Mobile Number",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: TextFormField(
                  controller: phoneController,
                  focusNode: phoneFocus,
                  maxLength: 12,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      isEditing = false;
                    });
                  },
                  onFieldSubmitted: (value) {
                    add1Focus.requestFocus();
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your PhoneNumber ';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "Flat,House no.,Building,company,Apartment",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextFormField(
                  controller: add1Controller,
                  focusNode: add1Focus,
                  onFieldSubmitted: (value) {
                    add2Focus.requestFocus();
                  },
                  onChanged: (value) {
                    setState(() {
                      isEditing = false;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter detail';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "Area,street,Sector,Village",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextFormField(
                  controller: add2Controller,
                  focusNode: add2Focus,
                  onChanged: (value) {
                    setState(() {
                      isEditing = false;
                    });
                  },
                  onFieldSubmitted: (value) {
                    landmarkFocus.requestFocus();
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter detail';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "Landmark",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextFormField(
                  controller: landmarkController,
                  focusNode: landmarkFocus,
                  onFieldSubmitted: (value) {
                    pinFocus.requestFocus();
                  },
                  onChanged: (value) {
                    setState(() {
                      isEditing = false;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'E.g. near circle',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Landmark';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "Pincode",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextFormField(
                  controller: pinCodeController,
                  focusNode: pinFocus,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      isEditing = false;
                    });
                  },
                  onFieldSubmitted: (value) {
                    cityFocus.requestFocus();
                  },
                  decoration: const InputDecoration(
                    hintText: '6 digits [0-9] PIN code',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Pincode';
                    }
                    return null;
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "Town/City",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: TextFormField(
                  controller: cityController,
                  focusNode: cityFocus,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your city';
                    }
                    return null;
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "State",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(5),
                  hint: stateDropDownValue == null
                      ? Text('Select')
                      : Text(
                          stateDropDownValue!,
                          style: TextStyle(color: Colors.black),
                        ),
                  isExpanded: true,
                  iconSize: 30.0,
                  style: const TextStyle(color: Colors.black),
                  items: [
                    'Gujarat',
                    'Rajasthan',
                    'UtterPradesh',
                    'Maharashtra',
                    'Karnataka',
                    'Tamil Nadu',
                    'Himachal Pradesh'
                  ].map(
                    (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val),
                      );
                    },
                  ).toList(),
                  validator: (value) => value == null ? 'field required' : null,
                  onChanged: (val) {
                    setState(() {
                      isEditing = false;
                      stateDropDownValue = val;
                    });
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 70.0, vertical: 20),
                child:
                    // widget.addressToEdit != null
                    //     ? ElevatedButton(
                    //         style: ElevatedButton.styleFrom(
                    //             primary: Colors.lightBlueAccent.shade100),
                    //         onPressed: () {
                    //           saveEditedAddress(); // Save the edited address and return it to SelectAddress
                    //         },
                    //         child: Container(
                    //           alignment: Alignment.center,
                    //           height: 60,
                    //           width: 240,
                    //           child: Text(
                    //             'SAVE',
                    //             style: TextStyle(
                    //                 fontSize: 16,
                    //                 fontWeight: FontWeight.w500,
                    //                 color: Colors.white),
                    //           ),
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(12),
                    //           ),
                    //         ),
                    //       )
                    //    :
                    ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlueAccent.shade100),
                  onPressed: () {
                    if (isEditing) {
                      saveEditedAddress();
                    } else {
                      saveAddress();
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 60,
                    width: 240,
                    child: Text(
                      isEditing ? 'SAVE' : 'SAVE ADDRESS',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
