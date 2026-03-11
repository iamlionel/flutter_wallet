import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_asset_model.freezed.dart';
part 'token_asset_model.g.dart';

@freezed
abstract class TokenAssetModel with _$TokenAssetModel {
  const factory TokenAssetModel({
    @Default('eth') String chain,  // See ChainId.key: 'eth' | 'btc' | 'sol'
    required String contractAddress,
    required String symbol,
    required String decimal,
    @Default('0') String balance,
    @Default(false) bool isNative,
  }) = _TokenAssetModel;

  factory TokenAssetModel.fromJson(Map<String, dynamic> json) =>
      _$TokenAssetModelFromJson(json);
}
