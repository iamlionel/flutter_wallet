import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/wallet.dart';

part 'wallet_model.freezed.dart';
part 'wallet_model.g.dart';

@freezed
abstract class WalletModel with _$WalletModel {
  const WalletModel._();

  const factory WalletModel({
    @JsonKey(name: 'private_key') String? privateKey,
    @JsonKey(name: 'public_key') String? publicKey,
    @Default({}) Map<String, String> addresses,
  }) = _WalletModel;

  factory WalletModel.fromJson(Map<String, dynamic> json) =>
      _$WalletModelFromJson(json);

  factory WalletModel.fromEntity(Wallet wallet) => WalletModel(
        privateKey: wallet.privateKey,
        publicKey: wallet.publicKey,
        addresses: wallet.addresses,
      );

  Wallet toEntity() => Wallet(
        privateKey: privateKey,
        publicKey: publicKey,
        addresses: addresses,
      );
}
