import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/themes/colors.dart';
import '../../core/themes/dimens.dart';
import '../../widgets/solid_button.dart';

class LandingScreen extends StatefulWidget {
  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/logo.svg',
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(height: Dimens.of(context).minBlockVertical * 2),
                    Text('MyWallet'),
                  ],
                ),
              ),
              SizedBox(height: Dimens.of(context).minBlockVertical * 5),
              SolidButton(text: 'Create a new Wallet', onPressed: () => {}),
              SizedBox(height: Dimens.of(context).minBlockVertical * 2),
              SolidButton(
                text: 'I already have a wallet',
                color: AppColors.secondary,
                textColor: AppColors.white,
                onPressed: () => {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
