// lib/screens/detail_screen.dart
//
// Detay sayfası: HomeScreen'den Navigator.pushNamed ile "arguments"
// olarak gönderilen Coffee nesnesini karşılar ve detaylarını gösterir.
//
// StatefulWidget seçildi çünkü bu sayfadaki favori butonuna basıldığında
// da (sadece HomeScreen'de değil) isFavorite durumu setState ile anlık
// olarak güncellenip kalp ikonunun rengi değişmeli.

import 'package:flutter/material.dart';
import '../data/models/coffee_model.dart';
import '../widgets/app_colors.dart';
import '../widgets/favorite_button.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    // Route Arguments'ı karşılama:
    // ModalRoute.of(context)!.settings.arguments, main.dart'taki
    // onGenerateRoute (veya routes haritası) içinde Navigator.pushNamed
    // çağrısıyla gönderilen "arguments" değerine erişimizi sağlar.
    // HomeScreen tarafında bir Coffee nesnesi gönderdiğimiz için burada
    // güvenle "as Coffee" cast işlemi yapabiliriz.
    final Coffee coffee =
        ModalRoute.of(context)!.settings.arguments as Coffee;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          // Görsel + geri butonu için genişleyebilen (SliverAppBar) bir üst alan.
          SliverAppBar(
            backgroundColor: AppColors.espresso,
            foregroundColor: AppColors.cream,
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Değişiklik: Image.asset yerine Image.network kullanıldı.
                  Image.network(
                    coffee.imageUrl,
                    fit: BoxFit.cover,
                    
                    // Detay sayfasındaki büyük görsel yüklenirken çalışacak animasyon
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.cream, // AppBar üzerinde beyaz ton şık durur
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },

                    // İnternet hatası veya kırık link durumunda tetiklenecek alan
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.sand,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.coffee,
                          size: 64,
                          color: AppColors.espresso,
                        ),
                      );
                    },
                  ),
                  // Görselin altına hafif bir koyu gradient ekliyoruz ki
                  // üstündeki başlık/ikonlar her görselde okunabilir olsun.
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.0),
                          Colors.black.withValues(alpha: 0.55),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Asıl içerik (isim, orijin, kavurma seviyesi, açıklama, favori).
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Başlık satırı + favori butonu yan yana.
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Navigator.canPop(context) 
                      ? Expanded(
                        child: Text(
                          coffee.name,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkRoast,
                          ),
                        ),
                      )
                      : Expanded(
                        child: Text(
                          coffee.name,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkRoast,
                          ),
                        ),
                      ),
                      // Basit state güncelleme örneği:
                      // Bu butona basıldığında setState tetiklenir,
                      // coffee.isFavorite tersine döner ve ikon rengi
                      // (kırmızı dolu kalp <-> gri boş kalp) anında değişir.
                      FavoriteButton(
                        isFavorite: coffee.isFavorite,
                        iconSize: 28,
                        onPressed: () {
                          setState(() {
                            coffee.toggleFavorite();
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Orijin bilgisi.
                  Row(
                    children: [
                      const Icon(Icons.public,
                          size: 18, color: AppColors.espresso),
                      const SizedBox(width: 6),
                      Text(
                        coffee.origin,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.espresso,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Kavurma seviyesi: küçük bir "chip/etiket" olarak gösteriliyor.
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.caramel,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.local_fire_department,
                            size: 16, color: AppColors.cream),
                        const SizedBox(width: 6),
                        Text(
                          'Kavurma: ${coffee.roastLevel}',
                          style: const TextStyle(
                            color: AppColors.cream,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  const Text(
                    'Açıklama',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkRoast,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    coffee.description,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: AppColors.darkRoast,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}