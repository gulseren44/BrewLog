// lib/screens/favorites_screen.dart
//
// Favoriler sayfası: kullanıcının kalp ikonuna basarak favorilediği
// kahveleri 2'li grid halinde listeler.
//
// Tasarım kararı: Bu sayfa, HomeScreen'deki Coffee nesnelerinin aynısına
// erişmek için "arguments" olarak List<Coffee> alır. Böylece her iki
// sayfa da aynı nesne referanslarını paylaşır; birinde yapılan
// isFavorite değişikliği diğerinde otomatik olarak görünür.
//
// StatefulWidget seçildi: Bu sayfada da favori butonu aktif olacak
// (bir kahveyi favoriden çıkarmak için) ve setState gerekiyor.

import 'package:flutter/material.dart';
import '../data/models/coffee_model.dart';
import '../widgets/app_colors.dart';
import '../widgets/coffee_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // Belirli bir kahvenin favori durumunu tersine çeviren metod.
  // setState burada da aynı HomeScreen mantığıyla çalışır: Coffee nesnesi
  // referans tipi olduğu için değişiklik orijinal listeye de yansır.
  void _toggleFavorite(Coffee coffee) {
    setState(() {
      coffee.toggleFavorite();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Route Arguments'ı karşılama:
    // HomeScreen'den Navigator.pushNamed ile "arguments: coffees" olarak
    // gönderilen List<Coffee> nesnesini burada alıyoruz.
    final List<Coffee> allCoffees =
        ModalRoute.of(context)!.settings.arguments as List<Coffee>;

    // Tüm liste içinden sadece favorileri filtrele.
    // setState her çağrıldığında (favori toggle'da) build yeniden koştuğu
    // için bu filtreleme her zaman güncel durumu yansıtır.
    final List<Coffee> favorites =
        allCoffees.where((c) => c.isFavorite).toList();

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.espresso,
        foregroundColor: AppColors.cream,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Favorilerim',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
      ),
      body: favorites.isEmpty
          // Hiç favorilenen kahve yoksa kullanıcıya bilgilendirici boş durum göster.
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 72,
                    color: AppColors.sand,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Henüz favori kahven yok.',
                    style: TextStyle(
                      fontSize: 17,
                      color: AppColors.espresso,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ana sayfadaki kalp ikonuna basarak\nkahveleri favorilerine ekleyebilirsin.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: AppColors.caramel,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            )
          // Favoriler varsa HomeScreen ile birebir aynı GridView yapısını kullan.
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.78,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final coffee = favorites[index];
                return CoffeeCard(
                  coffee: coffee,
                  onFavoriteToggle: () => _toggleFavorite(coffee),
                  onTap: () async {
                    // Detay sayfasına geçiş: HomeScreen ile aynı route mekanizması.
                    await Navigator.pushNamed(
                      context,
                      '/detail',
                      arguments: coffee,
                    );
                    // Detaydan dönünce (örn. orada favori kaldırıldıysa) listeyi tazele.
                    setState(() {});
                  },
                );
              },
            ),
    );
  }
}
