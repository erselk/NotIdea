import json
from pathlib import Path

from deep_translator import GoogleTranslator  # type: ignore[import]

"""app_en.arb'deki update metinlerini 78 dile çevirir.

Sadece şu anahtarlar çevrilir:
- updateAvailableTitle
- updateAvailableMessage
- updateRequiredTitle
- updateRequiredMessage
- updateNow
- updateLater
- updateChangelog
- openDownloadPage

`app_en.arb` İngilizce kaynak, `app_tr.arb` Türkçe elle yazılmış
olarak kalır. Diğer tüm `app_XX.arb` dosyalarında bu anahtarlar
hedef dile Google Translate ile çevrilir.

Çalıştırma:
  cd e:/Projects/NotIdea
  python tool/translate_update_keys.py
"""

L10N_DIR = Path("lib/l10n")
EN_FILE = L10N_DIR / "app_en.arb"

KEYS = [
    "updateAvailableTitle",
    "updateAvailableMessage",
    "updateRequiredTitle",
    "updateRequiredMessage",
    "updateNow",
    "updateLater",
    "updateChangelog",
    "openDownloadPage",
]

# Google Translate'in desteklemediği bazı locale kodları için fallback'ler.
LOCALE_FALLBACK = {
    "fil": "tl",   # Filipino -> Tagalog
    "gsw": "de",   # İsviçre Almancası -> Almanca
    "nb": "no",    # Norveççe Bokmål -> Norveççe
}


def _load_json(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


def _save_json(path: Path, data: dict) -> None:
    text = json.dumps(data, ensure_ascii=False, indent=2)
    path.write_text(text + "\n", encoding="utf-8")


def _locale_from_filename(name: str) -> str:
    # app_xx.arb veya app_xx_YY.arb -> xx veya xx_YY
    base = name.removeprefix("app_").removesuffix(".arb")
    return base


def _target_code(locale: str) -> str:
    # Google için: alt çizgiyi tireye çevir, bazı özel fallback'ler kullan
    base = LOCALE_FALLBACK.get(locale, locale)
    return base.replace("_", "-")


def main() -> None:
    if not EN_FILE.exists():
        print("[ERROR] lib/l10n/app_en.arb bulunamadı")
        return

    en = _load_json(EN_FILE)
    source = {k: str(en.get(k, "")) for k in KEYS}

    if not L10N_DIR.exists():
        print("[ERROR] lib/l10n klasörü bulunamadı")
        return

    for file in sorted(L10N_DIR.glob("app_*.arb")):
        name = file.name
        # İngilizce ve Türkçe zaten elle düzgün, onlara dokunma
        if name in {"app_en.arb", "app_tr.arb"}:
            continue

        locale = _locale_from_filename(name)
        target = _target_code(locale)
        print(f"\n==> {name} (locale={locale}, target={target})")

        data = _load_json(file)
        changed = False

        try:
            translator = GoogleTranslator(source="en", target=target)
        except Exception as e:  # pragma: no cover - network/config hataları
            print(f"  [WARN] Translator init failed for {name}: {e}")
            continue

        for key, en_value in source.items():
            current = data.get(key)
            # Zaten çevrilmiş ve İngilizce değilse dokunma
            if isinstance(current, str) and current.strip() and current != en_value:
                continue

            if not en_value.strip():
                continue

            try:
                translated = translator.translate(en_value)
            except Exception as e:  # pragma: no cover
                # Bazı dillerde (özellikle console encoding) hata olabilir;
                # o durumda İngilizce fallback bırakıyoruz.
                print(f"  [WARN] translate error for {key}: {e}")
                continue

            data[key] = translated
            changed = True
            # print sırasında encoding hatası almamak için sadece key yaz.
            try:
                print(f"  {key}")
            except Exception:
                pass

        if changed:
            _save_json(file, data)
            print(f"  [OK] Saved {file}")
        else:
            print("  (no changes)")


if __name__ == "__main__":
    main()

