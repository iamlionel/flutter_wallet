import 'dart:convert';

import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hex/hex.dart';
import 'package:web3dart/web3dart.dart';

import '../../domain/models/wallet_model.dart';
import '../../domain/repositories/phrase_repository.dart';
import 'package:bip39/bip39.dart' as bip39;

class PhraseRepositoryImpl extends PhraseRepository {
  PhraseRepositoryImpl({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  String getMnemonics() {
    return bip39.generateMnemonic();
  }

  @override
  Future<String> generatePrivatekey(String mnemonics) async {
    final seedBytes = bip39.mnemonicToSeed(mnemonics);
    final masterKey = await ED25519_HD_KEY.getMasterKeyFromSeed(seedBytes);
    final privateKey = HEX.encode(masterKey.key);
    return privateKey;
  }

  @override
  Future<EthereumAddress> generatePublickey(String privateKeyHex) async {
    final privateKey = EthPrivateKey.fromHex(privateKeyHex);
    final publicAddress = await privateKey.extractAddress();
    return publicAddress;
  }

  @override
  Future<void> saveData(WalletModel data, String password) async {
    final salt = IV.fromSecureRandom(16);
    final secretKey = Key.fromUtf8(password).stretch(16, salt: salt.bytes);
    final jsonData = json.encode(data.toJson());
    final iv = IV.fromSecureRandom(16);
    final encrypter = Encrypter(AES(secretKey, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(jsonData, iv: iv);

    await _storage.write(key: 'data', value: encrypted.base64);
    await _storage.write(key: 'iv', value: iv.base64);
    await _storage.write(key: 'salt', value: salt.base64);
  }
}
