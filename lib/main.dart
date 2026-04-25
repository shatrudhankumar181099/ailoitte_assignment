import 'package:ailoitte/services/network_services.dart';
import 'package:ailoitte/utils/exports.dart';
import 'package:ailoitte/view/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'utils/no_internet_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp();
  await Hive.openBox('notes');
  await Hive.openBox('queue');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final networkStatus = ref.watch(networkStatusProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ailoitte',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      builder: (context,child){
        return Stack(
          children: [
            child!,
            networkStatus.when(
              data: (isOnline) => NoInternetScreen(isConnected: isOnline),
              error: (_, __) => const SizedBox(),
              loading: () => const SizedBox(),
            )
          ],
        );
      },
    );
  }
}

