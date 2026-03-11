import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import '../../app/env_config.dart';
import '../../domain/models/transaction_model.dart';
import '../../domain/repositories/contract_repository.dart';
import '../../domain/repositories/phrase_repository.dart';
import 'phrase_repository_impl.dart';

class ContractRepositoryImpl extends ContractRepository {
  ContractRepositoryImpl._internal({
    Web3Client? web3Client,
    PhraseRepository? phraseRepository,
  }) : _web3client = web3Client ?? Web3Client(EnvConfig.baseUrl, http.Client()),
       _phraseRepository = phraseRepository ?? PhraseRepositoryImpl();

  final Web3Client _web3client;
  final PhraseRepository _phraseRepository;
  ContractAbi? _erc20Abi;
  final StreamController<EtherAmount> _ethBalanceController =
      StreamController<EtherAmount>();

  static const _etherscanBase = 'https://api.etherscan.io/api';

  static Future<ContractRepositoryImpl> create({
    Web3Client? web3Client,
    PhraseRepository? phraseRepository,
  }) async {
    final repository = ContractRepositoryImpl._internal(
      web3Client: web3Client,
      phraseRepository: phraseRepository,
    );
    await repository.initialize();
    return repository;
  }

  @override
  Future<void> initialize() async {
    try {
      final erc20AbiString = await rootBundle.loadString(
        'assets/abi/ERC-20.json',
      );
      _erc20Abi = ContractAbi.fromJson(erc20AbiString, 'ERC20');
    } catch (e) {
      rethrow;
    }
  }

  Future<EtherAmount> _getEth(String publicKey) async {
    final ethAddress = EthereumAddress.fromHex(publicKey);
    final response = await _web3client.getBalance(ethAddress);
    return response;
  }

  @override
  Stream<EtherAmount> getEthBalance(String publicKey) async* {
    yield* Stream<Future<EtherAmount>>.periodic(
      const Duration(seconds: 5),
      (_) => _getEth(publicKey),
    ).asyncMap((event) async => event);
  }

  @override
  Future<String> getTokenBalance(
    String contractAddress,
    String publicKey,
  ) async {
    final contract = DeployedContract(
      _erc20Abi!,
      EthereumAddress.fromHex(contractAddress),
    );
    final walletAddress = EthereumAddress.fromHex(publicKey);
    final response = await _web3client.call(
      contract: contract,
      function: contract.function('balanceOf'),
      params: <dynamic>[walletAddress],
    );
    print(response);
    return response.first as String;
  }

  @override
  Future<String> getTokenDecimal(String contractAddress) async {
    final contract = DeployedContract(
      _erc20Abi!,
      EthereumAddress.fromHex(contractAddress),
    );
    final response = await _web3client.call(
      contract: contract,
      function: contract.function('decimals'),
      params: <dynamic>[],
    );
    print(response);
    return response.first.toString();
  }

  @override
  Future<String> getTokenSymbol(String contractAddress) async {
    final contract = DeployedContract(
      _erc20Abi!,
      EthereumAddress.fromHex(contractAddress),
    );
    final response = await _web3client.call(
      contract: contract,
      function: contract.function('symbol'),
      params: <dynamic>[],
    );
    print(response);
    return response.first as String;
  }

  @override
  Future<double> getEthUsdPrice() async {
    final uri = Uri.parse(
      '$_etherscanBase?module=stats&action=ethprice',
    );
    final response = await http.get(uri);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['status'] == '1') {
      final result = json['result'] as Map<String, dynamic>;
      return double.parse(result['ethusd'] as String);
    }
    return 0.0;
  }

  @override
  Future<List<TransactionModel>> getEthTransactions(String address) async {
    final uri = Uri.parse(
      '$_etherscanBase?module=account&action=txlist'
      '&address=$address&startblock=0&endblock=99999999'
      '&page=1&offset=20&sort=desc',
    );
    final response = await http.get(uri);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['status'] == '1') {
      final results = json['result'] as List<dynamic>;
      return results
          .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<List<TransactionModel>> getErc20Transactions(String address) async {
    final uri = Uri.parse(
      '$_etherscanBase?module=account&action=tokentx'
      '&address=$address&startblock=0&endblock=99999999'
      '&page=1&offset=20&sort=desc',
    );
    final response = await http.get(uri);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['status'] == '1') {
      final results = json['result'] as List<dynamic>;
      return results
          .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>)
              .copyWith(isErc20: true))
          .toList();
    }
    return [];
  }

  @override
  Future<List> getTransactions(String contractAddress) {
    // TODO: implement getTransactions
    throw UnimplementedError();
  }

  @override
  Future<String> sendEth({
    required String privateKey,
    required String to,
    required BigInt amount,
  }) async {
    final ethAddress = await _phraseRepository.generatePublicKey(privateKey);
    final Credentials credentials = EthPrivateKey.fromHex(privateKey);
    final toAddress = EthereumAddress.fromHex(to);
    final transaction = Transaction(
      from: ethAddress,
      to: toAddress,
      value: EtherAmount.inWei(amount),
    );
    final response = await _web3client.sendTransaction(
      credentials,
      transaction,
      chainId: 11155111,
    );
    return response;
  }

  @override
  void dispose() {
    _web3client.dispose();
    _ethBalanceController.close();
  }
}
