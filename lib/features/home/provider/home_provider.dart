import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeScreenProvider = StateNotifierProvider<HomeScreenProvider, int>((ref) {
  return HomeScreenProvider();
});

class HomeScreenProvider extends StateNotifier<int> {
  HomeScreenProvider() : super(0);

  void onNavigate(int index) => state = index;
}
