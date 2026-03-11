import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/contract_repository.dart';
import '../repositories/contract_repository_impl.dart';

final contractRepositoryProvider = FutureProvider<ContractRepository>((
  ref,
) async {
  return await ContractRepositoryImpl.create();
});
