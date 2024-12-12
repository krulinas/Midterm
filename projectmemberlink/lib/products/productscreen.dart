import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projectmemberlink/views/mydrawer.dart';
import 'package:projectmemberlink/myconfig.dart';
import 'package:projectmemberlink/products/products.dart';
import 'package:projectmemberlink/products/purchaseproduct.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});
  @override
  State<ProductScreen> createState() => ProductScreenState();
}

class ProductScreenState extends State<ProductScreen> {
  late double screenHeight, screenWidth;
  String status = "No products available! Refresh the page.";
  List<Product> productList = [];
  int curPage = 1;
  int numOfPages = 1;

  @override
  void initState() {
    super.initState();
    loadProductsData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Products",
          style: TextStyle(
            color: Colors.yellow,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(
          color: Colors.yellow,
        ),
        actions: [
          IconButton(
            onPressed: () {
              loadProductsData();
            },
            icon: const Icon(Icons.refresh, color: Colors.yellow),
          ),
        ],
      ),
      body: productList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "No products available! Refresh the page.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Icon(
                    Icons.info_outline,
                    size: 80,
                    color: Colors.yellow,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      loadProductsData();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text("Refresh"),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Page: $curPage/$numOfPages",
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    children: List.generate(productList.length, (index) {
                      return Card(
                        color: const Color(0xFF2E2E2E),
                        child: InkWell(
                          splashColor: Colors.yellow,
                          onTap: () {
                            showProductDetailsDialog(index);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image.network(
                                  "${MyConfig.servername}/${productList[index].productImage}",
                                  width: screenWidth / 2,
                                  height: screenHeight / 6,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.asset(
                                    "assets/images/${productList[index].productImage?.split('/').last}",
                                    width: screenWidth / 2,
                                    height: screenHeight / 6,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  productList[index].productTitle ?? "No Title",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Price: RM${productList[index].productPrice?.toStringAsFixed(2) ?? '0.00'}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                                Text(
                                  "Available: ${productList[index].productQuantity ?? 0}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numOfPages,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final color =
                          (curPage - 1) == index ? Colors.red : Colors.yellow;
                      return TextButton(
                        onPressed: () {
                          curPage = index + 1;
                          loadProductsData();
                        },
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(color: color, fontSize: 18),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (content) => const PurchaseProduct()),
          );
        },
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.black,
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }

  void showProductDetailsDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2E2E2E),
          title: Text(
            productList[index].productTitle ?? "No Title",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Price: RM${productList[index].productPrice?.toStringAsFixed(2) ?? '0.00'}\n"
            "Available: ${productList[index].productQuantity ?? 0}\n"
            "Description: ${productList[index].productDescription ?? 'No Description'}",
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text("Close", style: TextStyle(color: Colors.yellow)),
            ),
          ],
        );
      },
    );
  }

  void loadProductsData() {
    http
        .get(Uri.parse(
            "${MyConfig.servername}/mymemberlink/api/loadproduct.php?pageno=$curPage"))
        .then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data']['products'];
          productList.clear();
          for (var item in result) {
            Product product = Product.fromJson(item);
            productList.add(product);
          }
          numOfPages = int.parse(data['numofpage'].toString());
          setState(() {});
        } else {
          setState(() {
            status = "No products available! Refresh the page.";
          });
        }
      } else {
        setState(() {
          status = "Error fetching data";
        });
      }
    }).catchError((error) {
      setState(() {
        status = "Error: ${error.toString()}";
      });
    });
  }
}
