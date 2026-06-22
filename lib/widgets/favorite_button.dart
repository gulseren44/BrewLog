// lib/widgets/favorite_button.dart
//
// Tekrar kullanılabilir favori (kalp) butonu.
// Hem HomeScreen'deki kart üzerinde hem de DetailScreen'de aynı widget
// kullanılır; tasarımı/kodları çift yazmamak için ayrı bir widget olarak
// çıkarıldı.
//
// Bu widget "controlled component" mantığıyla çalışır: kendi state'ini
// tutmaz, dışarıdan aldığı isFavorite değerine göre çizilir ve
// dokunulduğunda onPressed callback'ini çağırır. Gerçek state değişimi
// (setState) onu çağıran üst widget'ta (Home/DetailScreen) gerçekleşir.

import 'package:flutter/material.dart';
import 'app_colors.dart';

class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onPressed;
  final double iconSize;

  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onPressed,
    this.iconSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      // Hafif yarı saydam beyaz zemin: kart üzerindeki görseller koyu/açık
      // olabileceğinden kalp ikonu her zemin renginde de net görünsün.
      color: Colors.white.withValues(alpha: 0.85),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Icon(
            // isFavorite true ise dolu kırmızı kalp, değilse boş gri kalp.
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.redAccent : AppColors.caramel,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
