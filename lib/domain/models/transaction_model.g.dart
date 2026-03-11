// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    _TransactionModel(
      hash: json['hash'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      value: json['value'] as String,
      timeStamp: json['timeStamp'] as String,
      isError: json['isError'] as String,
      tokenSymbol: json['tokenSymbol'] as String? ?? '',
      tokenDecimal: json['tokenDecimal'] as String? ?? '',
      isErc20: json['isErc20'] as bool? ?? false,
    );

Map<String, dynamic> _$TransactionModelToJson(_TransactionModel instance) =>
    <String, dynamic>{
      'hash': instance.hash,
      'from': instance.from,
      'to': instance.to,
      'value': instance.value,
      'timeStamp': instance.timeStamp,
      'isError': instance.isError,
      'tokenSymbol': instance.tokenSymbol,
      'tokenDecimal': instance.tokenDecimal,
      'isErc20': instance.isErc20,
    };
