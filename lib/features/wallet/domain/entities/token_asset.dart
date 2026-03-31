class TokenAsset {
  const TokenAsset({
    this.chain = 'eth',
    required this.contractAddress,
    required this.symbol,
    required this.decimal,
    this.balance = '0',
    this.isNative = false,
  });

  final String chain;
  final String contractAddress;
  final String symbol;
  final String decimal;
  final String balance;
  final bool isNative;

  TokenAsset copyWith({
    String? chain,
    String? contractAddress,
    String? symbol,
    String? decimal,
    String? balance,
    bool? isNative,
  }) => TokenAsset(
        chain: chain ?? this.chain,
        contractAddress: contractAddress ?? this.contractAddress,
        symbol: symbol ?? this.symbol,
        decimal: decimal ?? this.decimal,
        balance: balance ?? this.balance,
        isNative: isNative ?? this.isNative,
      );

  @override
  bool operator ==(Object other) =>
      other is TokenAsset &&
      other.chain == chain &&
      other.contractAddress == contractAddress &&
      other.symbol == symbol &&
      other.decimal == decimal &&
      other.balance == balance &&
      other.isNative == isNative;

  @override
  int get hashCode => Object.hash(chain, contractAddress, symbol, decimal, balance, isNative);
}
