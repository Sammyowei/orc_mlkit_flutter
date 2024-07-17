import 'package:hooks_riverpod/hooks_riverpod.dart';

final textNotifierProvider = StateNotifierProvider<TextNotifier, String>((ref) {
  return TextNotifier();
});

final loadingStateProvider =
    StateNotifierProvider<BooleanNotifier, bool>((ref) {
  return BooleanNotifier();
});

class TextNotifier extends StateNotifier<String> {
  TextNotifier() : super('');

  void setState(String text) {
    state = text;
  }

  void reset() {
    state = '';
  }
}

class BooleanNotifier extends StateNotifier<bool> {
  BooleanNotifier() : super(false);

  void toggle() {
    state = !state;
  }
}
