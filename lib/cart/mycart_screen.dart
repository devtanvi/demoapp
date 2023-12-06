import 'package:demoapp/cart/select_address.dart';
import 'package:flutter/material.dart';
import '../product/product_Listing.dart';
import '../product/product_detail_model.dart';
import 'add_address.dart';
import 'cart.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<ProductData> cartItems = [];

  double calculateTotalPrice(List<ProductData> cartItems) {
    double totalPrice = 0.0;
    for (final item in cartItems) {
      double itemPrice = double.tryParse(item.price) ?? 0.0;
      int itemQuantity = item.quantity;

      totalPrice += itemPrice * itemQuantity;
    }
    return totalPrice;
  }

  showAlertDialog(BuildContext context, index) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () async {
        removeFromCart(index);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PRODUCT DELETED FROM CART '),
          ),
        );
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Are you sure Want to remove item?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    final items = await CartProvider().getCartItems();
    setState(() {
      cartItems = items;
    });
  }

  void removeFromCart(int index) {
    if (index >= 0 && index < cartItems.length) {
      cartItems.removeAt(index);
      updateCart();
      setState(() {});
    }
  }

  void updateCart() {
    CartProvider().updateCartItems(cartItems);
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = calculateTotalPrice(cartItems);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'My Cart Screen',
          ),
        ),
        body: cartItems.isNotEmpty
            ? ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Text('\$${item.price}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(2)),
                              child: IconButton(
                                alignment: Alignment.center,
                                icon: Icon(Icons.add, size: 25),
                                onPressed: () {
                                  setState(() {
                                    cartItems[index].updateQuantity(
                                        cartItems[index].quantity + 1);
                                    updateCart(); // Save the updated cart items in shared preferences
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 5),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('${item.quantity}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700)),
                            ),
                            SizedBox(width: 5),
                            if (item.quantity > 1) ...[
                              Container(
                                alignment: Alignment.topCenter,
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(2)),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.remove,
                                    size: 25,
                                  ),
                                  onPressed: () {
                                    if (item.quantity > 1) {
                                      setState(() {
                                        item.quantity--;
                                        updateCart();
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                            SizedBox(
                              width: 5,
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                size: 25,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                showAlertDialog(context, index);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: Text(
                      "your cartList is empty",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
        bottomNavigationBar: Container(
          color: Colors.black12,
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Total Price: \$${totalPrice.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          height: 50,
          margin: const EdgeInsets.all(10),
          child: cartItems.isNotEmpty
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlueAccent.shade100),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectAddress()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 60,
                    width: 200,
                    child: Text(
                      'PROCEED TO CHECKOUT',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ))
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlueAccent.shade100),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProductList()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 60,
                    width: 200,
                    child: Text(
                      'ADD ITEMS',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  )),
        ));
  }
}
