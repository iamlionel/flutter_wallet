import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/providers/seed_phrase_provider.dart';
import '../../../routing/routes.dart';
import '../../core/themes/colors.dart';
import '../../core/themes/dimens.dart';
import '../../core/themes/font_weights.dart';
import '../../core/themes/text_styles.dart';
import '../../widgets/extension.dart';
import '../../widgets/mnemonics_chip.dart';
import '../../widgets/solid_button.dart';

class SeedPhraseScreen extends ConsumerStatefulWidget {
  const SeedPhraseScreen({super.key});

  @override
  ConsumerState<SeedPhraseScreen> createState() => _SeedPhraseScreenState();
}

class _SeedPhraseScreenState extends ConsumerState<SeedPhraseScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(seedPhraseProvider.notifier).generateMnemonic();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(seedPhraseProvider);
    final notifier = ref.read(seedPhraseProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Recovery Phrase'),
        leading: IconButton(
          onPressed: () => {context.pop()},
          icon: const Icon(
            Icons.navigate_before,
            color: AppColors.black,
            size: 40,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ).add(const EdgeInsets.only(bottom: 20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Dimens.of(context).minBlockVertical * 4),
              Text(
                '''Write down these 12 words in the correct order and keep them in a safe place''',
                style: AppTextStyle.overline.copyWith(),
              ),
              SizedBox(height: Dimens.of(context).minBlockVertical * 3),
              DottedBorder(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Consumer(
                      builder: (context, ref, child) {
                        return Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: state.mnemonics
                              .asMap()
                              .map(
                                (key, text) => MapEntry(
                                  key,
                                  MnemonicsChip(text: text, index: key + 1),
                                ),
                              )
                              .values
                              .toList(),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: Dimens.of(context).minBlockVertical * 2),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(text: state.mnemonics.join(' ')),
                  );
                  context.showSuccessMessage('Copied Successfully');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.copy, color: AppColors.primary),
                    const SizedBox(width: 5),
                    Text(
                      'Copy to clipboard',
                      style: AppTextStyle.overline.copyWith(
                        color: AppColors.primary,
                        fontWeight: AppFontWeight.semiBold,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.dangerous_outlined, color: Colors.red),
                    SizedBox(width: Dimens.of(context).minBlockHorizontal * 2),
                    Expanded(
                      child: Text(
                        '''Keep your recovery phrase in a safe place and don't share it with anyone!''',
                        style: AppTextStyle.overline.copyWith(
                          color: Colors.red,
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimens.of(context).minBlockVertical * 3),
              SolidButton(
                text: 'Continue',
                onPressed: () {
                  notifier.clearSelectedMnemonics();
                  context.push(Routes.confirmSeedPhrase);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
