import 'package:flutter_riverpod/flutter_riverpod.dart';

final isAppLoadingProvider = StateProvider<bool>((ref) {
  return false;
});
