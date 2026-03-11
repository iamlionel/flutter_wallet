import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/providers/seed_phrase_provider.dart';
import '../../../domain/states/seed_phrase_state.dart';
import '../../../routing/routes.dart';
import '../../core/themes/colors.dart';
import '../../widgets/extension.dart';
import '../../widgets/mnemonics_chip.dart';
import '../../widgets/solid_button.dart';

class ConfirmPhraseScreen extends ConsumerStatefulWidget {
  const ConfirmPhraseScreen({super.key});

  @override
  ConsumerState<ConfirmPhraseScreen> createState() =>
      _ConfirmPhraseScreenState();
}

class _ConfirmPhraseScreenState extends ConsumerState<ConfirmPhraseScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(seedPhraseProvider);
    final notifier = ref.read(seedPhraseProvider.notifier);
    final theme = Theme.of(context);

    ref.listen<SeedPhraseState>(seedPhraseProvider, (previous, next) {
      if (previous?.status != next.status &&
          next.status == SeedPhraseStatus.failure) {
        context.showErrorMessage(next.errorMessage);
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Confirm Phrase'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: AppColors.backgroundGradient,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Verification',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select words in the correct order.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Confirmation Grid
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 140),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: state.isMnemonicsValid
                            ? AppColors.success.withOpacity(0.3)
                            : Colors.white.withOpacity(0.08),
                      ),
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 2.0,
                          ),
                      itemCount: state.confirmMnemonics.length,
                      itemBuilder: (context, index) {
                        return MnemonicsChip(
                          text: state.confirmMnemonics[index],
                          index: index + 1,
                          onTap: () => notifier.addSelectedMnemonics(
                            state.confirmMnemonics[index],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Random Words Grid
                  Expanded(
                    child: SingleChildScrollView(
                      child: Center(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: state.randomMnemonics.map((text) {
                            final isSelected = state.confirmMnemonics.contains(
                              text,
                            );
                            return MnemonicsChip(
                              text: text,
                              isSelected: isSelected,
                              onTap: isSelected
                                  ? null
                                  : () => notifier.addSelectedMnemonics(text),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SolidButton(
                    text: 'Continue',
                    gradient: state.isMnemonicsValid
                        ? AppColors.primaryGradient
                        : null,
                    color: state.isMnemonicsValid
                        ? null
                        : Colors.white.withOpacity(0.05),
                    textColor: state.isMnemonicsValid
                        ? Colors.black
                        : AppColors.textSecondary,
                    onPressed: state.isMnemonicsValid
                        ? () => context.push(
                            Routes.createPin,
                            extra: state.mnemonics.join(' '),
                          )
                        : null,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
