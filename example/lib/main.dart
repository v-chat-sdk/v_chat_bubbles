import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'pages/style_selector_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Brightness _brightness = Brightness.dark;
  Locale _locale = const Locale('en');
  void _onBrightnessChanged(Brightness brightness) {
    setState(() => _brightness = brightness);
  }

  void _onLocaleChanged(Locale locale) {
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'v_chat_bubbles Demo',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ar')],
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.dark,
      home: StyleSelectorPage(
        brightness: _brightness,
        locale: _locale,
        onBrightnessChanged: _onBrightnessChanged,
        onLocaleChanged: _onLocaleChanged,
      ),
    );
  }
}
