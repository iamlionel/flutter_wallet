import 'dart:convert';
import 'dart:typed_data';

import 'package:bech32/bech32.dart';
import 'package:bip32/bip32.dart' as bip32;
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:pointycastle/digests/ripemd160.dart';

import '../../domain/models/chain_id.dart';
import '../../domain/models/transaction_model.dart';
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
  Future<String> deriveAddress(Uint8List seedBytes) async {
    // BIP84 BTC path: m/84'/0'/0'/0/0 (secp256k1, P2WPKH bech32)
    final root = bip32.BIP32.fromSeed(seedBytes);
    final child = root.derivePath("m/84'/0'/0'/0/0");
    final pubKey = child.publicKey; // 33-byte compressed public key

    // SHA256 then RIPEMD160 (Hash160)
    final sha256Hash = sha256.convert(pubKey).bytes;
    final ripemd = RIPEMD160Digest().process(Uint8List.fromList(sha256Hash));

    // Bech32 P2WPKH: witness version 0 + 5-bit converted hash
    final converted = _convertBits(ripemd, 8, 5, pad: true);
    final bech32Data = Bech32('bc', [0, ...converted]);
    return const Bech32Codec().encode(bech32Data);
  }

  @override
  Future<double> getNativeBalance(String address) async {
    try {
      final uri = Uri.parse('https://mempool.space/api/address/$address');
      final response = await http.get(uri);
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
  Future<List<TransactionModel>> getTransactions(String address) async => [];

  // Copy of the private _convertBits from phrase_repository_impl.dart
  List<int> _convertBits(List<int> data, int from, int to, {required bool pad}) {
    var acc = 0;
    var bits = 0;
    final result = <int>[];
    final maxv = (1 << to) - 1;
    for (final value in data) {
      acc = (acc << from) | value;
      bits += from;
      while (bits >= to) {
        bits -= to;
        result.add((acc >> bits) & maxv);
      }
    }
    if (pad && bits > 0) {
      result.add((acc << (to - bits)) & maxv);
    }
    return result;
  }
}
