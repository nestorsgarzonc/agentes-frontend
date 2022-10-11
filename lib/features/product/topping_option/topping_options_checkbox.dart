import 'package:collection/collection.dart';
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
  List<Topping> addedToppings = [];

  @override
  void initState() {
    super.initState();
    addedToppings = [...widget.toppings];
    addedToppings = addedToppings.map((e) => e.copyWith(options: [])).toList();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: widget.toppings.length,
      itemBuilder: (context, i) {
        final currentTopping = widget.toppings[i];
        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentTopping.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Text('Minimo de opciones: ${currentTopping.minOptions}'),
                Text('Maximo de opciones: ${currentTopping.maxOptions}'),
                const Divider(),
                ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  primary: false,
                  shrinkWrap: true,
                  itemCount: currentTopping.options.length,
                  itemBuilder: (context, index) {
                    final toppingOption = currentTopping.options[index];
                    if (currentTopping.type == 'checkBox') {
                      return CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        value: addedToppings
                            .expand((element) => element.options)
                            .contains(toppingOption),
                        onChanged: (bool? newValue) {
                          final selectedTopping =
                              addedToppings.firstWhere((e) => e.id == currentTopping.id);
                          if (selectedTopping.options.contains(toppingOption)) {
                            selectedTopping.options.remove(toppingOption);
                          } else {
                            if (selectedTopping.options.length >= currentTopping.maxOptions) return;
                            selectedTopping.options.add(toppingOption);
                          }
                          setState(() {});
                        },
                        title: Text(toppingOption.name),
                        subtitle: Text('\$ ${toppingOption.price}'),
                        secondary: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            toppingOption.imgUrl,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else {
                      final selectedTopping =
                          addedToppings.firstWhere((e) => e.id == currentTopping.id);
                      return RadioListTile<Option>(
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.trailing,
                        value: toppingOption,
                        groupValue: selectedTopping.options.firstOrNull,
                        onChanged: (newValue) {
                          if (selectedTopping.options.isEmpty) {
                            selectedTopping.options.add(toppingOption);
                          } else {
                            selectedTopping.options.clear();
                            selectedTopping.options.add(toppingOption);
                          }
                          setState(() {});
                        },
                        title: Text(toppingOption.name),
                        subtitle: Text('\$ ${toppingOption.price}'),
                        secondary: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            toppingOption.imgUrl,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
