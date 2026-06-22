// lib/widgets/coffee_card.dart
//
// GridView içinde her bir kahveyi temsil eden kart widget'ı.
// Sorumluluğu sadece "görsel + isim + orijin + favori ikonu" göstermek
// ve tıklanma/favori olaylarını yukarıya (HomeScreen'e) iletmektir.
// Kartın kendisi state tutmaz (StatelessWidget) -> tek doğruluk kaynağı
// her zaman HomeScreen'deki Coffee listesidir.

import 'package:flutter/material.dart';
import '../data/models/coffee_model.dart';
import 'app_colors.dart';
import 'favorite_button.dart';

class CoffeeCard extends StatelessWidget {
  final Coffee coffee;
  final VoidCallback onTap; // Karta tıklanınca (detay sayfasına git)
  final VoidCallback onFavoriteToggle; // Kalp ikonuna tıklanınca

  const CoffeeCard({
    super.key,
    required this.coffee,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // Kartın gölgesini ve köşe yuvarlaklığını birlikte tanımlıyoruz.
      color: AppColors.cream,
      elevation: 3,
      clipBehavior: Clip.antiAlias, // İçerik (resim) köşelerden taşmasın.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            // Kartın ana içeriği: görsel + isim + orijin.
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Görsel alanı: ClipRRect ile üst köşeleri yuvarlatıyoruz.
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1.1, // Görselin kareye yakın görünmesi için
                    child: Image.network(
                      coffee.imageUrl,
                      fit: BoxFit.cover,
                      
                      // İnternetten görsel indirilirken gösterilecek yüklenme animasyonu
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child; // Yükleme bittiyse resmi göster
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColors.espresso,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },

                      // Görsel API linkinden yüklenemezse veya internet yoksa
                      // kullanıcı dostu bir yedek (placeholder) gösteriyoruz.
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.sand,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.coffee,
                            size: 40,
                            color: AppColors.espresso,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coffee.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.darkRoast,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.public,
                            size: 13,
                            color: AppColors.espresso,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              coffee.origin,
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: AppColors.espresso,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Favori ikonu: Stack sayesinde kartın sağ üst köşesinde
            // görselin üzerinde "yüzer" şekilde konumlandırılıyor.
            Positioned(
              top: 8,
              right: 8,
              child: FavoriteButton(
                isFavorite: coffee.isFavorite,
                onPressed: onFavoriteToggle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}