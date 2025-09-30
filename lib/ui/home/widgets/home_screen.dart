import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../data/providers/app_provider.dart';
import '../../../data/providers/contract_provider.dart';
import '../../core/themes/colors.dart';
import '../../core/themes/font_weights.dart';
import '../../core/themes/text_styles.dart';
import '../../widgets/action_button.dart';
import '../../widgets/add_token_bottom_sheet.dart';
import '../../widgets/extension.dart';
import '../../widgets/send_bottom_sheet.dart';
import '../../widgets/swap_bottom_sheet.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = ref.watch(appProvider);
    final ethBalanceAsync = ref.watch(
      ethBalanceProvider(app.wallet.publicKey ?? ''),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wallet 1',
          style: AppTextStyle.overline.copyWith(
            fontSize: 20,
            fontWeight: AppFontWeight.bold,
          ),
        ),
        leading: const Padding(
          padding: EdgeInsets.all(8),
          child: CircleAvatar(),
        ),
        actions: [
          InkResponse(
            onTap: () {
              _showAddTokenBottomSheet(context);
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: CircleAvatar(
                backgroundColor: AppColors.secondary,
                child: Icon(Icons.add, color: AppColors.white, size: 30),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: context.minBlockVertical * 3),
            ethBalanceAsync.when(
              data: (ethBalance) {
                return Text(
                  '0.00 ETH',
                  style: AppTextStyle.headline1.copyWith(fontSize: 40),
                );
              },
              error: (error, stack) {
                return Text(
                  'Error',
                  style: AppTextStyle.headline1.copyWith(fontSize: 40),
                );
              },
              loading: () => Text(
                'Loading...',
                style: AppTextStyle.headline1.copyWith(fontSize: 40),
              ),
            ),
            SizedBox(height: context.minBlockVertical * 2),
            InkWell(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  color: AppColors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getShortAddress(app.wallet.publicKey),
                      style: AppTextStyle.overline.copyWith(fontSize: 18),
                    ),
                    SizedBox(height: context.minBlockVertical),
                    const Icon(Icons.copy),
                  ],
                ),
              ),
            ),
            SizedBox(height: context.minBlockVertical * 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ActionButton(
                  icon: Icons.call_made,
                  text: 'Send',
                  onTap: () => _showSendTokenBottomSheet(context),
                ),
                if (1 == 2)
                  ActionButton(
                    icon: Icons.call_received,
                    text: 'Receive',
                    onTap: () {},
                  ),
                ActionButton(
                  icon: Icons.swap_horiz,
                  text: 'Swap',
                  onTap: () => _showSwapTokenBottomSheet(context),
                ),
              ],
            ),
            SizedBox(height: context.minBlockVertical * 5),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(color: AppColors.grey.withOpacity(0.3)),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Assets',
                        style: AppTextStyle.overline.copyWith(
                          color: AppColors.white,
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Activity',
                        style: AppTextStyle.overline.copyWith(
                          fontWeight: AppFontWeight.semiBold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.minBlockVertical * 2),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey)),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(),
                        SizedBox(width: context.minBlockVertical * 2),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BTC',
                              style: AppTextStyle.overline.copyWith(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '12,000',
                              style: AppTextStyle.overline.copyWith(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Icon(Icons.navigate_next, size: 30),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 20);
                },
                itemCount: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getShortAddress(String? mainAddress) {
    if (mainAddress == null) return '';
    final address =
        '${mainAddress.substring(0, 5)}...${mainAddress.substring(mainAddress.length - 4)}';
    return address;
  }

  void _showAddTokenBottomSheet(BuildContext context) {
    showMaterialModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddTokenBottomSheet(),
    );
  }

  void _showSendTokenBottomSheet(BuildContext context) {
    showMaterialModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const SendBottomSheet(),
    );
  }

  void _showSwapTokenBottomSheet(BuildContext context) {
    showMaterialModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const SwapBottomSheet(),
    );
  }
}
