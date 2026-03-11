// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalletModel _$WalletModelFromJson(Map<String, dynamic> json) => _WalletModel(
  privateKey: json['private_key'] as String?,
  publicKey: json['public_key'] as String?,
  addresses:
      (json['addresses'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
);

Map<String, dynamic> _$WalletModelToJson(_WalletModel instance) =>
    <String, dynamic>{
      'private_key': instance.privateKey,
      'public_key': instance.publicKey,
      'addresses': instance.addresses,
    };
