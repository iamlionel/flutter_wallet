enum AuthStatus { authenticated, unauthenticated, unknown }

abstract class PhraseRepository {
  String getMnemonics();
}
