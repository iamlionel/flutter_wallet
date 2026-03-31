import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/config/env_config.dart';
import '../../domain/entities/chain_id.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/chain_adapter.dart';

class BtcChainAdapter implements ChainAdapter {
  @override
  ChainId get chainId => ChainId.bitcoin;

  @override
  String get name => 'Bitcoin';

  @override
  String get nativeSymbol => 'BTC';

  @override
  int get nativeDecimals => 8;

  @override
  Future<double> getNativeBalance(String address) async {
    try {
      final uri = Uri.parse('${EnvConfig.btcUrl}/address/$address');
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return 0.0;
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final chainStats = json['chain_stats'] as Map<String, dynamic>;
      final funded = (chainStats['funded_txo_sum'] as num).toInt();
      final spent = (chainStats['spent_txo_sum'] as num).toInt();
      return (funded - spent) / 1e8;
    } catch (_) {
      return 0.0;
    }
  }

  @override
  Future<List<Transaction>> getTransactions(String address) async => [];
}
