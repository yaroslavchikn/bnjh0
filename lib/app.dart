import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'theme.dart';

class MediaXApp extends StatelessWidget {
  const MediaXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediaX',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      home: const HomeScreen(),
    );
  }
}
