import 'package:web3dart/web3dart.dart';

import '../models/wallet_model.dart';

enum AuthStatus { authenticated, unauthenticated, unknown }

abstract class PhraseRepository {
  Future<String> generatePrivatekey(String mnemonics);

  Future<EthereumAddress> generatePublickey(String privateKeyHex);

  Future<void> saveData(WalletModel data, String password);

  String getMnemonics();
}
