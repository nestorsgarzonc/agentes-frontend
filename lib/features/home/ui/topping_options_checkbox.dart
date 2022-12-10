import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:oyt_front_core/utils/currency_formatter.dart';
import 'package:oyt_front_product/models/product_model.dart';
import 'package:oyt_front_widgets/image/image_api_widget.dart';

class ToppingOptionsCheckbox extends StatefulWidget {
  const ToppingOptionsCheckbox({
    super.key,
    required this.toppings,
    required this.onAdd,
    this.orderedToppings,
  });
  final List<Topping> toppings;
  final void Function(List<Topping> value) onAdd;
  final List<Topping>? orderedToppings;

  @override
  State<ToppingOptionsCheckbox> createState() => _ToppingOptionsCheckboxState();
}

class _ToppingOptionsCheckboxState extends State<ToppingOptionsCheckbox> {
  List<Topping> addedToppings = [];
  List<Option> expandedToppings = [];

  @override
  void initState() {
    super.initState();
    if (widget.orderedToppings != null && (widget.orderedToppings ?? []).isNotEmpty) {
      addedToppings = [...widget.orderedToppings ?? []];
      expandedToppings = addedToppings.expand((element) => element.options).toList();
    } else {
      addedToppings = [...widget.toppings];
      addedToppings = addedToppings.map((e) => e.copyWith(options: [])).toList();
      expandedToppings = addedToppings.expand((element) => element.options).toList();
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.toppings
          .map(
            (currentTopping) => Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
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
                    Column(
                      children: currentTopping.options.map((toppingOption) {
                        if (currentTopping.type == 'checkBox') {
                          return Column(
                            children: [
                              const Divider(),
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                value: expandedToppings.contains(toppingOption),
                                onChanged: (bool? newValue) {
                                  final selectedTopping =
                                      addedToppings.firstWhere((e) => e.id == currentTopping.id);
                                  if (selectedTopping.options.contains(toppingOption)) {
                                    selectedTopping.options.remove(toppingOption);
                                  } else {
                                    if (selectedTopping.options.length >=
                                        currentTopping.maxOptions) {
                                      return;
                                    }
                                    selectedTopping.options.add(toppingOption);
                                  }
                                  expandedToppings =
                                      addedToppings.expand((element) => element.options).toList();
                                  widget.onAdd(addedToppings);
                                  setState(() {});
                                },
                                title: Text(toppingOption.name),
                                subtitle:
                                    Text('\$ ${CurrencyFormatter.format(toppingOption.price)}'),
                                secondary: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: ImageApi(
                                    toppingOption.imgUrl,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          final selectedTopping =
                              addedToppings.firstWhere((e) => e.id == currentTopping.id);
                          return Column(
                            children: [
                              const Divider(),
                              RadioListTile<Option>(
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
                                  widget.onAdd(addedToppings);
                                  setState(() {});
                                },
                                title: Text(toppingOption.name),
                                subtitle:
                                    Text('\$ ${CurrencyFormatter.format(toppingOption.price)}'),
                                secondary: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: ImageApi(
                                    toppingOption.imgUrl,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
