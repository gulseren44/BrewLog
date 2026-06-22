# ☕ BrewLog

BrewLog, Flutter ve Dart kullanılarak geliştirilmiş, minimalist tasarıma sahip asenkron bir mobil kahve katalog uygulamasıdır. Kullanıcıların dünya kahvelerini incelemesini, arama yapmasını ve favorilerini yönetmesini sağlar.

## 🚀 Özellikler
- **Asenkron Veri Yönetimi:** Kahve verileri `FutureBuilder` mimarisiyle yerel bir JSON dosyasından asenkron olarak çekilir ve önbelleğe alınır.
- **Anlık Arama & Filtreleme:** Arayüz performansını etkilemeyen, kahve adı ve kökenine göre çalışan çift yönlü yerel filtreleme algoritması.
- **Kart Tabanlı Tasarım:** Bellek yönetimini optimize eden `GridView.builder` (lazy-loading) yapısı.
- **State Yönetimi & Yaşam Döngüsü:** Favori ekleme/çıkarma işlemleri ve controller kaynaklı bellek sızıntılarını (memory leak) önleyen `StatefulWidget` entegrasyonu.
- **Hata Yönetimi (Error Handling):** Ağ gecikmeleri veya hatalı URL'lere karşı `errorBuilder` koruması.

## 📱 Ekran Görüntüleri
| Ana Sayfa | Ürün Detay | Favorilerim |
|---|---|---|
| <img src="screenshots/home_screen.png" width="220"> | <img src="screenshots/detail_screen.png" width="220"> | <img src="screenshots/favorites_screen.png" width="220"> |

## 🛠️ Kullanılan Teknolojiler ve Sürüm Bilgisi
- **Framework:** Flutter (Sürüm: `3.22.x` veya bilgisayarınızdaki mevcut sürüm)
- **Dil:** Dart
- **Veri Formatı:** JSON (Asynchronous Asset Parsing)

## 🏃‍♂️ Çalıştırma Adımları

Projeyi yerel bilgisayarınızda çalıştırmak için aşağıdaki adımları takip edebilirsiniz:

1. **Depoyu Klonlayın:**
   ```bash
   git clone [https://github.com/gulseren44/BrewLog](https://github.com/gulseren44/BrewLog.git)