import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../domain/entities/chain_id.dart';
import '../../../app/presentation/viewmodels/app_viewmodel.dart';
import '../../../../core/ui/themes/colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../viewmodels/token_viewmodel.dart';
import 'import_token_bottom_sheet.dart';
import 'more_bottom_sheet.dart';
import 'receive_bottom_sheet.dart';
import 'send_bottom_sheet.dart';
import 'swap_bottom_sheet.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = ref.watch(appViewModelProvider);
    final totalUsdAsync = ref.watch(totalUsdBalanceProvider(app.wallet.addresses));

    return Scaffold(
      // ── Scaffold handles SafeArea / status bar automatically ─────────────
      backgroundColor: const Color(0xFF0A0C10),
      appBar: _buildAppBar(app),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F1218), Color(0xFF0A0C10)],
          ),
        ),
        child: Column(
          children: [
            // ── Balance ────────────────────────────────────────────────────
            _buildBalanceSection(context, totalUsdAsync),

            // ── Quick Actions ──────────────────────────────────────────────
            _buildQuickActions(context, app.wallet.addresses),

            // ── TabBar ─────────────────────────────────────────────────────
            Material(
              color: const Color(0xFF0F1218),
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primary,
                indicatorWeight: 2,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white38,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                dividerColor: Colors.white12,
                tabs: const [
                  Tab(text: 'Assets'),
                  Tab(text: 'Activity'),
                ],
              ),
            ),

            // ── Tab Content ────────────────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildAssetsTab(), _buildActivityTab()],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTokenBottomSheet(context),
        backgroundColor: AppColors.primary,
        elevation: 8,
        child: const Icon(Icons.add_rounded, color: Colors.black, size: 28),
      ),
    );
  }

  // ── AppBar ──────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(dynamic app) {
    return AppBar(
      backgroundColor: const Color(0xFF0F1218),
      elevation: 0,
      centerTitle: true,
      toolbarHeight: 56,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Center(
          child: Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: AppColors.primaryGradient),
            ),
            child: const Icon(Icons.person, color: Colors.black, size: 20),
          ),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Main Wallet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () => _showCopyAddressSheet(app.wallet.addresses),
            child: const Icon(
              Icons.copy_rounded,
              size: 14,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.qr_code_scanner,
            color: Colors.white54,
            size: 22,
          ),
        ),
      ],
    );
  }

  // ── Balance Section ─────────────────────────────────────────────────────────
  Widget _buildBalanceSection(
    BuildContext context,
    AsyncValue<double> totalUsdAsync,
  ) {
    final theme = Theme.of(context);

    return Container(
      color: const Color(0xFF0F1218),
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 8),
      child: Column(
        children: [
          const Text(
            'Total Balance',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 2),
          totalUsdAsync.when(
            loading: () => const SizedBox(
              height: 36,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            error: (_, __) => Text(
              '\$0.00',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontSize: 32,
                letterSpacing: -1,
              ),
            ),
            data: (totalUsd) => Text(
              '\$${_formatUsd(totalUsd)}',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontSize: 32,
                letterSpacing: -1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatUsd(double value) {
    final parts = value.toStringAsFixed(2).split('.');
    final intPart = parts[0];
    final decPart = parts[1];
    final buffer = StringBuffer();
    for (int i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) buffer.write(',');
      buffer.write(intPart[i]);
    }
    return '$buffer.$decPart';
  }

  // ── Quick Actions ───────────────────────────────────────────────────────────
  Widget _buildQuickActions(
    BuildContext context,
    Map<String, String> addresses,
  ) {
    return Container(
      color: const Color(0xFF0F1218),
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionBtn(
            Icons.arrow_upward_rounded,
            'Send',
            () => _showSendTokenBottomSheet(context),
          ),
          _buildActionBtn(
            Icons.arrow_downward_rounded,
            'Receive',
            () => _showReceiveBottomSheet(addresses),
          ),
          _buildActionBtn(
            Icons.swap_horiz_rounded,
            'Swap',
            () => _showSwapTokenBottomSheet(context),
          ),
          _buildActionBtn(
            Icons.grid_view_rounded,
            'More',
            () => _showMoreBottomSheet(context),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ── Assets Tab ──────────────────────────────────────────────────────────────
  Widget _buildAssetsTab() {
    final app = ref.watch(appViewModelProvider);
    final addresses = app.wallet.addresses;
    final publicKey = app.wallet.publicKey ?? '';
    final savedTokens = ref.watch(savedTokensViewModelProvider);

    final chains = [
      (
        chainId: ChainId.ethereum,
        symbol: 'ETH',
        name: 'Ethereum',
        color: AppColors.primary,
      ),
      (
        chainId: ChainId.bitcoin,
        symbol: 'BTC',
        name: 'Bitcoin',
        color: const Color(0xFFFF9500),
      ),
      (
        chainId: ChainId.solana,
        symbol: 'SOL',
        name: 'Solana',
        color: const Color(0xFF9945FF),
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: chains.length + savedTokens.length,
      itemBuilder: (context, index) {
        if (index < chains.length) {
          final chain = chains[index];
          final address = addresses[chain.chainId.key] ?? '';
          final balanceAsync = ref.watch(
            nativeBalanceProvider((chainId: chain.chainId, address: address)),
          );
          return balanceAsync.when(
            data: (bal) => _buildAssetTile(
              name: chain.name,
              symbol: chain.symbol,
              amount: bal.toStringAsFixed(4),
              color: chain.color,
            ),
            loading: () => _buildAssetTile(
              name: chain.name,
              symbol: chain.symbol,
              amount: '...',
              color: chain.color,
              isLoading: true,
            ),
            error: (_, __) => _buildAssetTile(
              name: chain.name,
              symbol: chain.symbol,
              amount: '0.0000',
              color: chain.color,
            ),
          );
        }
        final token = savedTokens[index - chains.length];
        final balanceAsync = ref.watch(
          tokenBalanceProvider((token: token, publicKey: publicKey)),
        );
        return balanceAsync.when(
          data: (t) => _buildAssetTile(
            name: t.symbol,
            symbol: t.symbol,
            amount: _formatTokenBalance(t.balance, t.decimal),
            color: const Color(0xFF6C7BFF),
          ),
          loading: () => _buildAssetTile(
            name: token.symbol,
            symbol: token.symbol,
            amount: '...',
            color: const Color(0xFF6C7BFF),
            isLoading: true,
          ),
          error: (_, __) => _buildAssetTile(
            name: token.symbol,
            symbol: token.symbol,
            amount: 'Error',
            color: const Color(0xFF6C7BFF),
          ),
        );
      },
    );
  }

  Widget _buildAssetTile({
    required String name,
    required String symbol,
    required String amount,
    required Color color,
    bool isLoading = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            _chainIcon(symbol),
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          symbol,
          style: const TextStyle(color: Colors.white38, fontSize: 11),
        ),
        trailing: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(
                amount,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }

  String _chainIcon(String symbol) {
    switch (symbol.toUpperCase()) {
      case 'ETH':
        return 'Ξ';
      case 'BTC':
        return '₿';
      case 'SOL':
        return '◎';
      default:
        return symbol.isNotEmpty ? symbol[0].toUpperCase() : '?';
    }
  }

  String _formatTokenBalance(String rawBalance, String decimal) {
    if (rawBalance.isEmpty || rawBalance == '0') return '0';
    try {
      final decimals = int.parse(decimal);
      final value = BigInt.parse(rawBalance);
      final divisor = BigInt.from(10).pow(decimals);
      final whole = value ~/ divisor;
      final fraction = value % divisor;
      final fractionStr = fraction.toString().padLeft(decimals, '0');
      return '$whole.${fractionStr.substring(0, 4.clamp(0, fractionStr.length))}';
    } catch (_) {
      return rawBalance;
    }
  }

  // ── Activity Tab ────────────────────────────────────────────────────────────
  Widget _buildActivityTab() {
    final app = ref.watch(appViewModelProvider);
    final publicKey = app.wallet.publicKey ?? '';
    final txAsync = ref.watch(transactionsProvider(publicKey));

    return txAsync.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      error: (e, _) => const Center(
        child: Text(
          'Failed to load transactions',
          style: TextStyle(color: Colors.white38),
        ),
      ),
      data: (txList) {
        if (txList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history_rounded,
                  size: 48,
                  color: Colors.white.withValues(alpha: 0.12),
                ),
                const SizedBox(height: 10),
                const Text(
                  'No recent activity',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Your transactions will appear here',
                  style: TextStyle(color: Colors.white24, fontSize: 12),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          itemCount: txList.length,
          itemBuilder: (context, index) {
            final tx = txList[index];
            final isSend = tx.from.toLowerCase() == publicKey.toLowerCase();
            final color = tx.isSuccess
                ? (isSend ? AppColors.warning : AppColors.success)
                : Colors.red;
            final icon = isSend
                ? Icons.arrow_upward_rounded
                : Icons.arrow_downward_rounded;
            final label = tx.isErc20
                ? '${isSend ? 'Send' : 'Receive'} ${tx.tokenSymbol}'
                : (isSend ? 'Send ETH' : 'Receive ETH');
            final amount = tx.isErc20
                ? _formatTokenBalance(tx.value, tx.tokenDecimal)
                : _weiToEth(tx.value);
            final dt = tx.timestamp;
            final dateStr =
                '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 2,
                ),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                title: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  '${_shortHex(tx.hash)} · $dateStr',
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${isSend ? '-' : '+'}$amount',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    if (!tx.isSuccess)
                      const Text(
                        'Failed',
                        style: TextStyle(color: Colors.red, fontSize: 11),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _weiToEth(String wei) {
    try {
      final value = BigInt.parse(wei);
      const decimals = 18;
      final divisor = BigInt.from(10).pow(decimals);
      final whole = value ~/ divisor;
      final fraction = value % divisor;
      final fractionStr = fraction.toString().padLeft(decimals, '0');
      return '$whole.${fractionStr.substring(0, 4.clamp(0, fractionStr.length))}';
    } catch (_) {
      return '0';
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────
  String _shortHex(String hex, {int head = 6, int tail = 4}) {
    if (hex.length < head + tail + 1) return hex;
    return '${hex.substring(0, head)}...${hex.substring(hex.length - tail)}';
  }

  void _showCopyAddressSheet(Map<String, String> addresses) {
    final chains = [
      (
        key: ChainId.ethereum.key,
        name: 'Ethereum',
        symbol: 'ETH',
        color: AppColors.primary,
      ),
      (
        key: ChainId.bitcoin.key,
        name: 'Bitcoin',
        symbol: 'BTC',
        color: const Color(0xFFFF9500),
      ),
      (
        key: ChainId.solana.key,
        name: 'Solana',
        symbol: 'SOL',
        color: const Color(0xFF9945FF),
      ),
    ];

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF151820),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Copy Address',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...chains.map((chain) {
              final address = addresses[chain.key] ?? '';
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: chain.color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      chain.symbol[0],
                      style: TextStyle(
                        color: chain.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  chain.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  address.isEmpty
                      ? 'Not available'
                      : _shortHex(address, head: 8, tail: 6),
                  style: TextStyle(
                    color: address.isEmpty ? Colors.white24 : Colors.white38,
                    fontSize: 11,
                    fontFamily: 'RobotoMono',
                  ),
                ),
                trailing: address.isEmpty
                    ? null
                    : const Icon(
                        Icons.copy_rounded,
                        size: 16,
                        color: Colors.white38,
                      ),
                onTap: address.isEmpty
                    ? null
                    : () {
                        Clipboard.setData(ClipboardData(text: address));
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${chain.name} address copied'),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showReceiveBottomSheet(Map<String, String> addresses) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF151820),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ReceiveBottomSheet(addresses: addresses),
    );
  }

  void _showMoreBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF151820),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const MoreBottomSheet(),
    );
  }

  void _showAddTokenBottomSheet(BuildContext context) {
    showMaterialModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const ImportTokenBottomSheet(),
    );
  }

  void _showSendTokenBottomSheet(BuildContext context) {
    showMaterialModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const SendBottomSheet(),
    );
  }

  void _showSwapTokenBottomSheet(BuildContext context) {
    showMaterialModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const SwapBottomSheet(),
    );
  }
}
