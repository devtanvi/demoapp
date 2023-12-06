import 'dart:convert';
import 'dart:ffi';
import 'package:demoapp/cart/address_model.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_address.dart';

class SelectAddress extends StatefulWidget {
  const SelectAddress({super.key});

  @override
  _SelectAddressState createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  List<Address> addresses = [];
  int selectedAddressIndex = 0;

  void editAddress(
    Address address,
  ) async {
    final updatedAddress = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAddress(
          addressToEdit: address,
        ),
      ),
    );
    if (updatedAddress != null) {
      final index = addresses.indexOf(address);
      if (index != -1) {
        setState(() {
          addresses[index] = updatedAddress;
        });

        // Save the updated addresses to SharedPreferences
        saveAddressesToSharedPreferences(addresses);
      }
    }
  }

  Future<void> saveAddressesToSharedPreferences(List<Address> addresses) async {
    final prefs = await SharedPreferences.getInstance();
    final addressesJsonList =
        addresses.map((address) => address.toJson()).toList();
    final addressesJsonStringList =
        addressesJsonList.map((json) => jsonEncode(json)).toList();

    await prefs.setStringList('addresses', addressesJsonStringList);
  }

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

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final loadedAddresses = await loadAddresses();
    setState(() {
      addresses = loadedAddresses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('select Address'),
        backgroundColor: Colors.blue,
      ),
      body: addresses.isNotEmpty
          ? ListView.builder(
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final address = addresses[index];
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(5),

                      //set border radius more than 50% of height and width to make circle
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Radio(
                            value: index,
                            groupValue: selectedAddressIndex,
                            onChanged: (int? value) {
                              setState(() {
                                selectedAddressIndex = value!;
                              });
                            },
                          ),
                          title: Text('${address.name}'),
                          subtitle: Text(
                              '${address.add1}, ${address.add2}, ${address.landmark}, ${address.city}, ${address.state}, \n${address.pinCode}, ${address.country}'),

                          // You can display other address details here as needed
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        side:
                                            BorderSide(color: Colors.black)))),
                            onPressed: () {
                              editAddress(Address());
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 280,
                              child: Text(
                                'Add New Address',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            )),
                        SizedBox(height: 10),
                        ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        side:
                                            BorderSide(color: Colors.black)))),
                            onPressed: () {
                              editAddress(
                                address,
                              );
                              // if (selectedAddressIndex != null) {
                              //   editAddress(address, isEdited: true);
                              // } else {
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     const SnackBar(
                              //         content: Text('Please select Address',
                              //             style:
                              //                 TextStyle(color: Colors.white))),
                              //   );
                              // }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 280,
                              child: Text(
                                'Edit Address',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            )),
                        SizedBox(height: 10),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.yellow),
                            onPressed: () {
                              Razorpay razorpay = Razorpay();
                              var options = {
                                'key': 'rzp_live_ILgsfZCZoFIKMb',
                                'amount': 1000,
                                'name': 'Acme Corp.',
                                'description': 'Fine T-Shirt',
                                'retry': {'enabled': true, 'max_count': 1},
                                'send_sms_hash': true,
                                'prefill': {
                                  'contact': '8888888888',
                                  'email': 'test@razorpay.com'
                                },
                                'external': {
                                  'wallets': ['paytm']
                                }
                              };
                              razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
                                  handlePaymentErrorResponse);
                              razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                                  handlePaymentSuccessResponse);
                              razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                                  handleExternalWalletSelected);
                              razorpay.open(options);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 280,
                              child: const Text(
                                'Deliver to this address',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            )),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              },
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "you have not any saved address\n Add new Address",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    side: BorderSide(color: Colors.black)))),
                        onPressed: () {
                          editAddress(
                            Address(),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 30,
                          width: 280,
                          child: Text(
                            'Add New Address',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        )),
                  ],
                ),
              ),
            ),
    );
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    showAlertDialog1(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    showAlertDialog1(
        context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog1(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog1(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
