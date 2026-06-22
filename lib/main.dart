// lib/main.dart
//
// Uygulamanın giriş noktası.
// - Named Routes burada tanımlanır ('/' ve '/detail').
// - Genel tema (renkler, Material 3) burada merkezi olarak ayarlanır.

import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/favorites_screen.dart';
import 'widgets/app_colors.dart';

void main() {
  runApp(const BrewLogApp());
}

class BrewLogApp extends StatelessWidget {
  const BrewLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrewLog',
      debugShowCheckedModeBanner: false,

      // useMaterial3: true -> güncel Material 3 tasarım dilini kullanır
      // (yuvarlatılmış köşeler, güncellenmiş Card/AppBar görünümü vb.).
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.espresso,
          primary: AppColors.espresso,
          secondary: AppColors.caramel,
          surface: AppColors.cream,
        ),
        scaffoldBackgroundColor: AppColors.cream,
        fontFamily: 'Roboto',
      ),

      // initialRoute: uygulama açıldığında gidilecek ilk rota.
      initialRoute: '/',

      // Named Routes haritası:
      // '/'          -> HomeScreen (kahve grid listesi)
      // '/detail'    -> DetailScreen (seçilen kahvenin detayları)
      // '/favorites' -> FavoritesScreen (favorilenen kahveler)
      //
      // Not: '/detail' ve '/favorites' rotalarına gidilirken
      // Navigator.pushNamed'in "arguments" parametresiyle gönderilen nesne,
      // ilgili Screen içinde ModalRoute.of(context)!.settings.arguments
      // üzerinden okunur.
      routes: {
        '/': (context) => const HomeScreen(),
        '/detail': (context) => const DetailScreen(),
        '/favorites': (context) => const FavoritesScreen(),
      },
    );
  }
}
