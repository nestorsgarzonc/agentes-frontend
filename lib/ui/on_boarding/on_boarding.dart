import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_widgets/widgets/cards/on_boarding_animation_title.dart';
import 'package:restaurants/features/table/provider/table_provider.dart';
import 'package:restaurants/ui/table/table_qr_reader_screen.dart';
import 'package:oyt_front_widgets/bottom_sheet/table_code_sheet.dart';
import 'package:oyt_front_widgets/widgets/divider.dart';
import 'package:oyt_front_widgets/widgets/buttons/custom_elevated_button.dart';

class OnBoarding extends ConsumerWidget {
  const OnBoarding({Key? key}) : super(key: key);
  static const route = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const OnboardingAnimationTitle(),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Escanea o ingresa el codigo QR de tu mesa para comenzar tu experiencia.',
                style: TextStyle(color: Colors.black87),
              ),
            ),
            const Spacer(),
            CustomElevatedButton(
              onPressed: () => handleOnScan(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.qr_code_2_outlined),
                  SizedBox(width: 8),
                  Text('Escanear codigo QR'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => handleOnWriteCode(context, ref),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.text_snippet_outlined),
                  SizedBox(width: 8),
                  Text('Ingresar codigo manual'),
                ],
              ),
            ),
            const CustomDivider(),
          ],
        ),
      ),
    );
  }

  void handleOnScan(BuildContext context) => GoRouter.of(context).push(TableQrReaderScreen.route);

  void handleOnWriteCode(BuildContext context, WidgetRef ref) {
    TableCodeBottomSheet.showManualCodeSheet(
      context: context,
      onAccept: ref.read(tableProvider.notifier).onReadTableCode,
    );
  }
}
