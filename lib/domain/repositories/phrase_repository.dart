import 'package:web3dart/web3dart.dart';

import '../models/wallet_model.dart';

enum AuthStatus { authenticated, unauthenticated, unknown }

abstract class PhraseRepository {
  Future<String> generatePrivatekey(String mnemonics);

  Future<EthereumAddress> generatePublicKey(String privateKeyHex);

  Future<void> saveData(WalletModel data, String password);

  Future<WalletModel?> retrieveData(String password);

  String getMnemonics();

  Stream<AuthStatus> get status;
}
