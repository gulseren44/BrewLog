// lib/widgets/app_colors.dart
//
// İstenen renk paletini tek bir yerde topluyoruz.
// Bu sayede UI dosyalarının içine hex kodlarını dağıtmak yerine
// AppColors.background, AppColors.espresso gibi anlamlı isimler kullanırız.
// İleride tema değişirse sadece bu dosya güncellenir.

import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Bu sınıftan nesne türetilmesini engelliyoruz (sadece sabitler için).

  static const Color cream = Color(0xFFE1D4C2); // En açık ton - arka plan
  static const Color sand = Color(0xFFBEB5A9); // Orta-açık ton - kart/ayraç
  static const Color caramel = Color(0xFFA78D78); // Orta ton - ikincil vurgu
  static const Color espresso = Color(0xFF6E473B); // Koyu ton - başlıklar/butonlar
  static const Color darkRoast = Color(0xFF291C0E); // En koyu ton - ana metin
  static const Color cookieCrumble = Color(0xFF4B2E21); // Koyu ton - ikincil vurgu
}
