import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/transaction.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
abstract class TransactionModel with _$TransactionModel {
  const TransactionModel._();

  const factory TransactionModel({
    required String hash,
    required String from,
    required String to,
    required String value,
    required String timeStamp, // unix timestamp string from Etherscan
    required String isError,   // "0" = success, "1" = failed
    @Default('') String tokenSymbol,
    @Default('') String tokenDecimal,
    @Default(false) bool isErc20,
    @Default('eth') String chain,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  Transaction toEntity() => Transaction(
        hash: hash,
        from: from,
        to: to,
        value: value,
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          (int.tryParse(timeStamp) ?? 0) * 1000,
        ),
        isSuccess: isError == '0',
        tokenSymbol: tokenSymbol,
        tokenDecimal: tokenDecimal,
        isErc20: isErc20,
        chain: chain,
      );
}
