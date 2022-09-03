import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurants/core/constants/lotti_assets.dart';
import 'package:restaurants/ui/widgets/backgrounds/animated_background.dart';
import 'package:restaurants/ui/widgets/custom_text_field.dart';

import '../widgets/buttons/custom_elevated_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const route = '/login';

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          const SizedBox(height: 20),
          const Text(
            '¡Bienvenido!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Te extrañamos',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black.withOpacity(0.7),
              fontSize: 18.0,
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 180,
            width: 180,
            child: Lottie.asset(
              LottieAssets.login,
              height: 180.0,
              fit: BoxFit.fitHeight,
            ),
          ),
          const SizedBox(height: 20),
          Form(
            child: Column(
              children: const [
                CustomTextField(label: 'Correo'),
                SizedBox(height: 20),
                CustomTextField(
                  label: 'Contraseña',
                  obscureText: true,
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          CustomElevatedButton(
            onPressed: () {},
            child: const Text('Ingresar'),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {},
            child: const Text('O regístrate ahora'),
          )
        ],
      ),
    );
  }
}
