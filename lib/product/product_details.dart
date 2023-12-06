import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:demoapp/cart/cart.dart';
import 'package:demoapp/product/Image_zoom.dart';
import 'package:demoapp/product/product_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetails extends StatefulWidget {
  final String id;
  ProductDetails({
    super.key,
    required this.id,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final String accessToken = 'lmkstrgdj@\$2spqzmxz1p5su2uyrto@shwopqo928';
  bool initialDataLoaded = false;
  int currentIndex = 0;
  final String apiUrl = 'https://dealkarde.com/dealkarde_api/p/_pd';
  int numOfItems = 1;
  final String key = 'cart';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> addToCartWithProductId(String token, String productId) async {
    final product = await productDetails(token, productId);

    if (product != null) {
      final prefs = await _prefs;
      final cartProvider = CartProvider();

      List<Map<String, dynamic>> currentItemsJson = [];

      List<ProductData> currentItems = await cartProvider.getCartItems();
      currentItems.add(product);

      for (var item in currentItems) {
        currentItemsJson.add({
          'product_id': item.productId,
          'name': item.name,
          'price': item.price,
          'image': item.image,
        });
      }
      final cartJson = jsonEncode(currentItemsJson);
      await prefs.setString(key, cartJson);
    }
  }

  ///////////////////////////////

  ////////////////////////////
  //
  // Future<void> addToCart(ProductData item) async {
  //   final cartProvider =
  //       CartProvider(); // You need to define your CartProvider class.
  //   cartProvider.addToCart(
  //       item); // Assuming your CartProvider class handles cart storage.
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Added to Cart'),
  //     ),
  //   );
  // }

  // Future<void> addToCart(List<ProductData> item) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final cartItemsJson = prefs.getStringList('cartItems') ?? [];
  //
  //   // Convert the List of ProductData objects to a List of JSON strings
  //   cartItemsJson.add(jsonEncode(item));
  //
  //   await prefs.setStringList('cartItems', cartItemsJson);
  //   setState(() {});
  //   // Reload the cart items
  // }

  // void addItemToCart(ProductData product) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final cartItems = prefs.getStringList(cartKey) ?? [];
  //
  //   // Convert the ProductData object to a JSON string
  //   final productJson = jsonEncode(product);
  //
  //   cartItems.add(productJson);
  //   await prefs.setStringList(cartKey, cartItems);
  //
  //   setState(() {
  //     cartItems.add(productJson);
  //   });
  // }

  // Future<void> init() async {
  //   _prefs = await SharedPreferences.getInstance();
  // }
  // List<ProductData> getCartItems() {
  //   final cartData = _prefs!.getStringList('cart') ?? [];
  //   final cartItems = cartData.map((productId) {
  //     return ProductData.fromJson(_prefs!.get('pid'(productId)));
  //   }).toList();
  //
  //   return cartItems;
  // }
  //final ShoppingCart cart = ShoppingCart();

  // Future<void> loadCartItems() async {
  //   final items = await cart.getCartItems();
  //   setState(() {
  //     cartItems = items.cast<ProductData>();
  //   });
  // }

  Future<ProductData?> productDetails(token, productId) async {
    final response = await http.post(Uri.parse(apiUrl), body: {
      'access_token': token,
      'pid': productId,
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final Map<String, dynamic> data = jsonResponse['Data'];
      final productData = ProductData.fromJson(data);
      return productData;
    } else {
      print('Failed to create product. Status code: ${response.statusCode}');
      return null;
    }
  }

  // Future<ProductData?> productDetails(token, productId) async {
  //   final response = await http.post(Uri.parse(apiUrl), body: {
  //     'access_token': token,
  //     'pid': productId,
  //   });
  //   if (response.statusCode == 200) {
  //     print(response.body);
  //     final Map<String, dynamic> jsonResponse = json.decode(response.body);
  //     final Map<String, dynamic> data = jsonResponse['Data'];
  //     return ProductData.fromJson(data);
  //
  //   } else {
  //     print('Failed to create product. Status code: ${response.statusCode}');
  //     // Handle error here
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('product details'),
          backgroundColor: Colors.blue,
        ),
        body: FutureBuilder(
          future: productDetails(accessToken, widget.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !initialDataLoaded) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (!initialDataLoaded) {
                if (snapshot.hasData) {
                  initialDataLoaded =
                      true; // Set the initialDataLoaded flag to true
                } else if (snapshot.hasError) {
                  // Handle the error here if needed
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
              }

              final ProductData? product = snapshot.data;

              final List<Widget> imageWidgets =
                  product!.images.map((imageData) {
                return Center(
                  child: FadeInImage(
                    placeholder: AssetImage('asset/image/placeholder.jpg'),
                    image: NetworkImage(
                      'https://dealkarde.com/image/${product.image.toString()}',
                    ),
                    fit: BoxFit.cover, // Adjust the fit property as needed
                  ),
                );
              }).toList();
              return Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          final List<String> imageUrls =
                              imageWidgets.map((widget) {
                            if (widget is FadeInImage) {
                              return (widget.image as NetworkImage).url;
                            } else {
                              return '';
                            }
                          }).toList();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      OpenImages(imageUrls: imageUrls)));
                        },
                        child: CarouselSlider(
                            options: CarouselOptions(
                              height: 200.0,
                              aspectRatio: 16 / 9,
                              autoPlay: false,
                              enableInfiniteScroll: true,
                              viewportFraction: 1,
                              initialPage: currentIndex,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentIndex = index % product.images.length;
                                });
                              },
                            ),
                            items: imageWidgets
                            // product.images
                            //     .map((item) => Container(
                            //           height: 400,
                            //           child: Center(
                            //             child: FadeInImage(
                            //               placeholder: AssetImage(
                            //                   'asset/image/placeholder.jpg'),
                            //               image: NetworkImage(
                            //                 'https://dealkarde.com/image/${item.image.toString()}',
                            //               ),
                            //               fit: BoxFit
                            //                   .cover, // Adjust the fit property as needed
                            //             ),
                            //           ),
                            //         ))
                            //     .toList(),
                            ),
                      ),
                      // ListView(
                      //   scrollDirection: Axis.horizontal,
                      //   children: product.attribute.map((data) {
                      //     return Container(
                      //       decoration: BoxDecoration(
                      //         color: Colors.orangeAccent,
                      //         borderRadius: BorderRadius.circular(10),
                      //       ),
                      //       height: 100,
                      //       width: 150,
                      //       alignment: Alignment.center,
                      //       child: Column(
                      //         children: [
                      //           Text(data.text),
                      //           Text(data.name),
                      //         ],
                      //       ),
                      //     );
                      //   }).toList(),
                      // ),
                      // ListView.builder(
                      //     scrollDirection: Axis.horizontal,
                      //     itemCount: product.images.length,
                      //     itemBuilder: (context, index) {
                      //       return SizedBox(
                      //         height: 200,
                      //         width: 500, // <---- mandatory size
                      //         child: ListTile(
                      //           title: Text('${product.attribute[index].text}'),
                      //           subtitle:
                      //               Text('${product.attribute[index].name}'),
                      //         ),
                      //       );
                      //     }),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var i = 0; i < product.images.length; i++)
                            buildIndicator(currentIndex == i)
                        ],
                      ),
                      buildListTile('Product Name: ${product.name}'),
                      buildListTile('Price: ${product.price}'),
                      buildListTile(
                          'Product original Price: ${product.originalPrice}'),
                      buildListTile('Model: ${product.model}'),
                      buildListTile(
                          'Product Description: ${product.description}'),
                      SizedBox(height: 30),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.lightBlueAccent.shade100),
                          onPressed: () async {
                            print(product.productId);
                            await addToCartWithProductId(
                                accessToken, product.productId);

                            // final cartProvider = CartProvider();
                            //   await cartProvider.addToCart(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Added to Cart'),
                              ),
                            );

                            // List<ProductData> productsToAdd = []; // Your list of ProductData objects
                            // addToCart(productsToAdd);

                            // addToCart(cartItems);
                            //addItemToCart(product);
                            //   final cart = ShoppingCart();
                            //    addToCart(
                            //       product.name); // Add your product name here
                            //loadCartItems();
                            // final cart = ShoppingCart();
                            // await cart.addToCart(product.productId);
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(
                            //       backgroundColor: Colors.black38,
                            //       content: Text(
                            //         'Added successfully',
                            //         style: TextStyle(
                            //             color: Colors.white, fontSize: 14),
                            //       )),
                            // );
                            // addToCart(items as ProductData);
                            // print('data:$items');
                            //   Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) =>ProductScreen()
                            //           // AddToCart()
                            //           // image: product.image,
                            //           // name: product.name,
                            //           // price: product.originalPrice,
                            //   ));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 60,
                            width: 210,
                            child: Text(
                              'ADD TO CART',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ))
                    ],
                  ),
                ),
              );
            }
          },
        ));
  }

  ListTile buildListTile(name) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget buildIndicator(bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Container(
        height: isSelected ? 12 : 10,
        width: isSelected ? 12 : 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.black : Colors.grey,
        ),
      ),
    );
  }
}
