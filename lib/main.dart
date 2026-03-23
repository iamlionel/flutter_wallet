import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  try {
    await dotenv.load(fileName: 'assets/.env');
  } catch (e, stack) {
    print('❌ [main] 错误: $e');
    print('❌ [main] 堆栈: $stack');
  }
  runApp(ProviderScope(child: MainApp()));
}
