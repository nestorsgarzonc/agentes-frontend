import 'package:flutter/material.dart';
import '../widgets/buttons/custom_elevated_button.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});
  static const route = '/product-detail';

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  late int foodQuantity = 0, mainProductPrice = 13500, toppingsPrices = 600, total = 0;
  bool isSelectedA = false, isSelectedB = false;
  final _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const Image(
            image: NetworkImage(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/6/62/NCI_Visuals_Food_Hamburger.jpg/640px-NCI_Visuals_Food_Hamburger.jpg',
            ),
          ),
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
                Text(
                  '${String.fromCharCode(036)} $mainProductPrice',
                  style: const TextStyle(
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
                SizedBox(
                  height: 100,
                  child: ListView(
                    padding: const EdgeInsets.all(10),
                    children: [
                      CheckboxListTile(
                        title: Text.rich(
                          TextSpan(
                            text: 'Papas fritas\n',
                            children: <TextSpan>[
                              TextSpan(
                                text: '${String.fromCharCode(036)} $toppingsPrices',
                                style: const TextStyle(fontSize: 20.0),
                              ),
                            ],
                          ),
                        ),
                        value: isSelectedA,
                        onChanged: (bool? newValue) {
                          setState(() {
                            if (foodQuantity != 0) {
                              isSelectedA = newValue!;
                              calculateTotal();
                            }
                          });
                        },
                        secondary: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: const Image(
                            height: 40.0,
                            width: 40.0,
                            image: NetworkImage(
                              'https://www.cardamomo.news/__export/1621290930734/sites/debate/img/2021/05/17/papas_fritas_crop1621290739319.jpeg_1753094345.jpeg',
                            ),
                          ),
                        ),
                      ),
                      CheckboxListTile(
                        title: Text.rich(
                          TextSpan(
                            text: 'Guacamole\n',
                            children: <TextSpan>[
                              TextSpan(
                                text: '${String.fromCharCode(036)} $toppingsPrices',
                                style: const TextStyle(fontSize: 20.0),
                              ),
                            ],
                          ),
                        ),
                        value: isSelectedB,
                        onChanged: (bool? newValue) {
                          setState(() {
                            if (foodQuantity != 0) {
                              isSelectedB = newValue!;
                              calculateTotal();
                            }
                          });
                        },
                        secondary: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: const Image(
                            height: 40.0,
                            image: NetworkImage(
                              'https://www.mylatinatable.com/wp-content/uploads/2018/09/guacamole-foto-heroe-500x500.jpg',
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          CustomElevatedButton(
            onPressed: () {},
            child: Text('Hacer pedido (${String.fromCharCode(036)} $total )'),
          )
        ],
      ),
    );
  }

  void calculateTotal() {
    total = foodQuantity * mainProductPrice;
    if (isSelectedA && foodQuantity != 0) {
      total += toppingsPrices;
    }
    if (isSelectedB && foodQuantity != 0) {
      total += toppingsPrices;
    }
    setState(() {});
  }

  void addToFoodQuantity() {
    foodQuantity++;
    calculateTotal();
    setState(() {});
  }

  void removeFromFoodQuantity() {
    if (foodQuantity <= 0) {
      return;
    }
    foodQuantity--;
    calculateTotal();
    setState(() {});
  }
}
