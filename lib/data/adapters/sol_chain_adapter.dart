import 'dart:convert';
import 'dart:typed_data';

import 'package:bs58/bs58.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:http/http.dart' as http;
import 'package:pinenacl/ed25519.dart';

import '../../app/env_config.dart';
import '../../domain/models/chain_id.dart';
import '../../domain/models/transaction_model.dart';
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
  Future<String> deriveAddress(Uint8List seedBytes) async {
    // SLIP10 ed25519 derivation: m/44'/501'/0'/0'
    final keyData = await ED25519_HD_KEY.derivePath(
      "m/44'/501'/0'/0'",
      seedBytes,
    );
    final signingKey = SigningKey.fromSeed(Uint8List.fromList(keyData.key));
    return base58.encode(signingKey.verifyKey.asTypedList);
  }

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
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      ).timeout(const Duration(seconds: 10));
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
  Future<List<TransactionModel>> getTransactions(String address) async => [];
}
