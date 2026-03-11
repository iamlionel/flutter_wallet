import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
abstract class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String hash,
    required String from,
    required String to,
    required String value,     // in wei (string)
    required String timeStamp, // unix timestamp string
    required String isError,   // "0" = success, "1" = failed
    @Default('') String tokenSymbol,
    @Default('') String tokenDecimal,
    @Default(false) bool isErc20,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}
