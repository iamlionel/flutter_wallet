import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/wallet_model.dart';
import '../repositories/phrase_repository.dart';

part 'app_state.freezed.dart';

@freezed
abstract class AppState with _$AppState {
  const factory AppState({
    @Default(WalletModel()) WalletModel wallet,
    @Default(AuthStatus.unknown) AuthStatus status,
  }) = _AppState;
}
