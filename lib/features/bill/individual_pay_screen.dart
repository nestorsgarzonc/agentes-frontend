import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurants/core/constants/lotti_assets.dart';
import 'package:restaurants/core/validators/text_form_validator.dart';
import 'package:restaurants/features/auth/provider/auth_provider.dart';
import 'package:restaurants/ui/auth/register_screen.dart';
import 'package:restaurants/ui/widgets/backgrounds/animated_background.dart';
import 'package:restaurants/ui/widgets/buttons/custom_elevated_button.dart';
import 'package:restaurants/ui/widgets/custom_text_field.dart';

class IndividualPayScreen extends ConsumerStatefulWidget {
  const IndividualPayScreen({super.key});

  static const route = '/individual_pay_screen';

  @override
  ConsumerState<IndividualPayScreen> createState() => _IndividualPayScreen();
}

class _IndividualPayScreen extends ConsumerState<IndividualPayScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool? isSelected = false;
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          const Text(
            'Pago individual',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Card(
            child: ListTile(
              title: const Text(
                'User name',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'price',
                style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(.7)),
              ),
              leading: CircleAvatar(
                backgroundColor: isSelected == true ? Colors.deepOrange : Colors.blueAccent,
                foregroundColor: Colors.white,
                child: const Icon(Icons.person),
              ),
              trailing: CustomElevatedButton(
                child: const Text('Pagar ahora'),
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
    );
  }
}
