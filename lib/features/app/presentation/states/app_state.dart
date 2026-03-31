import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../auth/domain/repositories/phrase_repository.dart';
import '../../../wallet/domain/entities/wallet.dart';

part 'app_state.freezed.dart';

@freezed
abstract class AppState with _$AppState {
  const factory AppState({
    @Default(Wallet()) Wallet wallet,
    @Default(AuthStatus.unknown) AuthStatus status,
  }) = _AppState;
}
