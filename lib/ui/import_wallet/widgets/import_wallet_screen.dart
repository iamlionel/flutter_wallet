import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/routes.dart';
import '../../core/themes/colors.dart';
import '../../widgets/solid_button.dart';

class ImportWalletScreen extends StatefulWidget {
  const ImportWalletScreen({super.key});

  @override
  State<ImportWalletScreen> createState() => _ImportWalletScreenState();
}

class _ImportWalletScreenState extends State<ImportWalletScreen> {
  final _controller = TextEditingController();
  String _errorText = '';
  bool _isValid = false;
  int _wordCount = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final words = value.trim().split(RegExp(r'\s+'));
    final count = value.trim().isEmpty ? 0 : words.length;
    final valid = (count == 12 || count == 24) && bip39.validateMnemonic(value.trim());
    setState(() {
      _wordCount = count;
      _isValid = valid;
      _errorText = count == 0
          ? ''
          : !valid && (count == 12 || count == 24)
              ? 'Invalid mnemonic phrase'
              : count > 24
                  ? 'Too many words'
                  : '';
    });
  }

  void _onContinue() {
    final mnemonics = _controller.text.trim();
    context.push(Routes.createPin, extra: mnemonics);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0C10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1218),
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.white),
        ),
        title: const Text(
          'Import Wallet',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter your secret recovery phrase',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Typically 12 or 24 words, separated by spaces.',
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                    const SizedBox(height: 24),

                    // Warning box
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.warning.withValues(alpha: 0.25)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.lock_outline_rounded, color: AppColors.warning, size: 18),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Never share your recovery phrase. Anyone with it has full access to your wallet.',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Mnemonic input
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _errorText.isNotEmpty
                              ? Colors.red.withValues(alpha: 0.5)
                              : _isValid
                                  ? AppColors.primary.withValues(alpha: 0.5)
                                  : Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: TextField(
                        controller: _controller,
                        onChanged: _onChanged,
                        maxLines: 5,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          height: 1.6,
                        ),
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: 'word1 word2 word3 ...',
                          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_errorText.isNotEmpty)
                          Text(_errorText, style: const TextStyle(color: Colors.red, fontSize: 12))
                        else if (_isValid)
                          const Text('Valid phrase', style: TextStyle(color: AppColors.success, fontSize: 12))
                        else
                          const SizedBox.shrink(),
                        Text(
                          '$_wordCount words',
                          style: TextStyle(
                            color: _isValid ? AppColors.primary : Colors.white38,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: SolidButton(
                text: 'Continue',
                gradient: AppColors.primaryGradient,
                onPressed: _isValid ? _onContinue : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
