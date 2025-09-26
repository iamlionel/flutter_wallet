import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/providers/seed_phrase_provider.dart';
import '../../../domain/states/seed_phrase_state.dart';
import '../../../routing/routes.dart';
import '../../core/themes/colors.dart';
import '../../core/themes/dimens.dart';
import '../../core/themes/font_weights.dart';
import '../../core/themes/text_styles.dart';
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
    ref.listen<SeedPhraseState>(seedPhraseProvider, (previous, next) {
      if (previous?.status != next.status &&
          next.status == SeedPhraseStatus.failure) {
        context.showErrorMessage(next.errorMessage);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Check your recovery phrase',
          style: AppTextStyle.overline.copyWith(
            fontSize: 20,
            fontWeight: AppFontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.navigate_before,
            color: AppColors.black,
            size: 40,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Text(
                '''Tap on the words to put them next to each other in the correct order''',
                style: AppTextStyle.overline.copyWith(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: Dimens.of(context).minBlockVertical * 4),
                      DottedBorder(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          child: Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(minHeight: 80),
                            padding: const EdgeInsets.all(20),
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: state.confirmMnemonics
                                  .asMap()
                                  .map(
                                    (key, text) => MapEntry(
                                      key,
                                      MnemonicsChip(
                                        text: text,
                                        index: key + 1,
                                        onTap: () =>
                                            notifier.addSelectedMnemonics(text),
                                      ),
                                    ),
                                  )
                                  .values
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: Dimens.of(context).minBlockVertical * 4),
                      Wrap(
                        runSpacing: 10,
                        spacing: 10,
                        children: state.randomMnemonics
                            .map(
                              (text) => MnemonicsChip(
                                onTap: () =>
                                    notifier.addSelectedMnemonics(text),
                                isSelected: state.confirmMnemonics.contains(
                                  text,
                                ),
                                text: text,
                              ),
                            )
                            .toList(),
                      ),
                      SizedBox(height: Dimens.of(context).minBlockVertical * 2),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Dimens.of(context).minBlockVertical),
              AbsorbPointer(
                absorbing: !state.isMnemonicsValid,
                child: Opacity(
                  opacity: state.isMnemonicsValid ? 1.0 : 0.5,
                  child: SolidButton(
                    text: 'Continue',
                    onPressed: () => context.push(
                      Routes.createPin,
                      extra: state.mnemonics.join(' '),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
