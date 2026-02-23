# NotIdea

**Yaratıcı not tutma arkadaşın.**

NotIdea, markdown formatında not oluşturmanı, düzenlenmeni, paylaşmanı ve keşfetmeni sağlayan modern bir mobil uygulamadır. Arkadaşlarınla ve gruplarınla notlarını paylaşabilir, topluluktan ilham alabilirsin.

---

## Özellikler

- **Markdown Not Düzenleme** — Zengin metin desteğiyle notlarını markdown formatında yaz
- **Gerçek Zamanlı Senkronizasyon** — Notların bulut üzerinde güvenle saklanır ve cihazlar arası senkronize edilir
- **Çevrimdışı Destek** — İnternet olmadan da notlarına erişebilir, düzenleyebilirsin
- **Paylaşım & İşbirliği** — Notlarını arkadaşlarınla, gruplarla veya herkesle paylaş
- **Keşfet** — Topluluğun paylaştığı herkese açık notları keşfet
- **Favoriler** — Beğendiğin notları favorilerine ekle
- **Gruplar** — Grup oluştur ve grup üyeleriyle notlarını paylaş
- **Arkadaşlık Sistemi** — Kullanıcıları arkadaş olarak ekle ve notlarını paylaş
- **Tema Desteği** — Açık, koyu ve sistem teması seçenekleri
- **Çoklu Dil** — Türkçe ve İngilizce dil desteği
- **Güvenli Kimlik Doğrulama** — Supabase Auth ile güvenli giriş/kayıt
- **Medya Desteği** — Notlarına görsel ekle, otomatik optimizasyon
- **Çöp Kutusu** — Silinen notlar 30 gün boyunca geri yüklenebilir

---

## Teknoloji Altyapısı

| Kategori | Teknoloji |
|---|---|
| Framework | Flutter (Dart) |
| State Management | Riverpod (`@riverpod` annotation) |
| Routing | GoRouter |
| Backend | Supabase (Frankfurt / fra1) |
| Database | PostgreSQL (Neon) via Supabase |
| Local DB | Isar |
| Styling | Mix (utility-first) |
| Data Models | Freezed + json_serializable |
| Markdown | flutter_markdown |
| Auth | Supabase Auth |
| Storage | Supabase Storage |
| Image | cached_network_image, image_picker, image_cropper |
| Env | envied (.env) |

---

## Klasör Yapısı

```
lib/
├── main.dart                         # Uygulama giriş noktası
├── app.dart                          # MaterialApp.router yapılandırması
├── config/
│   ├── env.dart                      # Ortam değişkenleri (envied)
│   └── supabase_config.dart          # Supabase istemci yapılandırması
├── core/
│   ├── constants/                    # Sabitler
│   ├── l10n/                         # Lokalizasyon yardımcıları
│   ├── router/                       # GoRouter yapılandırması ve rota sabitleri
│   ├── theme/                        # Tema, renkler ve ThemeExtensions
│   └── utils/                        # Yardımcı fonksiyonlar ve uzantılar
├── l10n/
│   ├── app_en.arb                    # İngilizce çeviriler
│   └── app_tr.arb                    # Türkçe çeviriler
├── shared/
│   ├── providers/                    # Paylaşılan provider'lar (tema, dil)
│   └── widgets/                      # Paylaşılan widget'lar
└── features/
    ├── auth/                         # Kimlik doğrulama
    ├── notes/                        # Not CRUD, düzenleyici, detay
    ├── profile/                      # Profil yönetimi
    ├── friends/                      # Arkadaşlık sistemi
    ├── groups/                       # Grup yönetimi
    ├── legal/                        # Hukuki sayfalar
    ├── settings/                     # Ayarlar ekranı
    └── splash/                       # Açılış ekranı
```

Her feature modülü Clean Architecture prensibiyle yapılandırılmıştır:
```
feature/
├── data/
│   ├── datasources/   # Remote ve local veri kaynakları
│   └── repositories/  # Repository implementasyonları
├── domain/
│   ├── models/        # Veri modelleri (Freezed)
│   └── repositories/  # Repository arayüzleri
└── presentation/
    ├── screens/       # Ekranlar
    ├── widgets/       # Feature-specific widget'lar
    └── providers/     # Riverpod provider'lar
```

---

## Kurulum

### Gereksinimler

- Flutter SDK ^3.10.7
- Dart SDK ^3.10.7
- Supabase hesabı
- (İsteğe bağlı) Android Studio / VS Code

### Adımlar

1. **Projeyi klonlayın:**
   ```bash
   git clone https://github.com/your-username/notidea.git
   cd notidea
   ```

2. **Ortam değişkenlerini ayarlayın:**
   ```bash
   cp .env.example .env
   ```
   `.env` dosyasını açın ve Supabase bilgilerinizi girin:
   ```
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your-anon-key
   ```

3. **Bağımlılıkları yükleyin:**
   ```bash
   flutter pub get
   ```

4. **Kod oluşturmayı çalıştırın:**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. **Supabase migration'ları uygulayın:**
   ```bash
   supabase db push
   ```
   Veya SQL migration dosyalarını Supabase Dashboard > SQL Editor üzerinden çalıştırın.

6. **Uygulamayı başlatın:**
   ```bash
   flutter run
   ```

---

## Supabase Kurulumu

1. [Supabase Dashboard](https://supabase.com/dashboard)'a gidin ve yeni bir proje oluşturun
   - **Region:** Frankfurt (fra1 / EU Central)
   - **Database:** Neon PostgreSQL (varsayılan)

2. Migration SQL dosyalarını çalıştırın:
   - `supabase/migrations/` klasöründeki `.sql` dosyalarını sırasıyla çalıştırın
   - Bu migration'lar tabloları, RLS politikalarını ve storage bucket'ları oluşturur

3. **Storage Bucket'ları** (migration tarafından otomatik oluşturulur):
   - `avatars` — Kullanıcı profil fotoğrafları
   - `note-images` — Not görselleri

4. **API Anahtarlarını alın:**
   - Dashboard > Settings > API
   - **Project URL** → `SUPABASE_URL`
   - **anon public key** → `SUPABASE_ANON_KEY`

5. `.env` dosyanıza anahtarları girin

---

## Katkıda Bulunma

1. Bu projeyi fork edin
2. Feature branch oluşturun: `git checkout -b feature/yeni-ozellik`
3. Değişikliklerinizi commit edin: `git commit -m 'feat: yeni özellik eklendi'`
4. Branch'inizi push edin: `git push origin feature/yeni-ozellik`
5. Pull Request açın

### Commit Mesajı Formatı

```
feat: yeni özellik
fix: hata düzeltmesi
refactor: kod düzenlemesi
docs: dokümantasyon güncelleme
style: biçimlendirme değişikliği
test: test ekleme/düzenleme
chore: genel bakım
```

---

## Lisans

Bu proje [MIT Lisansı](LICENSE) altında lisanslanmıştır.

```
MIT License

Copyright (c) 2026 NotIdea

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
