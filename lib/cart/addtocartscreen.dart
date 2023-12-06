// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../product/product_detail_model.dart';
// import 'cart.dart';
// import 'mycart_screen.dart';
//
// class AddToCart extends StatefulWidget {
//   @override
//   State<AddToCart> createState() => _AddToCartState();
// }
//
// class _AddToCartState extends State<AddToCart> {
//   int numOfItems = 1;
//   List<ProductData> cartItems = [];
//
//   showAlertDialog(BuildContext context, String productId) {
//     // set up the buttons
//     Widget cancelButton = TextButton(
//       child: Text("Cancel"),
//       onPressed: () {
//         Navigator.pop(context);
//       },
//     );
//     Widget continueButton = TextButton(
//       child: Text("Yes"),
//       onPressed: () async {
//         String productIdToRemove = productId;
//         await CartProvider().removeCartItem(productIdToRemove);
//         setState(() {});
//         Navigator.pop(context);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('PRODUCT DELETED FROM CART '),
//           ),
//         );
//       },
//     );
//
//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       title: Text("AlertDialog"),
//       content: Text("Are you sure Want to remove item?"),
//       actions: [
//         cancelButton,
//         continueButton,
//       ],
//     );
//
//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.blue,
//           title: const Text(
//             'My Cart Screen',
//           ),
//         ),
//         body: FutureBuilder<List<ProductData>>(
//           future: CartProvider().getCartItems(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return CircularProgressIndicator();
//             } else if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}');
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return Text('Cart is empty.');
//             } else {
//               final cartItems = snapshot.data;
//               return ListView.builder(
//                 itemCount: cartItems!.length,
//                 itemBuilder: (context, index) {
//                   print(
//                       'https://dealkarde.com/image/${cartItems[index].image}');
//                   return Card(
//                     elevation: 10,
//                     child: Padding(
//                       padding: const EdgeInsets.all(15.0),
//                       child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             //Image.network(cartItems[index].image),
//                             // Image.network(
//                             //   'https://dealkarde.com/image/${cartItems[index].image}',
//                             //   height: 70,
//                             //   width: 70,
//                             // ),
//                             SizedBox(
//                               width: 20,
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   cartItems[index].name,
//                                   style: TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w500,
//                                       color: Colors.black),
//                                 ),
//                                 SizedBox(
//                                   height: 5,
//                                 ),
//                                 Text(
//                                   '\$${cartItems[index].price}',
//                                   style: TextStyle(
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.w400,
//                                       color: Colors.black),
//                                 ),
//                                 SizedBox(
//                                   height: 5,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     InkWell(
//                                       onTap: () {
//                                         // int? parsedQuantity = int.tryParse(
//                                         //     cartItems[index].quantity);
//                                         // print(parsedQuantity);
//                                         // if (parsedQuantity != null) {
//                                         //   int quantity = parsedQuantity;
//                                         //   quantity++; // Increment the quantity as an integer
//                                         //   cartItems[index].quantity =
//                                         //       quantity.toString();
//                                         //   setState(() {});
//                                         //   print(parsedQuantity);
//                                         //   print(quantity);
//                                         // } else {
//                                         //   print('error');
//                                         //   // Handle the case where quantity is not a valid number, e.g., set quantity to 0 or show an error message.
//                                         // }
//                                       },
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                             color: Colors.blue,
//                                             borderRadius:
//                                                 BorderRadius.circular(2)),
//                                         child: const Icon(
//                                           Icons.add,
//                                           size: 25,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     Text(
//                                       'Quantity: ',
//                                       style: TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w400,
//                                           color: Colors.black),
//                                     ),
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     InkWell(
//                                       onTap: () {
//                                         // if (int.parse(
//                                         //         cartItems[index].quantity) >
//                                         //     0) {
//                                         //   int quantity = int.parse(
//                                         //       cartItems[index].quantity);
//                                         //   quantity--;
//                                         //   cartItems[index].quantity = quantity
//                                         //       .toString(); // Update the quantity as a string
//                                         //   setState(() {});
//                                         // }
//
//                                         //   setState(() {
//                                         //     if (numOfItems > 1) {
//                                         //       setState(() {
//                                         //         numOfItems--;
//                                         //       });
//                                         //     }
//                                         //   });
//                                       },
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                             color: Colors.blue,
//                                             borderRadius:
//                                                 BorderRadius.circular(2)),
//                                         child: const Icon(
//                                           Icons.remove,
//                                           size: 25,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                     Container(
//                                         height: 50,
//                                         width: 50,
//                                         child: IconButton(
//                                             icon: Icon(
//                                               Icons.delete,
//                                               size: 30,
//                                               color: Colors.red,
//                                             ),
//                                             onPressed: () async {
//                                               print('tap');
//                                               // String productIdToRemove =
//                                               //     cartItems[index].productId;
//                                               // CartProvider().removeCartItem(
//                                               //     productIdToRemove );
//                                               // print('tap1');
//                                               showAlertDialog(context,
//                                                   cartItems[index].productId);
//                                               // final cartProvider = CartProvider();
//                                               // await cartProvider.removeCartItem(
//                                               //    cartItems[index] );
//                                               // print('id${cartItems[index].productId}');
//                                               // String productIdToRemove = cartItems[index].productId;
//                                               // final cartProvider =
//                                               // CartProvider(); //
//                                               // await cartProvider.removeCartItem(productIdToRemove);
//                                               // //
//                                               // Replace '123' with the actual productId you want to remove
//                                               // ProductData productToRemove = cartItems.firstWhere((item) => item.productId == productIdToRemove, );
//                                               //
//                                               //
//                                               //    final cartProvider = CartProvider();
//                                               //   await cartProvider.removeCartItem(productToRemove);
//                                             }))
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ]),
//                     ),
//                   );
//                 },
//               );
//             }
//           },
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//         floatingActionButton: Container(
//           height: 50,
//           margin: const EdgeInsets.all(10),
//           child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   primary: Colors.lightBlueAccent.shade100),
//               onPressed: () {
//
//               },
//               child: Container(
//                 alignment: Alignment.center,
//                 height: 60,
//                 width: 200,
//                 child: Text(
//                   'PROCEED TO CHECKOUT',
//                   style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.white),
//                 ),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               )),
//         ));
//   }
// }
