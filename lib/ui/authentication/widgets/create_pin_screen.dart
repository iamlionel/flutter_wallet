import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/providers/create_pin_provider.dart';
import '../../../domain/states/create_pin_state.dart';
import '../../../routing/routes.dart';
import '../../core/themes/text_styles.dart';
import '../../widgets/extension.dart';
import '../../widgets/input_box.dart';
import '../../widgets/solid_button.dart';

class CreatePinScreen extends ConsumerStatefulWidget {
  const CreatePinScreen({Key? key, required this.mnemonics}) : super(key: key);

  final String mnemonics;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatePinState();
}

class _CreatePinState extends ConsumerState<CreatePinScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createPinProvider);
    final notifier = ref.read(createPinProvider.notifier);

    ref.listen<CreatePinState>(createPinProvider, (previous, next) {
      if (next.status == CreatePinStatus.failure) {
        context.showErrorMessage('Oops an error occur, Try again');
      } else if (next.status == CreatePinStatus.success) {
        //todo udpate model
        context.push(Routes.home);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Create your password'),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.navigate_before, color: Colors.black, size: 40),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '''To protect the security of your wallet please register a minimum of 8 passcode''',
                  style: AppTextStyle.overline.copyWith(),
                ),
                SizedBox(height: context.minBlockVertical * 7),
                Text(
                  'Enter your new password',
                  style: AppTextStyle.overline.copyWith(),
                ),
                SizedBox(height: context.minBlockVertical),
                InputBox(
                  hintText: 'Minimum of 8 characters',
                  onChanged: notifier.onPasswordChanged,
                  isPassword: true,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Password is required';
                    }

                    if (value!.length < 8) {
                      return 'Password too short';
                    }
                    return null;
                  },
                ),
                SizedBox(height: context.minBlockVertical * 5),
                Text(
                  'Confirm password',
                  style: AppTextStyle.overline.copyWith(),
                ),
                SizedBox(height: context.minBlockVertical),
                InputBox(
                  hintText: 'Minimum of 8 characters',
                  isPassword: true,
                  onChanged: notifier.onConfirmPasswordChanged,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Confirm Password is required';
                    }

                    if (value!.length < 8) {
                      return 'Password too short';
                    }

                    if (value != state.password) {
                      return 'Password does not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                SolidButton(
                  text: 'Create Wallet',
                  onPressed: state.isValid
                      ? () => notifier.getUserKeys(
                          widget.mnemonics,
                          state.password,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
