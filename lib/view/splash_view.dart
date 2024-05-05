import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:togu_yemekhane/provider/splash_provider.dart';
import 'package:togu_yemekhane/view/home_view.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await ref.read(splashProvider.notifier).fetchData().then((value) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return const HomeView();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: CircularProgressIndicator.adaptive(),
    ));
  }
}
