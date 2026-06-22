// lib/screens/home_screen.dart
//
// Ana sayfa: kahveleri 2'li grid halinde listeler.
// - Veri, CoffeeService aracılığıyla assets/data/coffee_data.json'dan
//   FutureBuilder ile asenkron olarak okunur.
// - StatefulWidget seçildi çünkü favori ikonuna basıldığında listedeki
//   içeriklerin ve arama sonuçlarının setState ile anlık olarak güncellenip
//   ekrana yansıtılması gerekir.

import 'package:flutter/material.dart';
import '../data/models/coffee_model.dart';
import '../data/services/coffee_service.dart';
import '../widgets/app_colors.dart';
import '../widgets/coffee_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Servis nesnesini bir kere oluşturup saklıyoruz.
  final CoffeeService _coffeeService = CoffeeService();

  // Arama çubuğundaki metni kontrol etmek ve temizlemek için controller.
  final TextEditingController _searchController = TextEditingController();

  // Kullanıcının yazdığı arama kelimesini tutan dinamik değişken.
  String _searchQuery = '';

  // Future'ı initState içinde BİR KERE oluşturup bir değişkende tutuyoruz.
  late Future<List<Coffee>> _coffeesFuture;

  @override
  void initState() {
    super.initState();
    _coffeesFuture = _coffeeService.loadCoffees();
  }

  @override
  void dispose() {
    _searchController.dispose(); // Bellek sızıntısını (memory leak) önlemek için kapatıyoruz.
    super.dispose();
  }

  // Belirli bir kahvenin favori durumunu tersine çeviren metod.
  void _toggleFavorite(Coffee coffee) {
    setState(() {
      coffee.toggleFavorite();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
     appBar: AppBar(
  backgroundColor: AppColors.cookieCrumble,
  foregroundColor: AppColors.cream,
  elevation: 0,
  centerTitle: true, // Başlığın (BrewLog) yine tam ortada kalmasını sağlar
  
  // === 1) EN SOL KÖŞEYE LOGO EKLEME (Kırmızı Alan) ===
  leading: const Padding(
    padding: EdgeInsets.only(left: 12.0), // Sol kenardan tatlı bir boşluk
    child: Icon(
      Icons.local_cafe, // İstediğin kahve logosu/ikonu
      color: AppColors.cream,
      size: 26, // Köşede şık durması için biraz büyütebilirsin
    ),
  ),
  
  // === 2) ORTADAKİ BAŞLIK ===
  title: const Text(
    'BrewLog',
    style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
  ),
  
  // Sağ taraftaki mevcut kalp butonu yapın aynen kalıyor
  actions: [
    FutureBuilder<List<Coffee>>(
      future: _coffeesFuture,
      builder: (context, snapshot) {
        final coffees = snapshot.data ?? [];
        return IconButton(
          tooltip: 'Favorilerim',
          icon: const Icon(Icons.favorite, color: AppColors.cream),
          onPressed: coffees.isEmpty
              ? null
              : () async {
                  await Navigator.pushNamed(
                    context,
                    '/favorites',
                    arguments: coffees,
                  );
                  setState(() {});
                },
        );
      },
    ),
    const SizedBox(width: 4),
  ],
),
      body: FutureBuilder<List<Coffee>>(
        future: _coffeesFuture,
        builder: (context, snapshot) {
          // 1) Veri henüz yükleniyor.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.espresso),
            );
          }

          // 2) Bir hata oluştu (örn. JSON bulunamadı / bozuk format).
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Bir hata oluştu:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.darkRoast),
                ),
              ),
            );
          }

          // 3) Veri geldi ama ana liste boş.
          final allCoffees = snapshot.data ?? [];
          if (allCoffees.isEmpty) {
            return const Center(
              child: Text(
                'Henüz kahve eklenmemiş.',
                style: TextStyle(color: AppColors.darkRoast),
              ),
            );
          }

          // 4) Arama Filtreleme Algoritması:
          // Ana listeden gelen verileri kullanıcının yazdığı kelimeye (isim veya kökene) göre eliyoruz.
          final filteredCoffees = allCoffees.where((coffee) {
            final nameMatch = coffee.name.toLowerCase().contains(_searchQuery.toLowerCase());
            final originMatch = coffee.origin.toLowerCase().contains(_searchQuery.toLowerCase());
            return nameMatch || originMatch;
          }).toList();

          // 5) Başarılı Durum: Arama Çubuğu ve GridView'ı dikey düzlemde birleştiriyoruz.
          return Column(
            children: [
              // --- Premium Arama Çubuğu Tasarımı ---
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: AppColors.darkRoast, fontSize: 15),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value; // Her harf değişiminde listeyi tetikler.
                    });
                  },
                  decoration: InputDecoration(
  hintText: 'Kahve adı veya köken ara...',
  hintStyle: TextStyle(color: AppColors.espresso.withValues(alpha: 0.5)),
  prefixIcon: const Icon(Icons.search, color: AppColors.espresso, size: 22),
  suffixIcon: _searchController.text.isNotEmpty
      ? IconButton(
          icon: const Icon(Icons.clear, color: AppColors.espresso, size: 20),
          onPressed: () {
            _searchController.clear();
            setState(() {
              _searchQuery = '';
            });
          },
        )
      : null,
  filled: true,
  fillColor: AppColors.cream,
  contentPadding: const EdgeInsets.symmetric(vertical: 0),
  
  // Genel border kuralı (Yedek koruma)
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(28),
    borderSide: const BorderSide(color: AppColors.espresso, width: 1.2),
  ),
  
  // Üstüne TIKLANMAMIŞKEN (Normal dururken) görünecek çizgi
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(28),
    // Çizginin rengini uygulamanın ana espresso rengi yaptık, kalınlığını 1.2 ayarladık
    borderSide: const BorderSide(color: AppColors.espresso, width: 1.2),
  ),
  
  // Üstüne TIKLANDIĞINDA (Yazı yazma modundayken) görünecek çizgi
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(28),
    // Odaklanınca çizgi kaybolmasın, yine belirgin kalsın (istersen rengini karamel de bırakabilirsin)
    borderSide: const BorderSide(color: AppColors.espresso, width: 1.5),
  ),
  
),
                ),
              ),

              // --- GridView veya Bulunamadı Mesajı ---
              Expanded(
                child: filteredCoffees.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 48, color: AppColors.espresso.withValues(alpha: 0.5)),
                            const SizedBox(height: 12),
                            const Text(
                              'Aradığınız kahve bulunamadı ☕',
                              style: TextStyle(
                                color: AppColors.darkRoast,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.78,
                        ),
                        itemCount: filteredCoffees.length, // Filtrelenmiş eleman sayısı
                        itemBuilder: (context, index) {
                          final coffee = filteredCoffees[index];
                          return CoffeeCard(
                            coffee: coffee,
                            onFavoriteToggle: () => _toggleFavorite(coffee),
                            onTap: () async {
                              await Navigator.pushNamed(
                                context,
                                '/detail',
                                arguments: coffee,
                              );
                              setState(() {}); 
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}