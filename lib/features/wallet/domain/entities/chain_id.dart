// lib/domain/models/chain_id.dart

enum ChainId {
  ethereum('eth'),
  bitcoin('btc'),
  solana('sol');

  const ChainId(this.key);
  final String key;
}
