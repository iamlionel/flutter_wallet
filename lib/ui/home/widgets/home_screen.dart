import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../data/providers/app_provider.dart';
import '../../../data/providers/contract_provider.dart';
import '../../../data/providers/wallet_data_provider.dart';
import 'package:web3dart/web3dart.dart';
import '../../core/themes/colors.dart';
import '../../widgets/add_token_bottom_sheet.dart';
import '../../widgets/send_bottom_sheet.dart';
import '../../widgets/swap_bottom_sheet.dart';

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
    final app = ref.watch(appProvider);
    final ethBalanceAsync = ref.watch(
      ethBalanceProvider(app.wallet.publicKey ?? ''),
    );
    final ethUsdPriceAsync = ref.watch(ethUsdPriceProvider);

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
            _buildBalanceSection(context, ethBalanceAsync, ethUsdPriceAsync),

            // ── Quick Actions ──────────────────────────────────────────────
            _buildQuickActions(context),

            const SizedBox(height: 8),

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
      toolbarHeight: 64,
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
      title: Column(
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
          const SizedBox(height: 1),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFF00FF88),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'Ethereum Mainnet',
                style: TextStyle(fontSize: 11, color: Colors.white60),
              ),
            ],
          ),
          const SizedBox(height: 1),
          GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getShortAddress(app.wallet.publicKey),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white38,
                    fontFamily: 'RobotoMono',
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.copy_rounded,
                  size: 12,
                  color: AppColors.primary,
                ),
              ],
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
    AsyncValue<EtherAmount?> ethBalanceAsync,
    AsyncValue<double> ethUsdPriceAsync,
  ) {
    final theme = Theme.of(context);

    double ethAmount = 0.0;
    double usdPrice = 0.0;

    ethBalanceAsync.whenData((balance) {
      if (balance != null) {
        ethAmount = balance.getValueInUnit(EtherUnit.ether).toDouble();
      }
    });
    ethUsdPriceAsync.whenData((price) => usdPrice = price);

    final totalUsd = ethAmount * usdPrice;
    final isLoading = ethBalanceAsync.isLoading || ethUsdPriceAsync.isLoading;

    return Container(
      color: const Color(0xFF0F1218),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Column(
        children: [
          const Text(
            'Total Balance',
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 4),
          isLoading
              ? const SizedBox(
                  height: 44,
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : Text(
                  '\$${totalUsd.toStringAsFixed(2)}',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    fontSize: 36,
                    letterSpacing: -1,
                  ),
                ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${ethAmount.toStringAsFixed(4)} ETH',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Quick Actions ───────────────────────────────────────────────────────────
  Widget _buildQuickActions(BuildContext context) {
    return Container(
      color: const Color(0xFF0F1218),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionBtn(
            Icons.arrow_upward_rounded,
            'Send',
            () => _showSendTokenBottomSheet(context),
          ),
          _buildActionBtn(Icons.arrow_downward_rounded, 'Receive', () {}),
          _buildActionBtn(
            Icons.swap_horiz_rounded,
            'Swap',
            () => _showSwapTokenBottomSheet(context),
          ),
          _buildActionBtn(Icons.grid_view_rounded, 'More', () {}),
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
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(height: 6),
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
    const assets = [
      _Asset('Ethereum', 'ETH', '0.00', '\$0.00', AppColors.primary),
      _Asset('Bitcoin', 'BTC', '0.15', '\$9,450.00', Color(0xFFF7931A)),
      _Asset('Solana', 'SOL', '24.5', '\$3,000.80', Color(0xFF14F195)),
    ];

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: assets.length,
      itemBuilder: (context, index) {
        final a = assets[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            leading: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: a.color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.token_rounded, color: a.color, size: 24),
            ),
            title: Text(
              a.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            subtitle: Text(
              '${a.amount} ${a.symbol}',
              style: const TextStyle(color: Colors.white38, fontSize: 12),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  a.value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const Text(
                  '+2.5%',
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Activity Tab ────────────────────────────────────────────────────────────
  Widget _buildActivityTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_rounded,
            size: 56,
            color: Colors.white.withValues(alpha: 0.12),
          ),
          const SizedBox(height: 14),
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

  // ── Helpers ─────────────────────────────────────────────────────────────────
  String _getShortAddress(String? addr) {
    if (addr == null || addr.isEmpty) return '0x...';
    if (addr.length < 10) return addr;
    return '${addr.substring(0, 6)}...${addr.substring(addr.length - 4)}';
  }

  void _showAddTokenBottomSheet(BuildContext context) {
    showMaterialModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddTokenBottomSheet(),
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

// ── Data model ────────────────────────────────────────────────────────────────
class _Asset {
  const _Asset(this.name, this.symbol, this.amount, this.value, this.color);
  final String name;
  final String symbol;
  final String amount;
  final String value;
  final Color color;
}
