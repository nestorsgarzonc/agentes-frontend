import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oyt_front_widgets/error/error_screen.dart';
import 'package:restaurants/features/bill/ui/bill_screen.dart';
import 'package:restaurants/features/bill/ui/individual_pay_screen.dart';
import 'package:oyt_front_product/models/product_model.dart';
import 'package:restaurants/features/product/ui/product_detail.dart';
import 'package:restaurants/features/auth/ui/login_screen.dart';
import 'package:restaurants/features/auth/ui/restore_password_screen.dart';
import 'package:restaurants/features/home/ui/index_menu_screen.dart';
import 'package:restaurants/features/on_boarding/ui/on_boarding.dart';
import 'package:restaurants/features/auth/ui/register_screen.dart';
import 'package:restaurants/features/orders/ui/list_of_orders.dart';
import 'package:restaurants/features/payment/ui/payment_screen.dart';
import 'package:restaurants/features/table/ui/table_qr_reader_screen.dart';

final routerProvider = Provider<CustomRouter>((ref) {
  return CustomRouter();
});

class CustomRouter {
  CustomRouter();

  static String atributeErrorMessage(String atribute) {
    return 'Es necesario el parametro $atribute';
  }

  final goRouter = GoRouter(
    initialLocation: OnBoarding.route,
    errorBuilder: (context, state) {
      if (state.error == null) {
        return const ErrorScreen();
      }
      return ErrorScreen(error: state.error.toString());
    },
    routes: routes,
  );

  static List<GoRoute> get routes => [
        GoRoute(path: OnBoarding.route, builder: (context, state) => const OnBoarding()),
        GoRoute(
          path: BillScreen.route,
          builder: (context, state) {
            final transactionId = state.queryParams['transactionId'];
            return transactionId == null
                ? ErrorScreen(error: atributeErrorMessage('transactionId'))
                : BillScreen(transactionId: transactionId);
          },
        ),
        GoRoute(
          path: TableQrReaderScreen.route,
          builder: (context, state) => const TableQrReaderScreen(),
        ),
        GoRoute(
          path: IndividualPayScreen.route,
          builder: (context, state) => const IndividualPayScreen(),
        ),
        GoRoute(
          path: IndexMenuScreen.route,
          builder: (context, state) {
            final tableId = state.queryParams['tableId'];
            return tableId == null
                ? ErrorScreen(error: atributeErrorMessage('tableId'))
                : IndexMenuScreen(tableId: tableId);
          },
        ),
        GoRoute(path: RegisterScreen.route, builder: (context, state) => const RegisterScreen()),
        GoRoute(
          path: ErrorScreen.route,
          builder: (context, state) {
            final error = (state.extra as Map<String, dynamic>)['error'];
            if (error == null) {
              return const ErrorScreen();
            }
            return ErrorScreen(error: error);
          },
        ),
        GoRoute(
          path: LoginScreen.route,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: PaymentScreen.route,
          builder: (context, state) => const PaymentScreen(),
        ),
        GoRoute(
          path: RestorePasswordScreen.route,
          builder: (context, state) => const RestorePasswordScreen(),
        ),
        GoRoute(
          path: ListOfOrdersScreen.route,
          builder: (context, state) => const ListOfOrdersScreen(),
        ),
        GoRoute(
          path: ProductDetail.route,
          builder: (context, state) {
            final productId = state.queryParams['productId'];
            final prodDetail = state.extra as ProductDetailModel?;
            if (productId == null) {
              return ErrorScreen(error: atributeErrorMessage('productId'));
            } else {
              return ProductDetail(productId: productId, order: prodDetail);
            }
          },
        ),
      ];

  BuildContext get context =>
      goRouter.routeInformationParser.configuration.navigatorKey.currentState!.context;

  GoRouter get router => goRouter;
}
