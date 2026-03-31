import '../entities/chain_id.dart';
import '../entities/transaction.dart';

/// Base interface shared by all chains (ETH, BTC, SOL, …).
abstract class ChainAdapter {
  ChainId get chainId;
  String get name;
  String get nativeSymbol;
  int get nativeDecimals; // 18 for ETH, 8 for BTC, 9 for SOL

  /// Get the native token balance for [address].
  /// Returns amount in human-readable units (ETH, BTC, SOL).
  Future<double> getNativeBalance(String address);

  /// Get recent native transactions for [address].
  Future<List<Transaction>> getTransactions(String address);
}
