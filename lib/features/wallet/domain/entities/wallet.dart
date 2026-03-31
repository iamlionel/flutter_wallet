class Wallet {
  const Wallet({
    this.privateKey,
    this.publicKey,
    this.addresses = const {},
  });

  final String? privateKey;
  final String? publicKey;
  final Map<String, String> addresses;

  Wallet copyWith({
    String? privateKey,
    String? publicKey,
    Map<String, String>? addresses,
  }) => Wallet(
        privateKey: privateKey ?? this.privateKey,
        publicKey: publicKey ?? this.publicKey,
        addresses: addresses ?? this.addresses,
      );

  @override
  bool operator ==(Object other) =>
      other is Wallet &&
      other.privateKey == privateKey &&
      other.publicKey == publicKey &&
      other.addresses == addresses;

  @override
  int get hashCode => Object.hash(privateKey, publicKey, addresses);
}
