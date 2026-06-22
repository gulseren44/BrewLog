// lib/data/models/coffee_model.dart
//
// Coffee veri modeli.
// JSON <-> Dart nesne dönüşümlerini (fromJson / toJson) burada tutuyoruz.
// Bu sayede UI katmanı (screens, widgets) hiçbir zaman ham JSON/Map ile
// uğraşmaz; her zaman tip güvenli bir Coffee nesnesiyle çalışır.
class Coffee {
  final int id;
  final String name;
  final String origin;
  final String roastLevel;
  final String description;
  final String imageUrl;

  // isFavorite "final" DEĞİL çünkü kullanıcı favori butonuna bastığında
  // bu alanın runtime'da değişmesi gerekiyor (bkz. toggleFavorite metodu).
  bool isFavorite;

  Coffee({
    required this.id,
    required this.name,
    required this.origin,
    required this.roastLevel,
    required this.description,
    required this.imageUrl,
    this.isFavorite = false,
  });

  // JSON Map -> Coffee nesnesi.
  // CoffeeService, JSON dosyasından okuduğu her bir Map'i bu factory
  // constructor üzerinden Coffee nesnesine çevirir.
  factory Coffee.fromJson(Map<String, dynamic> json) {
    return Coffee(
      id: json['id'] as int,
      name: json['name'] as String,
      origin: json['origin'] as String,
      roastLevel: json['roastLevel'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      // JSON'da isFavorite olmasa bile uygulama çökmesin diye varsayılan false.
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  // Coffee nesnesi -> JSON Map.
  // Şu an dosyaya geri yazma yapmıyoruz ama ileride (örn. favori durumunu
  // kalıcı kaydetmek, debug loglamak, paylaşmak) ihtiyaç olabileceği için
  // standart bir pratik olarak ekliyoruz.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'origin': origin,
      'roastLevel': roastLevel,
      'description': description,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
    };
  }

  // Favori durumunu tersine çeviren yardımcı metod.
  // Widget'lar içinde "coffee.isFavorite = !coffee.isFavorite" yazmak yerine
  // bu metodu çağırmak niyeti daha açık ve okunabilir kılar.
  void toggleFavorite() {
    isFavorite = !isFavorite;
  }
}
