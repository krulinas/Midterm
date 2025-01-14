import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:projectmemberlink/myconfig.dart';
import 'package:projectmemberlink/products/products.dart';

class PurchaseProduct extends StatefulWidget {
  const PurchaseProduct({super.key});

  @override
  State<PurchaseProduct> createState() => _PurchaseProductState();
}

class _PurchaseProductState extends State<PurchaseProduct> {
  late double screenHeight, screenWidth;
  String status = "Loading products...";
  List<Product> productList = [];
  Map<Product, int> cart = {};
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
          "Add To Cart",
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
          IconButton(
            onPressed: showCartDialog,
            icon: const Icon(Icons.shopping_cart, color: Colors.yellow),
          ),
        ],
      ),
      body: productList.isEmpty
          ? Center(
              child: Text(
                status,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : GridView.count(
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
                                  )),
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
    );
  }

  void showProductDetailsDialog(int index) {
    TextEditingController quantityController = TextEditingController();

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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Price: RM${productList[index].productPrice?.toStringAsFixed(2) ?? '0.00'}",
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 8),
              Text(
                "Available: ${productList[index].productQuantity ?? 0}",
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 8),
              Text(
                "Description: ${productList[index].productDescription ?? 'No Description'}",
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Enter quantity",
                  labelStyle: TextStyle(color: Colors.yellow),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow, width: 2.0),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text("Close", style: TextStyle(color: Colors.yellow)),
            ),
            ElevatedButton(
              onPressed: () {
                int? quantity = int.tryParse(quantityController.text);
                if (quantity != null && quantity > 0) {
                  addToCart(productList[index], quantity);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Invalid quantity entered."),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
              child: const Text("Add to Cart",
                  style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  void addToCart(Product product, int quantity) {
    setState(() {
      if (cart.containsKey(product)) {
        cart[product] = cart[product]! + quantity;
      } else {
        cart[product] = quantity;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Added ${quantity}x ${product.productTitle} to cart."),
        backgroundColor: Colors.green,
      ),
    );
  }

  void showCartDialog() {
    showDialog(
      context: context,
      builder: (context) {
        double total = cart.entries
            .map((entry) => (entry.key.productPrice ?? 0) * entry.value)
            .fold(0, (sum, item) => sum + item);

        return AlertDialog(
          backgroundColor: const Color(0xFF2E2E2E),
          title: const Text(
            "Your Cart",
            style: TextStyle(color: Colors.yellow),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...cart.entries.map((entry) => ListTile(
                    title: Text(
                      entry.key.productTitle ?? "No Title",
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "Quantity: ${entry.value}, Total: RM${(entry.key.productPrice ?? 0) * entry.value}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  )),
              const SizedBox(height: 10),
              Text(
                "Total Price: RM${total.toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text("Close", style: TextStyle(color: Colors.yellow)),
            ),
            TextButton(
              onPressed: () {
                clearCart();
                Navigator.pop(context);
              },
              child:
                  const Text("Clear Cart", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                clearCart();
                Navigator.pop(context);
              },
              child: const Text("Checkout",
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
            ),
          ],
        );
      },
    );
  }

  void clearCart() {
    setState(() {
      cart.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Cart cleared."),
        backgroundColor: Colors.green,
      ),
    );
  }

  void loadProductsData() {
    http
        .get(Uri.parse(
            "${MyConfig.servername}/mymemberlink/api/loadcart.php?pageno=$curPage"))
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
            status = "No products available";
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
