import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/wallet_model.dart';

part 'create_pin_state.freezed.dart';

enum CreatePinStatus { initial, failure, success }

@freezed
abstract class CreatePinState with _$CreatePinState {
  const factory CreatePinState({
    @Default('') String password,
    @Default('') String confirmPassword,
    @Default(false) bool isValid,
    @Default(CreatePinStatus.initial) CreatePinStatus status,
    @Default(WalletModel()) WalletModel wallet,
  }) = _CreatePinState;
}
