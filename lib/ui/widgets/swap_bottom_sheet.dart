import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/providers/app_provider.dart';
import '../../data/providers/chain_provider.dart';
import '../../domain/models/chain_id.dart';
import '../core/themes/colors.dart';
import '../core/themes/font_weights.dart';
import '../core/themes/text_styles.dart';
import 'extension.dart';
import 'solid_button.dart';

// ── Token definitions ─────────────────────────────────────────────────────────

class _Token {
  const _Token({required this.symbol, required this.address});
  final String symbol;
  final String address;
}

const _tokens = [
  _Token(symbol: 'USDC', address: '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48'),
  _Token(symbol: 'USDT', address: '0xdAC17F958D2ee523a2206206994597C13D831ec7'),
  _Token(symbol: 'DAI', address: '0x6B175474E89094C44Da98b954EedeAC495271d0F'),
];

// ── Bottom Sheet ──────────────────────────────────────────────────────────────

class SwapBottomSheet extends ConsumerStatefulWidget {
  const SwapBottomSheet({Key? key}) : super(key: key);

  @override
  ConsumerState<SwapBottomSheet> createState() => _SwapBottomSheetState();
}

class _SwapBottomSheetState extends ConsumerState<SwapBottomSheet> {
  final TextEditingController _amountController = TextEditingController();
  int _selectedTokenIndex = 0;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double get _enteredAmount {
    return double.tryParse(_amountController.text) ?? 0.0;
  }

  double _estimatedOutput(double ethPrice) {
    // Stablecoins are 1:1 with USD, so output = amount * ethPrice
    return _enteredAmount * ethPrice;
  }

  Future<void> _openUniswap() async {
    final token = _tokens[_selectedTokenIndex];
    final amount = _enteredAmount;
    final amountStr = amount > 0 ? amount.toString() : '';
    final url = 'https://app.uniswap.org/#/swap'
        '?inputCurrency=ETH'
        '&outputCurrency=${token.address}'
        '${amountStr.isNotEmpty ? '&exactAmount=$amountStr' : ''}';
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wallet = ref.watch(appProvider).wallet;
    final ethAddress = wallet.addresses[ChainId.ethereum.key] ?? '';

    final pricesAsync = ref.watch(chainPricesProvider);
    final balanceAsync = ethAddress.isNotEmpty
        ? ref.watch(
            nativeBalanceProvider((chainId: ChainId.ethereum, address: ethAddress)),
          )
        : null;

    return Container(
      height: context.screenHeight - (context.screenHeight / 4),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title ────────────────────────────────────────────────────────
          Align(
            child: Text(
              'Swap',
              style: AppTextStyle.headline2.copyWith(
                fontWeight: AppFontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: context.minBlockVertical * 2),

          // ── From section ─────────────────────────────────────────────────
          Text(
            'From',
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primaryBorder),
            ),
            child: Row(
              children: [
                // ETH icon placeholder
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: const Center(
                    child: Text(
                      'Ξ',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ethereum (ETH)',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      balanceAsync == null
                          ? const Text(
                              'No address',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            )
                          : balanceAsync.when(
                              data: (bal) => Text(
                                'Balance: ${bal.toStringAsFixed(6)} ETH',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              loading: () => const Text(
                                'Loading balance...',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              error: (_, __) => const Text(
                                'Balance unavailable',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Amount input ──────────────────────────────────────────────────
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
            decoration: InputDecoration(
              hintText: '0.0',
              hintStyle: const TextStyle(color: AppColors.textHint),
              filled: true,
              fillColor: AppColors.surfaceVariant,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.primaryBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.primaryBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
              suffixText: 'ETH',
              suffixStyle: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),

          // ── Swap arrow ────────────────────────────────────────────────────
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceVariant,
                  border: Border.all(color: AppColors.primaryBorder),
                ),
                child: const Icon(
                  Icons.swap_vert,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
            ),
          ),

          // ── To section ───────────────────────────────────────────────────
          Text(
            'To',
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(_tokens.length, (i) {
              final token = _tokens[i];
              final selected = i == _selectedTokenIndex;
              return Padding(
                padding: EdgeInsets.only(right: i < _tokens.length - 1 ? 10 : 0),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTokenIndex = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: selected
                          ? AppColors.primary.withOpacity(0.15)
                          : AppColors.surfaceVariant,
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : AppColors.primaryBorder,
                        width: selected ? 1.5 : 1,
                      ),
                    ),
                    child: Text(
                      token.symbol,
                      style: TextStyle(
                        color: selected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight:
                            selected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 14),

          // ── Rate & estimated output ───────────────────────────────────────
          pricesAsync.when(
            data: (prices) {
              final ethPrice = prices[ChainId.ethereum] ?? 0.0;
              final estimated = _estimatedOutput(ethPrice);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (ethPrice > 0)
                    Text(
                      '1 ETH ≈ \$${ethPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  if (_enteredAmount > 0 && ethPrice > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Estimated: ≈ ${estimated.toStringAsFixed(2)} ${_tokens[_selectedTokenIndex].symbol}',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              );
            },
            loading: () => const Text(
              'Fetching rate...',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            error: (_, __) => const Text(
              'Rate unavailable',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ),

          const Spacer(),

          // ── Swap on Uniswap button ────────────────────────────────────────
          SolidButton(
            text: 'Swap on Uniswap',
            gradient: AppColors.primaryGradient,
            onPressed: _openUniswap,
          ),
          SizedBox(height: context.minBlockVertical * 4),
        ],
      ),
    );
  }
}
