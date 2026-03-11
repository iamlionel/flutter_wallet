// lib/domain/repositories/chain_adapter.dart
import 'dart:typed_data';

import '../models/chain_id.dart';
import '../models/transaction_model.dart';

abstract class ChainAdapter {
  ChainId get chainId;
  String get name;
  String get nativeSymbol;
  int get nativeDecimals; // 18 for ETH, 8 for BTC, 9 for SOL

  /// Derive the chain address from BIP39 seed bytes.
  Future<String> deriveAddress(Uint8List seedBytes);

  /// Get the native token balance for [address].
  /// Returns amount in human-readable units (ETH, BTC, SOL).
  Future<double> getNativeBalance(String address);

  /// Get recent transactions for [address].
  Future<List<TransactionModel>> getTransactions(String address);
}
