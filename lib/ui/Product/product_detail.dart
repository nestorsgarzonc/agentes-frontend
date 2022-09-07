// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

int FoodQuantity = 0;

// ignore: camel_case_types
class productDetail extends StatefulWidget{

  const productDetail({super.key});
  static const route = '/product_detail';

  @override
  State<productDetail> createState() => _productDetailState();

}

// ignore: camel_case_types
class _productDetailState extends State<productDetail> {
  final _formKey = GlobalKey();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const Image(image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/6/62/NCI_Visuals_Food_Hamburger.jpg/640px-NCI_Visuals_Food_Hamburger.jpg')),
          const SizedBox(height: 20),
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
          const SizedBox(height:20),
          const Text(
            '[Descripción] Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            constraints: const BoxConstraints(maxWidth: 10.0),
            margin: const EdgeInsets.all(5.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: RemoveFromFoodQuantity,
                  child:const Icon(
                    Icons.remove_sharp, 
                    size: 30.0,
                  ),
                ),
                Text(
                  '  $FoodQuantity  ',
                  style: const TextStyle(
                    fontSize: 30,
                  ),
                ),
                GestureDetector(
                  onTap: AddToFoodQuantity,
                  child: const Icon(
                    Icons.add,
                    size: 30.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void AddToFoodQuantity(){
  FoodQuantity++;
}

void RemoveFromFoodQuantity(){
  FoodQuantity--;
}