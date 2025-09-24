import 'phrase_repository.dart';
import 'package:bip39/bip39.dart' as bip39;

class PhraseRepositoryImpl extends PhraseRepository {
  @override
  String getMnemonics() {
    return bip39.generateMnemonic();
  }
}
