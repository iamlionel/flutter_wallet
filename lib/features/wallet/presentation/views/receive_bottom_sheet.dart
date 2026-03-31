import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../domain/entities/chain_id.dart';
import '../../../../core/ui/themes/colors.dart';

class ReceiveBottomSheet extends StatefulWidget {
  const ReceiveBottomSheet({super.key, required this.addresses});

  final Map<String, String> addresses;

  @override
  State<ReceiveBottomSheet> createState() => _ReceiveBottomSheetState();
}

class _ReceiveBottomSheetState extends State<ReceiveBottomSheet> {
  ChainId _selectedChain = ChainId.ethereum;

  static const _solColor = Color(0xFF9945FF);

  Color _colorForChain(ChainId chain) {
    switch (chain) {
      case ChainId.ethereum:
        return AppColors.primary;
      case ChainId.bitcoin:
        return const Color(0xFFFF9500);
      case ChainId.solana:
        return _solColor;
    }
  }

  String _labelForChain(ChainId chain) {
    switch (chain) {
      case ChainId.ethereum:
        return 'ETH';
      case ChainId.bitcoin:
        return 'BTC';
      case ChainId.solana:
        return 'SOL';
    }
  }

  String get _currentAddress =>
      widget.addresses[_selectedChain.key] ?? '';

  void _copyAddress() {
    final address = _currentAddress;
    if (address.isEmpty) return;
    Clipboard.setData(ClipboardData(text: address));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: AppColors.surface,
          content: Row(
            children: const [
              Icon(Icons.copy_rounded, color: AppColors.primary, size: 18),
              SizedBox(width: 8),
              Text(
                'Address copied',
                style: TextStyle(color: AppColors.textPrimary),
              ),
            ],
          ),
          dismissDirection: DismissDirection.startToEnd,
          margin: const EdgeInsets.all(15),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 1500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final address = _currentAddress;
    final chainColor = _colorForChain(_selectedChain);

    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 32),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.primaryBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          const Text(
            'Receive',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Chain selector tabs
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ChainId.values.map((chain) {
              final isSelected = _selectedChain == chain;
              final color = _colorForChain(chain);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedChain = chain),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withOpacity(0.15)
                          : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? color : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      _labelForChain(chain),
                      style: TextStyle(
                        color: isSelected ? color : AppColors.textSecondary,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),

          // QR code or placeholder
          if (address.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: QrImageView(
                data: address,
                version: QrVersions.auto,
                size: 200,
                backgroundColor: AppColors.white,
                eyeStyle: QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: AppColors.black,
                ),
                dataModuleStyle: QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: AppColors.black,
                ),
              ),
            )
          else
            Container(
              width: 224,
              height: 224,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Address not available',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 24),

          // Address text
          if (address.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                address,
                style: const TextStyle(
                  color: Colors.white54,
                  fontFamily: 'monospace',
                  fontSize: 13,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 24),

          // Copy button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: address.isNotEmpty ? _copyAddress : null,
              icon: const Icon(Icons.copy_rounded, size: 18),
              label: const Text('Copy Address'),
              style: OutlinedButton.styleFrom(
                foregroundColor: chainColor,
                side: BorderSide(color: chainColor, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
