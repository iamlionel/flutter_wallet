class Transaction {
  const Transaction({
    required this.hash,
    required this.from,
    required this.to,
    required this.value,
    required this.timestamp,
    required this.isSuccess,
    this.tokenSymbol = '',
    this.tokenDecimal = '',
    this.isErc20 = false,
    this.chain = 'eth',
  });

  final String hash;
  final String from;
  final String to;
  final String value;
  final DateTime timestamp;
  final bool isSuccess;
  final String tokenSymbol;
  final String tokenDecimal;
  final bool isErc20;
  final String chain;

  Transaction copyWith({
    String? hash,
    String? from,
    String? to,
    String? value,
    DateTime? timestamp,
    bool? isSuccess,
    String? tokenSymbol,
    String? tokenDecimal,
    bool? isErc20,
    String? chain,
  }) => Transaction(
        hash: hash ?? this.hash,
        from: from ?? this.from,
        to: to ?? this.to,
        value: value ?? this.value,
        timestamp: timestamp ?? this.timestamp,
        isSuccess: isSuccess ?? this.isSuccess,
        tokenSymbol: tokenSymbol ?? this.tokenSymbol,
        tokenDecimal: tokenDecimal ?? this.tokenDecimal,
        isErc20: isErc20 ?? this.isErc20,
        chain: chain ?? this.chain,
      );

  @override
  bool operator ==(Object other) =>
      other is Transaction &&
      other.hash == hash &&
      other.from == from &&
      other.to == to &&
      other.value == value &&
      other.timestamp == timestamp &&
      other.isSuccess == isSuccess &&
      other.tokenSymbol == tokenSymbol &&
      other.tokenDecimal == tokenDecimal &&
      other.isErc20 == isErc20 &&
      other.chain == chain;

  @override
  int get hashCode => Object.hash(
        hash, from, to, value, timestamp, isSuccess,
        tokenSymbol, tokenDecimal, isErc20, chain,
      );
}
