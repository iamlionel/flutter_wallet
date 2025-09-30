import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/states/add_token_state.dart';
import 'add_token_notifier.dart';
import 'contract_provider.dart';

final addTokenProvider = StateNotifierProvider<AddTokenNotifier, AddTokenState>(
  (ref) {
    final contractRepository = ref.watch(contractRepositoryProvider).value;
    return AddTokenNotifier(contractRepository: contractRepository!);
  },
);
