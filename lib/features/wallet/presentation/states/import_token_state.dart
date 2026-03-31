import 'package:freezed_annotation/freezed_annotation.dart';

part 'import_token_state.freezed.dart';

enum ImportTokenStatus { initial, loading, success, failure }

@freezed
abstract class ImportTokenState with _$ImportTokenState {
  const factory ImportTokenState({
    @Default('') String contractAddress,
    @Default('') String tokenSymbol,
    @Default('') String tokenDecimal,
    @Default(ImportTokenStatus.initial) ImportTokenStatus status,
  }) = _ImportTokenState;
}
