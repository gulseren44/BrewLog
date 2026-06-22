// lib/data/services/coffee_service.dart
//
// Bu servis, assets/data/coffee_data.json dosyasını okuyup
// List<Coffee> nesnesine dönüştürmekten sorumludur.
//
// "Neden ayrı bir servis dosyası?" -> Single Responsibility prensibi:
// HomeScreen sadece UI çizmekle, CoffeeService ise veri okuma/parse işiyle
// ilgilenir. İleride veri kaynağı (örn. bir REST API) değişirse sadece bu
// dosyayı güncellemek yeterli olur, UI kodlarına dokunulmaz.

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/coffee_model.dart';

class CoffeeService {
  // JSON dosyasının assets içindeki yolu.
  // pubspec.yaml'da bu yolun "assets:" altında tanımlı olması ZORUNLUDUR,
  // aksi halde rootBundle.loadString bu dosyayı bulamaz.
  static const String _jsonPath = 'assets/data/coffee_data.json';

  // Future<List<Coffee>> dönen asenkron metod.
  // HomeScreen içinde FutureBuilder ile tüketilecek.
  Future<List<Coffee>> loadCoffees() async {
    try {
      // 1. Adım: Ham JSON metnini asset bundle'dan oku.
      final String jsonString = await rootBundle.loadString(_jsonPath);

      // 2. Adım: String -> dynamic (List<Map<String, dynamic>>) decode et.
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;

      // 3. Adım: Her bir Map'i Coffee.fromJson ile model nesnesine çevir.
      final List<Coffee> coffees = jsonList
          .map((item) => Coffee.fromJson(item as Map<String, dynamic>))
          .toList();

      return coffees;
    } catch (e) {
      // JSON formatı bozuksa veya dosya bulunamazsa hatayı yukarı fırlatıyoruz.
      // FutureBuilder'ın snapshot.hasError kısmı bunu kullanıcıya
      // anlamlı bir hata mesajı olarak gösterecek.
      throw Exception('Kahve verileri yüklenirken hata oluştu: $e');
    }
  }
}
