class HelpMenuItem {
  const HelpMenuItem({required this.title, required this.content});

  final String title;
  final String content;

  static const List<HelpMenuItem> items = [
    HelpMenuItem(
      title: 'Llamar mesero',
      content:
          'Al lado del menú del restaurante hay un botón en la parte inferior derecha en que aparece un ícono de una persona. Si lo presionas llamarás al mesero que se te asignó.',
    ),
    HelpMenuItem(
      title: 'Pedir la cuenta',
      content: 'Luego de comer, puedes presionar el botón de "Pedir cuenta" para pedir la cuenta.',
    ),
    HelpMenuItem(
      title: '¿Cómo ordenar?',
      content:
          'Dentro del menú del restaurante, presionas el platillo que quieres pedir. Esto te llevará a la pantalla de detalle de este producto, desde donde podrás ordenar uno o más de este platillo.',
    ),
    HelpMenuItem(
      title: '¿Cómo pagar?',
      content:
          'Luego de pedir la cuenta, te aparecerá una pantalla en que se muestre el precio a pagar, y al final de la lista de costos, habrá un botón para realizar el pago.',
    ),
    HelpMenuItem(
      title: '¿Cómo cancelar mi pedido?',
      content:
          'Luego de hacer el pedido, aparacerá la pantalla de estado del pedido, desde donde podrás cancelarlo presionando el botón de "Cancelar" en la parte inferior izquierda.',
    ),
    HelpMenuItem(
      title: '¿Cómo reclamar mi pedido?',
      content:
          'Cuando se te sea notificado que tu pedido ya está terminado, podrás acercarte al lugar especificado por el restaurante para reclamarlo.',
    ),
    HelpMenuItem(
      title: '¿Cómo calificar a mi mesero?',
      content:
          'Tras pagar tu cuenta, se te pedirá dar una calificación tanto al restaurante como al servicio al cliente, este último califica al mesero.',
    ),
    HelpMenuItem(
      title: '¿Cómo calificar mi pedido?',
      content:
          'Tras pagar tu cuenta, se te pedirá dar una calificación al restaurante, en que se incluye una calificación al platillo que pediste.',
    ),
  ];
}
