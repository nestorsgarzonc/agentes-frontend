import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/features/auth/provider/auth_provider.dart';

class HelpMenuItem {
  const HelpMenuItem({required this.title, required this.content, this.onTap});

  final String title;
  final String content;
  final Function(WidgetRef ref)? onTap;

  static List<HelpMenuItem> items = [
    const HelpMenuItem(
      title: 'Llamar mesero',
      content:
          'Al lado del menú del restaurante hay un botón en la parte inferior derecha en que aparece un ícono de una persona. Si lo presionas llamarás al mesero que se te asignó.',
    ),
    const HelpMenuItem(
      title: 'Pedir la cuenta',
      content: 'Luego de comer, puedes presionar el botón de "Pedir cuenta" para pedir la cuenta.',
    ),
    const HelpMenuItem(
      title: '¿Cómo ordenar?',
      content:
          'Dentro del menú del restaurante, presionas el platillo que quieres pedir. Esto te llevará a la pantalla de detalle de este producto, desde donde podrás ordenar uno o más de este platillo.',
    ),
    const HelpMenuItem(
      title: '¿Cómo pagar?',
      content:
          'Luego de pedir la cuenta, te aparecerá una pantalla en que se muestre el precio a pagar, y al final de la lista de costos, habrá un botón para realizar el pago.',
    ),
    const HelpMenuItem(
      title: '¿Cómo cancelar mi pedido?',
      content:
          'Luego de hacer el pedido, aparacerá la pantalla de estado del pedido, desde donde podrás cancelarlo presionando el botón de "Cancelar" en la parte inferior izquierda.',
    ),
    const HelpMenuItem(
      title: '¿Cómo reclamar mi pedido?',
      content:
          'Cuando se te sea notificado que tu pedido ya está terminado, podrás acercarte al lugar especificado por el restaurante para reclamarlo.',
    ),
    const HelpMenuItem(
      title: '¿Cómo calificar a mi mesero?',
      content:
          'Tras pagar tu cuenta, se te pedirá dar una calificación tanto al restaurante como al servicio al cliente, este último califica al mesero.',
    ),
    const HelpMenuItem(
      title: '¿Cómo calificar mi pedido?',
      content:
          'Tras pagar tu cuenta, se te pedirá dar una calificación al restaurante, en que se incluye una calificación al platillo que pediste.',
    ),
    HelpMenuItem(
      title: 'Cerrar sesion',
      content: '',
      onTap: (ref) => ref.read(authProvider.notifier).logout(),
    )
  ];
}
