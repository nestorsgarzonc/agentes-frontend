import 'package:flutter/material.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});
  static const route = '/product-detail';

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int foodQuantity = 0;
  final _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const Image(
              image: NetworkImage(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/6/62/NCI_Visuals_Food_Hamburger.jpg/640px-NCI_Visuals_Food_Hamburger.jpg')),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Product name',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Precio',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '[Descripción] Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: Container(
                    width: 100,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    margin: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: removeFromFoodQuantity,
                          child: const Icon(Icons.remove_sharp, size: 20),
                        ),
                        Text(
                          '$foodQuantity',
                        ),
                        GestureDetector(
                          onTap: addToFoodQuantity,
                          child: const Icon(Icons.add, size: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Acompañamiento',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints.expand(),
                  child: Row(
                    children: [
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void addToFoodQuantity() {
    foodQuantity++;
    setState(() {});
  }

  void removeFromFoodQuantity() {
    if (foodQuantity <= 0) {
      return;
    }
    foodQuantity--;
    setState(() {});
  }
}
