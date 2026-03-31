import 'package:freezed_annotation/freezed_annotation.dart';

part 'seed_phrase_state.freezed.dart';

enum SeedPhraseStatus { initial, loading, failure, success }

@freezed
abstract class SeedPhraseState with _$SeedPhraseState {
  const factory SeedPhraseState({
    @Default([]) List<String> mnemonics,
    @Default([]) List<String> randomMnemonics,
    @Default([]) List<String> confirmMnemonics,
    @Default('') String errorMessage,
    @Default(false) bool isMnemonicsValid,
    @Default(SeedPhraseStatus.initial) SeedPhraseStatus status,
    String? generatedSeedHex,
    String? confirmSeedHex,
    String? generatedSeedEntropy,
    String? confirmEntropy,
  }) = _SeedPhraseState;
}
