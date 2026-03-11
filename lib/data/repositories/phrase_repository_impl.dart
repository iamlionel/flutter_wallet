import 'dart:convert';
import 'dart:typed_data';

import 'package:bech32/bech32.dart';
import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;
import 'package:bs58/bs58.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hex/hex.dart';
import 'package:pinenacl/ed25519.dart';
import 'package:pointycastle/digests/ripemd160.dart';
import 'package:web3dart/web3dart.dart';

import '../../domain/models/chain_id.dart';
import '../../domain/models/wallet_model.dart';
import '../../domain/repositories/phrase_repository.dart';

class IncorrectPasswordException implements Exception {}

class PhraseRepositoryImpl extends PhraseRepository {
  PhraseRepositoryImpl({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Stream<AuthStatus> get status async* {
    final data = await _storage.read(key: 'data');
    final ivData = await _storage.read(key: 'iv');
    final salt = await _storage.read(key: 'salt');
    if (data != null && ivData != null && salt != null) {
      yield AuthStatus.authenticated;
    } else {
      yield AuthStatus.unauthenticated;
    }
  }

  @override
  String getMnemonics() {
    return bip39.generateMnemonic();
  }

  @override
  Future<String> generatePrivatekey(String mnemonics) async {
    final seedBytes = bip39.mnemonicToSeed(mnemonics);
    final root = bip32.BIP32.fromSeed(seedBytes);
    final child = root.derivePath("m/44'/60'/0'/0/0");
    return HEX.encode(child.privateKey!);
  }

  @override
  Future<EthereumAddress> generatePublicKey(String privateKeyHex) async {
    final privateKey = EthPrivateKey.fromHex(privateKeyHex);
    final publicAddress = privateKey.address;
    return publicAddress;
  }

  @override
  Future<WalletModel> deriveAllAddresses(String mnemonics) async {
    if (!bip39.validateMnemonic(mnemonics)) {
      throw ArgumentError('Invalid mnemonic phrase');
    }

    final seedBytes = bip39.mnemonicToSeed(mnemonics);

    // ── ETH (secp256k1, m/44'/60'/0'/0/0) ───────────────────────────────────
    final root = bip32.BIP32.fromSeed(seedBytes);
    final ethChild = root.derivePath("m/44'/60'/0'/0/0");
    final ethPrivKey = HEX.encode(ethChild.privateKey!);
    final ethCredentials = EthPrivateKey(ethChild.privateKey!);
    final ethAddress = ethCredentials.address.hex;

    // ── BTC (secp256k1, m/84'/0'/0'/0/0, P2WPKH bech32) ─────────────────────
    final btcChild = root.derivePath("m/84'/0'/0'/0/0");
    final btcPubKey = btcChild.publicKey; // compressed 33 bytes
    final sha256Hash = crypto.sha256.convert(btcPubKey).bytes;
    final ripemd = RIPEMD160Digest()
        .process(Uint8List.fromList(sha256Hash));
    final converted = _convertBits(ripemd, 8, 5, pad: true);
    final bech32Data = Bech32('bc', [0, ...converted]);
    final btcAddress = const Bech32Codec().encode(bech32Data);

    // ── SOL (ed25519, m/44'/501'/0'/0') ──────────────────────────────────────
    final solDerived = await ED25519_HD_KEY.derivePath(
      "m/44'/501'/0'/0'",
      seedBytes,
    );
    final signingKey = SigningKey.fromSeed(Uint8List.fromList(solDerived.key));
    final solAddress = base58.encode(
      Uint8List.fromList(signingKey.verifyKey.asTypedList),
    );

    return WalletModel(
      privateKey: ethPrivKey,
      publicKey: ethAddress,
      addresses: {
        ChainId.ethereum.key: ethAddress,
        ChainId.bitcoin.key: btcAddress,
        ChainId.solana.key: solAddress,
      },
    );
  }

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

  @override
  Future<WalletModel?> retrieveData(String password) async {
    try {
      final data = await _storage.read(key: 'data');
      final iv = await _storage.read(key: 'iv');
      final salt = await _storage.read(key: 'salt');
      if (data == null || iv == null || salt == null) return null;
      final secretKey = Key.fromUtf8(
        password,
      ).stretch(16, salt: IV.fromBase64(salt).bytes);
      final encrypter = Encrypter(AES(secretKey, mode: AESMode.cbc));
      final encrypted = encrypter.decrypt(
        Encrypted.fromBase64(data),
        iv: IV.fromBase64(iv),
      );
      final jsonData = jsonDecode(encrypted) as Map<String, dynamic>;
      return WalletModel.fromJson(jsonData);
    } catch (e) {
      throw IncorrectPasswordException();
    }
  }
}
