import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/wallet_model.dart';

part 'auth_landing_state.freezed.dart';

enum AuthLandingStatus { initial, failure, loading, success }

@freezed
abstract class AuthLandingState with _$AuthLandingState {
  const factory AuthLandingState({
    @Default('') String password,
    @Default('') String errorMessage,
    @Default(false) bool isValid,
    @Default(WalletModel()) WalletModel wallet,
    @Default(AuthLandingStatus.initial) AuthLandingStatus status,
  }) = _AuthLandingState;
}
