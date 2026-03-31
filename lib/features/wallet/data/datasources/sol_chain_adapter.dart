import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/config/env_config.dart';
import '../../domain/entities/chain_id.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/chain_adapter.dart';

class SolChainAdapter implements ChainAdapter {
  @override
  ChainId get chainId => ChainId.solana;

  @override
  String get name => 'Solana';

  @override
  String get nativeSymbol => 'SOL';

  @override
  int get nativeDecimals => 9;

  @override
  Future<double> getNativeBalance(String address) async {
    try {
      final uri = Uri.parse(EnvConfig.solanaUrl);
      final body = jsonEncode({
        'jsonrpc': '2.0',
        'id': 1,
        'method': 'getBalance',
        'params': [address],
      });
      final response = await http
          .post(uri, headers: {'Content-Type': 'application/json'}, body: body)
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return 0.0;
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final result = json['result'] as Map<String, dynamic>;
      final lamports = (result['value'] as num).toInt();
      return lamports / 1e9;
    } catch (_) {
      return 0.0;
    }
  }

  @override
  Future<List<Transaction>> getTransactions(String address) async => [];
}
