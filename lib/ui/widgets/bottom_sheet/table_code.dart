import 'package:flutter/material.dart';
import 'package:restaurants/core/validators/text_form_validator.dart';
import 'package:restaurants/ui/widgets/custom_text_field.dart';

class TableCodeBottomSheet {
  static Future<void> showManualCodeSheet({
    required BuildContext context,
    required void Function(String) onAccept,
  }) {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController();
    return showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ingresa el codigo de tu mesa',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    onPressed: Navigator.of(context).pop,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Form(
                key: formKey,
                child: CustomTextField(
                  label: 'Codigo de la mesa',
                  controller: controller,
                  validator: TextFormValidator.tableCodeValidator,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      onAccept(controller.text);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Continuar')),
              SizedBox(height: 10 + MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        );
      },
    );
  }
}
