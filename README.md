# Mini Katalog Uygulaması

Flutter eğitimi kapsamında geliştirilen **Mini Katalog** uygulaması. Ana sayfa, ürün kataloğu (GridView), ürün detayı, arama/filtreleme ve sepet simülasyonu içerir.

## Özellikler

- Ürün verisi **canlı API**'den: `https://wantapi.com/products.php`
- İnternet yoksa yedek: `assets/data/products.json`
- `Product` modeli (`fromJson` / `toJson`)
- Named Routes ve Route Arguments ile sayfa geçişleri
- `GridView.builder` ile ürün kartları
- Basit sepet state yönetimi (`ChangeNotifier`)
- Responsive arayüz (`flutter_screenutil`, tasarım: 375×812)
- Banner ve ürün görselleri için ağ görselleri (wantapi.com)

## Kullanılan Flutter sürümü

- Flutter **3.47.3**
- Dart **3.13.3**

## Çalıştırma adımları

1. Flutter SDK kurulu olduğundan emin olun (`flutter doctor`).
2. Proje klasöründe bağımlılıkları alın:

   ```bash
   flutter pub get
   ```

3. Emülatör veya fiziksel cihaz bağlayın, ardından:

   ```bash
   flutter run
   ```

## Proje yapısı

```text
lib/
  main.dart
  app.dart
  models/product.dart
  data/product_repository.dart
  screens/
  widgets/
  routes/
  state/
assets/
  data/products.json
```

## Ekran görüntüleri

Teslim için `screenshots/` klasörüne uygulama ekran görüntülerini ekleyin:

- Ana sayfa
- Ürün kataloğu
- Ürün detayı
- Sepet

## Veri kaynağı

Eğitim dokümanında belirtilen demo API:

- Banner: `https://wantapi.com/assets/banner.png`
- Ürün listesi referansı: `https://wantapi.com/products.php`

Uygulama, ek paket kullanmadan yerel JSON dosyasından veri okur; görseller ağ üzerinden yüklenir.
