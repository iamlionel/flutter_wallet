import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/token_asset_model.dart';
import '../../domain/repositories/contract_repository.dart';
import '../../domain/states/add_token_state.dart';

class AddTokenNotifier extends StateNotifier<AddTokenState> {
  AddTokenNotifier({required ContractRepository contractRepository})
    : _contractRepository = contractRepository,
      super(const AddTokenState());

  final ContractRepository _contractRepository;

  void onContractAddressChanged(String address) {
    state = state.copyWith(contractAddress: address);

    _getContractDetails();
  }

  TokenAssetModel? get currentToken {
    if (state.tokenSymbol.isEmpty) return null;
    return TokenAssetModel(
      contractAddress: state.contractAddress,
      symbol: state.tokenSymbol,
      decimal: state.tokenDecimal,
    );
  }

  Future<void> _getContractDetails() async {
    if (state.contractAddress.length < 40) return;
    state = state.copyWith(status: AddTokenStatus.loading);

    try {
      final symbol = await _contractRepository.getTokenSymbol(
        state.contractAddress,
      );
      final decimal = await _contractRepository.getTokenDecimal(
        state.contractAddress,
      );
      state = state.copyWith(
        tokenDecimal: decimal,
        tokenSymbol: symbol,
        status: AddTokenStatus.success,
      );
    } catch (e) {
      state = state.copyWith(status: AddTokenStatus.failure);
      print('Error fetching token details: $e');
    }
  }
}
