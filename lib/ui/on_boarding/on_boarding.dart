import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_core/constants/lotti_assets.dart';
import 'package:restaurants/features/table/provider/table_provider.dart';
import 'package:restaurants/ui/table/table_qr_reader_screen.dart';
import 'package:oyt_front_widgets/widgets/bottom_sheet/table_code_sheet.dart';
import 'package:oyt_front_widgets/widgets/divider.dart';
import 'package:oyt_front_widgets/widgets/buttons/custom_elevated_button.dart';

class OnBoarding extends ConsumerWidget {
  const OnBoarding({Key? key}) : super(key: key);
  static const route = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Lottie.asset(
              LottieAssets.food,
              width: size.width,
              height: size.height * 0.44,
            ),
            const CustomDivider(),
            AnimatedTextKit(
              totalRepeatCount: 1,
              animatedTexts: [
                TyperAnimatedText(
                  'On Your Table',
                  speed: const Duration(milliseconds: 100),
                  textStyle: Theme.of(context).textTheme.headline4?.copyWith(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ],
            ),
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

// class OnBoarding extends ConsumerStatefulWidget {
//   const OnBoarding({Key? key}) : super(key: key);

//   static const route = '/';

//   @override
//   createState() => _OnBoardingState();
// }

// class _OnBoardingState extends ConsumerState<OnBoarding> {
//   ApiResponse? response;
//   String? token;

//   @override
//   void initState() {
//     super.initState();
//     socketInit();
//   }

//   void socketInit() {
//     final socket = ref.read(socketProvider);
//     Logger.log("Starting");
//     socket.connect();
//     socket.onConnect((_) {
//       Logger.log('connect');
//       socket.emit('msg', 'test');
//     });
//     socket.onMap('new_user_joined', (data) => Logger.log(data.toString()));
//     socket.onDisconnect((_) => Logger.log('disconnect'));
//     socket.on('fromServer', (_) => Logger.log(_));
//     socket.emit('join_to_restaurant_table', json.encode({"table_id": "1234"}));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('OnBoarding'),
//       ),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: () async {
//               response = await ref
//                   .read(apiHandlerProvider)
//                   .post('/api/auth/login', {"email": "test@test.com", "password": "3213123123"});
//               print(response?.responseMap.toString());
//               setState(() {});
//             },
//             child: const Text('Make petition'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               await ref.read(dbProvider).put(
//                     DbConstants.authBox,
//                     response?.responseMap?['token'] ?? '',
//                     DbConstants.bearerTokenKey,
//                   );
//             },
//             child: const Text('Save token'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               token =
//                   await ref.read(dbProvider).get(DbConstants.authBox, DbConstants.bearerTokenKey);
//               setState(() {});
//             },
//             child: const Text('Get token'),
//           ),
//           if (token != null) Text(token!),
//         ],
//       ),
//     );
//   }
// }
