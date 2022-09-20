import 'package:flutter/material.dart';
import 'package:restaurants/core/validators/text_form_validator.dart';
import 'package:restaurants/features/user/models/user_model.dart';
import '../widgets/backgrounds/animated_background.dart';
import '../widgets/custom_text_field.dart';
import 'package:restaurants/features/auth/provider/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/buttons/custom_elevated_button.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  static const route = '/register';

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
              children: [
                CustomTextField(
                  label: 'Nombres',
                  validator: TextFormValidator.nameValidator,
                  controller: _firstNameController,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Apellidos',
                  validator: TextFormValidator.nameValidator,
                  controller: _lastNameController,
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
                  controller: _passwordController,
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
                CustomTextField(
                  label: 'Celular',
                  controller: _phoneNumberController,
                  validator: TextFormValidator.cellphonValidator,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          CustomElevatedButton(
            onPressed: () {},
            child: const Text('Registrarse'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void handleOnRegister() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    ref.read(authProvider.notifier).register(
          User(
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            email: _emailController.text,
            phone: int.parse(_phoneNumberController.text),
            rol: null,
          ),
        );
  }
}
