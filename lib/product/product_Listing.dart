import 'dart:convert';
import 'package:demoapp/product/product_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../cart/mycart_screen.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  bool isLoading = false;
  final SearchController searchController = SearchController();
  List<dynamic> dataList = [];
  List<String> filteredItems = [];
  final String apiUrl = 'https://dealkarde.com/dealkarde_api/p/_al';
  final String accessToken = 'lmkstrgdj@\$2spqzmxz1p5su2uyrto@shwopqo928';

  Future<void> ProductList(String accessToken) async {
    isLoading = true;
    String accessToken = 'lmkstrgdj@\$2spqzmxz1p5su2uyrto@shwopqo928';
    final response = await http.post(Uri.parse(apiUrl), body: {
      'access_token': accessToken,
    });

    if (response.statusCode == 200) {
      isLoading = false;
      print(response.body);
      Map<String, dynamic> responseMap = json.decode(response.body);
      // List<dynamic> dataList = responseMap['Data'];
      final data = responseMap['Data'];
      print(data);

      setState(() {
        dataList = data;
      });
      print(dataList.length);
    } else {
      setState(() {
        dataList = [];
      });
      print('Request failed with status ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    ProductList(accessToken);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('product List'),
        backgroundColor: Colors.blue,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 5.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartPage()
                        // AddToCart()
                        ));
              },
              child: Icon(
                Icons.shopping_cart,
                size: 20,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SearchAnchor(
              searchController: searchController,
              headerTextStyle: const TextStyle(fontWeight: FontWeight.bold),
              viewHintText: 'Search Here',
              dividerColor: Colors.black,
              isFullScreen: false,
              viewElevation: 100,
              viewConstraints: const BoxConstraints(
                maxHeight: 300,
              ),
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  controller: searchController,
                  leading: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(
                      Icons.search,
                      size: 30,
                    ),
                  ),
                  onTap: () {
                    searchController.openView();
                  },
                );
              },
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                final keyword = controller.value.text;

                final matchingItems = dataList
                    .where((element) => element['name']
                        .toLowerCase()
                        .startsWith(keyword.toLowerCase()))
                    .toList();

                return matchingItems.map((item) {
                  return ListTile(
                    title: Text(item['name']),
                    onTap: () {
                      setState(() {
                        controller.closeView(item['name']);
                        FocusScope.of(context).unfocus();
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetails(id: item["product_id"]),
                        ),
                      );
                      controller.clear();
                    },
                  );
                }).toList();
              },
            ),
            SizedBox(
              height: 20,
            ),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                    backgroundColor: Colors.black,
                  ))
                : Expanded(
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 1.4 / 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 20),
                        itemCount: dataList.length,
                        itemBuilder: (BuildContext ctx, index) {
                          Map<String, dynamic> item = dataList[index];

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetails(
                                      id: dataList[index]["product_id"],
                                    ),
                                  ));
                            },
                            child: Card(
                              margin: const EdgeInsets.all(5),
                              color: Colors.white,
                              shadowColor: Colors.black,
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: SizedBox(
                                          child: Image.network(
                                        'https://dealkarde.com/image/${item['image']}',
                                        height: 120,
                                        width: 120,
                                      )),
                                    ),
                                    Text(
                                      item['name'] ?? '',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      'PRICE:${item["original_price"]}\nM.R.P${item["price"]}RS',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      'MODEL: ${item['model']}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
          ],
        ),
      ),
    );
  }
}
