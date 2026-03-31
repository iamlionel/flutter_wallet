import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/token_asset.dart';

part 'token_asset_model.freezed.dart';
part 'token_asset_model.g.dart';

@freezed
abstract class TokenAssetModel with _$TokenAssetModel {
  const TokenAssetModel._();

  const factory TokenAssetModel({
    @Default('eth') String chain,
    required String contractAddress,
    required String symbol,
    required String decimal,
    @Default('0') String balance,
    @Default(false) bool isNative,
  }) = _TokenAssetModel;

  factory TokenAssetModel.fromJson(Map<String, dynamic> json) =>
      _$TokenAssetModelFromJson(json);

  factory TokenAssetModel.fromEntity(TokenAsset asset) => TokenAssetModel(
        chain: asset.chain,
        contractAddress: asset.contractAddress,
        symbol: asset.symbol,
        decimal: asset.decimal,
        balance: asset.balance,
        isNative: asset.isNative,
      );

  TokenAsset toEntity() => TokenAsset(
        chain: chain,
        contractAddress: contractAddress,
        symbol: symbol,
        decimal: decimal,
        balance: balance,
        isNative: isNative,
      );
}
