import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oyt_front_widgets/error/error_screen.dart';
import 'package:diner/features/bill/ui/bill_screen.dart';
import 'package:diner/features/bill/ui/individual_pay_screen.dart';
import 'package:oyt_front_product/models/product_model.dart';
import 'package:diner/features/product/ui/product_detail.dart';
import 'package:diner/features/auth/ui/login_screen.dart';
import 'package:diner/features/auth/ui/restore_password_screen.dart';
import 'package:diner/features/home/ui/index_menu_screen.dart';
import 'package:diner/features/on_boarding/ui/on_boarding.dart';
import 'package:diner/features/auth/ui/register_screen.dart';
import 'package:diner/features/orders/ui/list_of_orders.dart';
import 'package:diner/features/payment/ui/payment_screen.dart';
import 'package:diner/features/table/ui/table_qr_reader_screen.dart';

final routerProvider = Provider<CustomRouter>((ref) {
  return CustomRouter();
});

class CustomRouter {
  CustomRouter();

  static String atributeErrorMessage(String atribute) {
    return 'Es necesario el parametro $atribute';
  }

  static final globalKey = GlobalKey<NavigatorState>();

  final goRouter = GoRouter(
    initialLocation: OnBoarding.route,
    navigatorKey: globalKey,
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
            final canPop = state.queryParams['canPop'] == 'true';
            final individualPaymentWay = state.queryParams['individualPaymentWay'];
            return transactionId == null || individualPaymentWay == null
                ? ErrorScreen(error: atributeErrorMessage('transactionId'))
                : BillScreen(transactionId: transactionId, canPop: canPop, individualPaymentWay: individualPaymentWay,);
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
            final restaurantId = state.queryParams['restaurantId'];
            return (tableId == null && restaurantId == null)
                ? ErrorScreen(error: atributeErrorMessage('tableId o restaurantId'))
                : IndexMenuScreen(tableId: tableId, restaurantId: restaurantId);
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

  BuildContext get context => globalKey.currentState!.context;

  GoRouter get router => goRouter;
}
