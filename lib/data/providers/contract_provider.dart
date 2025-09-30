import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web3dart/web3dart.dart';

import '../../domain/repositories/contract_repository.dart';
import '../repositories/contract_repository_impl.dart';

final contractRepositoryProvider = FutureProvider<ContractRepository>((
  ref,
) async {
  return await ContractRepositoryImpl.create();
});

final ethBalanceProvider = StreamProvider.family<EtherAmount?, String>((
  ref,
  publicKey,
) async* {
  if (publicKey.isEmpty) return;
  final contractRepository = await ref.read(contractRepositoryProvider.future);
  yield* contractRepository.getEthBalance(publicKey);
});
