import 'package:web3dart/web3dart.dart' hide Wallet;

import '../../../wallet/domain/entities/wallet.dart';

enum AuthStatus { authenticated, unauthenticated, unknown }

class IncorrectPasswordException implements Exception {}

abstract class PhraseRepository {
  Future<String> generatePrivatekey(String mnemonics);

  Future<EthereumAddress> generatePublicKey(String privateKeyHex);

  Future<Wallet> deriveAllAddresses(String mnemonics);

  Future<void> saveData(Wallet data, String password);

  Future<void> saveMnemonics(String mnemonics, String password);

  Future<Wallet?> retrieveData(String password);

  String getMnemonics();

  Stream<AuthStatus> get status;
}
