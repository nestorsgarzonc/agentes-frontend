import 'package:flutter/material.dart';
import 'package:restaurants/core/validators/text_form_validator.dart';
import '../widgets/backgrounds/animated_background.dart';
import '../widgets/custom_text_field.dart';

import '../widgets/buttons/custom_elevated_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const route = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> {
  final Key _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

   @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          const SizedBox(height: 10),
          const Text(
            'Regístrate',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              children:  [
                const CustomTextField(
                  label: 'Nombres',
                  ),

                const SizedBox(height: 20),
                const CustomTextField(
                  label: 'Apellidos',
                  ),

                  const SizedBox(height: 20),
                   CustomTextField(
                  label: 'Correo',
                  validator: TextFormValidator.emailValidator,
                  controller: _emailController,
                  ),

                  const SizedBox(height: 20),
                  CustomTextField(
                  label: 'Contraseña',
                  obscureText: true,
                  maxLines: 1,
                  controller: TextEditingController(text: ''),
                  validator: TextFormValidator.passwordValidator,
                  ),

                  const SizedBox(height: 20),
                  CustomTextField(
                  label: 'Confirma la contraseña',
                  obscureText: true,
                  maxLines: 1,
                  controller: TextEditingController(text: ''),
                  validator: TextFormValidator.passwordValidator,
                  ),

                  const SizedBox(height: 20),
                  const CustomTextField(
                  label: 'Celular',
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          CustomElevatedButton(
            onPressed: (){},
            child: const Text('Registrarse'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}