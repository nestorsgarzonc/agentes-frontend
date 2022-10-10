
import 'package:flutter/material.dart';
import 'package:restaurants/features/product/models/product_model.dart';

class ToppingOptionsCheckbox extends StatefulWidget {
  const ToppingOptionsCheckbox({super.key, required this.toppings, required this.onAdd});
  final List<Topping> toppings;
  final void Function(Topping value) onAdd;

  @override
  State<ToppingOptionsCheckbox> createState() => _ToppingOptionsCheckboxState();
}

class _ToppingOptionsCheckboxState extends State<ToppingOptionsCheckbox> {
List<Topping> addedToppings=[];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: widget.toppings.length,
      itemBuilder: (context, i) {
        final currentTopping = widget.toppings[i];
        return Column(
          children: [
            Text(currentTopping.name),
            ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: currentTopping.options.length,
              itemBuilder: (context, index) {
                final toppingOption = currentTopping.options[index];
                if (currentTopping.type == 'checkBox') {
                  return CheckboxListTile(
                    value: addedToppings.expand((element) => element.options).contains(toppingOption),
                    onChanged: (bool? newValue) {
                      setState(() {
                            
                      });
                    },
                    title: Text(toppingOption.name),
                    subtitle: Text('\$ ${toppingOption.price}'),
                    secondary: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.network(
                        toppingOption.imgUrl,
                        height: 50,
                        width: 50,
                      ),
                    ),
                  );
                } else {
                  bool currentOptionBool = false;
                  return RadioListTile(
                    value: false,
                    groupValue: currentOptionBool,
                    onChanged: (bool? newValue) {
                      setState(() {
                    
                      });
                    },
                    title: Text(toppingOption.name),
                    subtitle: Text(toppingOption.price.toString()),
                    secondary: Image.network(toppingOption.imgUrl),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
