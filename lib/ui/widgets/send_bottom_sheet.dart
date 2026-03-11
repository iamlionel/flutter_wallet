import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/app_provider.dart';
import '../../data/providers/contract_provider.dart';
import '../core/themes/colors.dart';
import '../widgets/extension.dart';
import '../widgets/qr_scanner_screen.dart';

// ---------------------------------------------------------------------------
// Gas-price provider — fetched once when the sheet opens.
// ---------------------------------------------------------------------------
final _gasPriceProvider = FutureProvider.autoDispose<double>((ref) async {
  final repo = await ref.watch(contractRepositoryProvider.future);
  final gasPrice = await repo.getGasPrice();
  // Gas fee in ETH = gasPrice (wei) * 21000 / 1e18
  final feeWei = gasPrice.getInWei * BigInt.from(21000);
  return feeWei / BigInt.from(10).pow(18);
});

// ---------------------------------------------------------------------------
// SendBottomSheet
// ---------------------------------------------------------------------------
class SendBottomSheet extends ConsumerStatefulWidget {
  const SendBottomSheet({Key? key}) : super(key: key);

  @override
  ConsumerState<SendBottomSheet> createState() => _SendBottomSheetState();
}

class _SendBottomSheetState extends ConsumerState<SendBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _amountController = TextEditingController();

  bool _sending = false;
  String? _txHash;
  String? _error;

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------
  bool get _addressValid {
    final v = _recipientController.text.trim();
    return v.startsWith('0x') && v.length == 42;
  }

  bool get _amountValid {
    final v = double.tryParse(_amountController.text.trim());
    return v != null && v > 0;
  }

  bool get _canSend => _addressValid && _amountValid && !_sending;

  BigInt _parseAmountToWei(String raw) {
    final eth = double.parse(raw.trim());
    final wei = (eth * 1e18).toStringAsFixed(0);
    return BigInt.parse(wei);
  }

  // -------------------------------------------------------------------------
  // Send action
  // -------------------------------------------------------------------------
  Future<void> _send() async {
    setState(() {
      _sending = true;
      _error = null;
    });

    try {
      final privateKey = ref.read(appProvider).wallet.privateKey ?? '';
      if (privateKey.isEmpty) throw Exception('Private key not available');

      final repo = await ref.read(contractRepositoryProvider.future);
      final txHash = await repo.sendEth(
        privateKey: privateKey,
        to: _recipientController.text.trim(),
        amount: _parseAmountToWei(_amountController.text),
      );

      setState(() {
        _txHash = txHash;
        _sending = false;
      });

      // Auto-close after 2 seconds on success.
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _sending = false;
      });
    }
  }

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gasPriceAsync = ref.watch(_gasPriceProvider);

    // Current ETH balance for the "Available" hint.
    final walletState = ref.watch(appProvider);
    final publicKey = walletState.wallet.publicKey ?? '';

    return Container(
      height: context.screenHeight * 0.75,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: _txHash != null
          ? _buildSuccessState(context, isDark)
          : _buildFormState(context, isDark, gasPriceAsync, publicKey),
    );
  }

  // -------------------------------------------------------------------------
  // Success state
  // -------------------------------------------------------------------------
  Widget _buildSuccessState(BuildContext context, bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle_outline, color: AppColors.success, size: 64),
        const SizedBox(height: 16),
        Text(
          'Transaction Sent!',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Tx: ${_txHash!}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Closing…',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textHint,
              ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // Form state
  // -------------------------------------------------------------------------
  Widget _buildFormState(
    BuildContext context,
    bool isDark,
    AsyncValue<double> gasPriceAsync,
    String publicKey,
  ) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Align(
            child: Text(
              'Send ETH',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ),
          SizedBox(height: context.minBlockVertical * 3),

          // Recipient address field
          _buildLabel(context, 'Recipient Address'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _recipientController,
            onChanged: (_) => setState(() {}),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            decoration: _inputDecoration(
              context,
              isDark,
              hintText: '0x...',
              suffix: IconButton(
                icon: const Icon(Icons.qr_code_scanner, size: 20),
                color: AppColors.primary,
                tooltip: 'Scan QR',
                onPressed: () async {
                  final result = await Navigator.of(context).push<String>(
                    MaterialPageRoute(
                      builder: (_) => const QrScannerScreen(),
                    ),
                  );
                  if (result != null) {
                    _recipientController.text = result;
                    setState(() {});
                  }
                },
              ),
            ),
          ),

          SizedBox(height: context.minBlockVertical * 2),

          // Amount field
          _buildLabel(context, 'Amount (ETH)'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _amountController,
            onChanged: (_) => setState(() {}),
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            decoration: _inputDecoration(
              context,
              isDark,
              hintText: publicKey.isNotEmpty
                  ? 'Amount in ETH'
                  : 'Amount in ETH',
            ),
          ),

          SizedBox(height: context.minBlockVertical * 2),

          // Gas fee estimate
          _buildGasFeeRow(context, gasPriceAsync),

          // Error message
          if (_error != null) ...[
            SizedBox(height: context.minBlockVertical * 1.5),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.danger.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.danger.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline,
                      color: AppColors.danger, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _error!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.danger,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const Spacer(),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: _buildButton(
                  context,
                  label: 'Cancel',
                  onPressed: _sending ? null : () => Navigator.pop(context),
                  gradient: null,
                  backgroundColor: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.grey.shade100,
                  textColor: isDark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(width: context.minBlockHorizontal * 5),
              Expanded(
                child: _buildButton(
                  context,
                  label: _sending ? 'Sending…' : 'Send',
                  onPressed: _canSend ? _send : null,
                  gradient: AppColors.primaryGradient,
                  backgroundColor: null,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: context.minBlockVertical * 4),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Gas fee row
  // -------------------------------------------------------------------------
  Widget _buildGasFeeRow(BuildContext context, AsyncValue<double> async) {
    final feeText = async.when(
      data: (fee) => '~${fee.toStringAsFixed(6)} ETH',
      loading: () => 'Estimating…',
      error: (_, __) => '~\$0.50',
    );

    return Row(
      children: [
        const Icon(Icons.local_gas_station,
            size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Text(
          'Gas fee: ',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        if (async.isLoading)
          const SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 1.5),
          )
        else
          Text(
            feeText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------
  Widget _buildLabel(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
    );
  }

  InputDecoration _inputDecoration(
    BuildContext context,
    bool isDark, {
    required String hintText,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: AppColors.textHint),
      suffixIcon: suffix,
      filled: true,
      fillColor: isDark
          ? AppColors.surfaceVariant
          : Colors.grey.shade100,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primaryBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primaryBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String label,
    required VoidCallback? onPressed,
    required List<Color>? gradient,
    required Color? backgroundColor,
    required Color textColor,
  }) {
    final isDisabled = onPressed == null;

    return GestureDetector(
      onTap: onPressed,
      child: AnimatedOpacity(
        opacity: isDisabled ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            gradient: gradient != null && !isDisabled
                ? LinearGradient(
                    colors: gradient,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
            color: gradient == null ? backgroundColor : null,
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: _sending && label.startsWith('Send')
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  label,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
        ),
      ),
    );
  }
}
