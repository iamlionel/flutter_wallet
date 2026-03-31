import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../wallet/domain/entities/wallet.dart';

part 'create_pin_state.freezed.dart';

enum CreatePinStatus { initial, failure, loading, success }

@freezed
abstract class CreatePinState with _$CreatePinState {
  const factory CreatePinState({
    @Default('') String password,
    @Default('') String confirmPassword,
    @Default(false) bool isValid,
    @Default(CreatePinStatus.initial) CreatePinStatus status,
    @Default(Wallet()) Wallet wallet,
  }) = _CreatePinState;
}
