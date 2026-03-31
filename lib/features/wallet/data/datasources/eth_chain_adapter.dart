import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';

import '../../../../core/config/env_config.dart';
import '../../domain/entities/chain_id.dart';
import '../../domain/entities/transaction.dart' as domain;
import '../../domain/repositories/chain_adapter.dart';
import '../models/transaction_model.dart';

class EthChainAdapter implements ChainAdapter {
  EthChainAdapter._({
    required Web3Client web3Client,
    required ContractAbi erc20Abi,
  }) : _web3client = web3Client,
       _erc20Abi = erc20Abi;

  final Web3Client _web3client;
  final ContractAbi _erc20Abi;

  static const _etherscanBase = 'https://api.etherscan.io/api';

  static Future<EthChainAdapter> create() async {
    final web3Client = Web3Client(EnvConfig.baseUrl, http.Client());
    final abiString = await rootBundle.loadString('assets/abi/ERC-20.json');
    final erc20Abi = ContractAbi.fromJson(abiString, 'ERC20');
    return EthChainAdapter._(web3Client: web3Client, erc20Abi: erc20Abi);
  }

  // ── ChainAdapter ────────────────────────────────────────────────────────────

  @override
  ChainId get chainId => ChainId.ethereum;

  @override
  String get name => 'Ethereum';

  @override
  String get nativeSymbol => 'ETH';

  @override
  int get nativeDecimals => 18;

  @override
  Future<double> getNativeBalance(String address) async {
    final balance = await _web3client.getBalance(
      EthereumAddress.fromHex(address),
    );
    return balance.getValueInUnit(EtherUnit.ether);
  }

  @override
  Future<List<domain.Transaction>> getTransactions(String address) async {
    final results = await Future.wait([
      _fetchEthTransactions(address),
      getErc20Transactions(address),
    ]);
    final all = [...results[0], ...results[1]];
    all.sort((a, b) {
      final bTs = int.tryParse(b.timeStamp) ?? 0;
      final aTs = int.tryParse(a.timeStamp) ?? 0;
      return bTs.compareTo(aTs);
    });
    return all.take(20).map((m) => m.toEntity()).toList();
  }

  Future<List<TransactionModel>> _fetchEthTransactions(String address) async {
    try {
      final uri = Uri.parse(
        '$_etherscanBase?module=account&action=txlist'
        '&address=$address&startblock=0&endblock=99999999'
        '&page=1&offset=20&sort=desc',
      );
      final response = await http.get(uri);
      if (response.statusCode != 200) return [];
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['status'] == '1') {
        final results = json['result'] as List<dynamic>;
        return results
            .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  // ── ERC-20 & ETH-specific ───────────────────────────────────────────────────

  Future<String> getTokenSymbol(String contractAddress) async {
    final contract = _deployedContract(contractAddress);
    final result = await _web3client.call(
      contract: contract,
      function: contract.function('symbol'),
      params: [],
    );
    return result.first.toString();
  }

  Future<String> getTokenDecimal(String contractAddress) async {
    final contract = _deployedContract(contractAddress);
    final result = await _web3client.call(
      contract: contract,
      function: contract.function('decimals'),
      params: [],
    );
    return result.first.toString();
  }

  Future<String> getTokenBalance(
    String contractAddress,
    String publicKey,
  ) async {
    final contract = _deployedContract(contractAddress);
    final result = await _web3client.call(
      contract: contract,
      function: contract.function('balanceOf'),
      params: [EthereumAddress.fromHex(publicKey)],
    );
    return result.first.toString();
  }

  Future<List<TransactionModel>> getErc20Transactions(String address) async {
    try {
      final uri = Uri.parse(
        '$_etherscanBase?module=account&action=tokentx'
        '&address=$address&startblock=0&endblock=99999999'
        '&page=1&offset=20&sort=desc',
      );
      final response = await http.get(uri);
      if (response.statusCode != 200) return [];
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['status'] == '1') {
        final results = json['result'] as List<dynamic>;
        return results
            .map(
              (e) => TransactionModel.fromJson(
                e as Map<String, dynamic>,
              ).copyWith(isErc20: true),
            )
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<String> sendNative({
    required String privateKey,
    required String to,
    required BigInt amount,
  }) async {
    final credentials = EthPrivateKey.fromHex(privateKey);
    return _web3client.sendTransaction(
      credentials,
      Transaction(
        from: credentials.address,
        to: EthereumAddress.fromHex(to),
        value: EtherAmount.inWei(amount),
      ),
      chainId: 11155111,
    );
  }

  Future<EtherAmount> getGasPrice() => _web3client.getGasPrice();

  // ── Private ─────────────────────────────────────────────────────────────────

  DeployedContract _deployedContract(String contractAddress) =>
      DeployedContract(_erc20Abi, EthereumAddress.fromHex(contractAddress));
}
