import 'package:flutter/material.dart';

class HelpMenuScreen extends StatelessWidget {
  const HelpMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Necesitas ayuda?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
            const SizedBox(height: 5),
            const Text('Selecciona a continuacion el tipo de ayuda que necesitas.'),
            const SizedBox(height: 15),
            Expanded(
              child: ListView(
                children: [
                  HelpItemCard(
                    title: 'Llamar mesero.',
                    onTap: () {},
                  ),
                  HelpItemCard(
                    title: 'Pedir la cuenta.',
                    onTap: () {},
                  ),
                  HelpItemCard(
                    title: '¿Cómo ordenar?',
                    onTap: () {},
                  ),
                  HelpItemCard(
                    title: '¿Cómo pagar?',
                    onTap: () {},
                  ),
                  HelpItemCard(
                    title: '¿Cómo retirar mi pedido?',
                    onTap: () {},
                  ),
                  HelpItemCard(
                    title: '¿Cómo cancelar mi pedido?',
                    onTap: () {},
                  ),
                  HelpItemCard(
                    title: '¿Cómo reclamar mi pedido?',
                    onTap: () {},
                  ),
                  HelpItemCard(
                    title: '¿Cómo calificar mi pedido?',
                    onTap: () {},
                  ),
                  HelpItemCard(
                    title: '¿Cómo contactar a soporte?',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HelpItemCard extends StatelessWidget {
  const HelpItemCard({super.key, required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
