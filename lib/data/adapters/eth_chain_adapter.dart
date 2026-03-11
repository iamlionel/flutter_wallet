import 'dart:typed_data';

import 'package:bip32/bip32.dart' as bip32;
import 'package:web3dart/web3dart.dart';

import '../../domain/models/chain_id.dart';
import '../../domain/models/transaction_model.dart';
import '../../domain/repositories/chain_adapter.dart';
import '../repositories/contract_repository_impl.dart';

class EthChainAdapter implements ChainAdapter {
  EthChainAdapter(this._contractRepo);

  final ContractRepositoryImpl _contractRepo;

  @override
  ChainId get chainId => ChainId.ethereum;

  @override
  String get name => 'Ethereum';

  @override
  String get nativeSymbol => 'ETH';

  @override
  int get nativeDecimals => 18;

  @override
  Future<String> deriveAddress(Uint8List seedBytes) async {
    // BIP44 ETH path: m/44'/60'/0'/0/0 (secp256k1 via bip32)
    final root = bip32.BIP32.fromSeed(seedBytes);
    final child = root.derivePath("m/44'/60'/0'/0/0");
    final credentials = EthPrivateKey(child.privateKey!);
    return credentials.address.hex;
  }

  @override
  Future<double> getNativeBalance(String address) async {
    // getEthBalance returns a periodic stream; take the first emission
    final balance = await _contractRepo.getEthBalance(address).first;
    final wei = balance.getInWei;
    final ethWhole = wei ~/ BigInt.from(10).pow(18);
    final ethFrac = wei % BigInt.from(10).pow(18);
    return ethWhole.toDouble() + ethFrac.toDouble() / 1e18;
  }

  @override
  Future<List<TransactionModel>> getTransactions(String address) async {
    return _contractRepo.getEthTransactions(address);
  }
}
