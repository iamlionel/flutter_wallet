// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_asset_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TokenAssetModel _$TokenAssetModelFromJson(Map<String, dynamic> json) =>
    _TokenAssetModel(
      chain: json['chain'] as String? ?? 'eth',
      contractAddress: json['contractAddress'] as String,
      symbol: json['symbol'] as String,
      decimal: json['decimal'] as String,
      balance: json['balance'] as String? ?? '0',
      isNative: json['isNative'] as bool? ?? false,
    );

Map<String, dynamic> _$TokenAssetModelToJson(_TokenAssetModel instance) =>
    <String, dynamic>{
      'chain': instance.chain,
      'contractAddress': instance.contractAddress,
      'symbol': instance.symbol,
      'decimal': instance.decimal,
      'balance': instance.balance,
      'isNative': instance.isNative,
    };
