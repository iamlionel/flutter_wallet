import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
abstract class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String hash,
    required String from,
    required String to,
    required String value,
    required String timeStamp,
    required String isError,
    @Default('') String tokenSymbol,
    @Default('') String tokenDecimal,
    @Default(false) bool isErc20,
    @Default('eth') String chain,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}
