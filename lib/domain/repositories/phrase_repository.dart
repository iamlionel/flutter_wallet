import 'package:web3dart/web3dart.dart';

import '../models/wallet_model.dart';

enum AuthStatus { authenticated, unauthenticated, unknown }

abstract class PhraseRepository {
  Future<String> generatePrivatekey(String mnemonics);

  Future<EthereumAddress> generatePublicKey(String privateKeyHex);

  /// Derive ETH, BTC, and SOL addresses from mnemonic seed.
  /// Returns a WalletModel with all addresses populated.
  Future<WalletModel> deriveAllAddresses(String mnemonics);

  Future<void> saveData(WalletModel data, String password);

  Future<WalletModel?> retrieveData(String password);

  String getMnemonics();

  Stream<AuthStatus> get status;
}
