import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_token_state.freezed.dart';

enum AddTokenStatus { initial, loading, success, failure }

@freezed
abstract class AddTokenState with _$AddTokenState {
  const factory AddTokenState({
    @Default('') String contractAddress,
    @Default('') String tokenSymbol,
    @Default('') String tokenDecimal,
    @Default(AddTokenStatus.initial) AddTokenStatus status,
  }) = _AddTokenState;
}
