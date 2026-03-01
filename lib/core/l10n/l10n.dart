import 'package:flutter/material.dart';
import 'package:notidea/l10n/app_localizations.dart';

/// Desteklenen diller ve lokalizasyon yardımcıları
class L10n {
  L10n._();

  /// Desteklenen diller listesi
  static const supportedLocales = [
    Locale('af'), // Afrikaans
    Locale('am'), // Amharic
    Locale('ar'), // Arabic
    Locale('az'), // Azerbaijani
    Locale('be'), // Belarusian
    Locale('bg'), // Bulgarian
    Locale('bn'), // Bengali
    Locale('bs'), // Bosnian
    Locale('ca'), // Catalan
    Locale('cs'), // Czech
    Locale('cy'), // Welsh
    Locale('da'), // Danish
    Locale('de'), // German
    Locale('el'), // Greek
    Locale('en'), // English
    Locale('es'), // Spanish
    Locale('et'), // Estonian
    Locale('eu'), // Basque
    Locale('fa'), // Persian
    Locale('fi'), // Finnish
    Locale('fil'), // Filipino
    Locale('fr'), // French
    Locale('gl'), // Galician
    Locale('gsw'), // Swiss German
    Locale('gu'), // Gujarati
    Locale('he'), // Hebrew
    Locale('hi'), // Hindi
    Locale('hr'), // Croatian
    Locale('hu'), // Hungarian
    Locale('hy'), // Armenian
    Locale('id'), // Indonesian
    Locale('is'), // Icelandic
    Locale('it'), // Italian
    Locale('ja'), // Japanese
    Locale('ka'), // Georgian
    Locale('kk'), // Kazakh
    Locale('km'), // Khmer
    Locale('kn'), // Kannada
    Locale('ko'), // Korean
    Locale('ky'), // Kyrgyz
    Locale('lo'), // Lao
    Locale('lt'), // Lithuanian
    Locale('lv'), // Latvian
    Locale('mk'), // Macedonian
    Locale('ml'), // Malayalam
    Locale('mn'), // Mongolian
    Locale('mr'), // Marathi
    Locale('ms'), // Malay
    Locale('my'), // Burmese
    Locale('nb'), // Norwegian Bokmål
    Locale('ne'), // Nepali
    Locale('nl'), // Dutch
    Locale('or'), // Odia
    Locale('pa'), // Punjabi
    Locale('pl'), // Polish
    Locale('ps'), // Pashto
    Locale('pt'), // Portuguese
    Locale('ro'), // Romanian
    Locale('ru'), // Russian
    Locale('si'), // Sinhala
    Locale('sk'), // Slovak
    Locale('sl'), // Slovenian
    Locale('sq'), // Albanian
    Locale('sr'), // Serbian
    Locale('sv'), // Swedish
    Locale('sw'), // Swahili
    Locale('ta'), // Tamil
    Locale('te'), // Telugu
    Locale('th'), // Thai
    Locale('tl'), // Tagalog
    Locale('tr'), // Turkish
    Locale('uk'), // Ukrainian
    Locale('ur'), // Urdu
    Locale('uz'), // Uzbek
    Locale('vi'), // Vietnamese
    Locale('zh'), // Chinese (Simplified)
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'), // Chinese (Simplified) explicit
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'), // Chinese (Traditional)
    Locale('zu'), // Zulu
  ];

  /// Varsayılan dil
  static const defaultLocale = Locale('en');

  /// Cihaz diline göre locale çözümleme
  static Locale? localeResolutionCallback(
    Locale? deviceLocale,
    Iterable<Locale> supportedLocales,
  ) {
    if (deviceLocale == null) return defaultLocale;

    for (final locale in supportedLocales) {
      if (locale.languageCode == deviceLocale.languageCode) {
        return locale;
      }
    }

    return defaultLocale;
  }

  /// AppLocalizations'a kısayol erişim
  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context)!;
  }

  /// Locale kodundan görünen isim döndürür
  static String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'af':
        return 'Afrikaans';
      case 'am':
        return 'አማርኛ'; // Amharic
      case 'ar':
        return 'العربية'; // Arabic
      case 'az':
        return 'Azərbaycanca'; // Azerbaijani
      case 'be':
        return 'Беларуская'; // Belarusian
      case 'bg':
        return 'Български'; // Bulgarian
      case 'bn':
        return 'বাংলা'; // Bengali
      case 'bs':
        return 'Bosanski'; // Bosnian
      case 'ca':
        return 'Català'; // Catalan
      case 'cs':
        return 'Čeština'; // Czech
      case 'cy':
        return 'Cymraeg'; // Welsh
      case 'da':
        return 'Dansk'; // Danish
      case 'de':
        return 'Deutsch'; // German
      case 'el':
        return 'Ελληνικά'; // Greek
      case 'en':
        return 'English';
      case 'es':
        return 'Español'; // Spanish
      case 'et':
        return 'Eesti'; // Estonian
      case 'eu':
        return 'Euskera'; // Basque
      case 'fa':
        return 'فارسی'; // Persian
      case 'fi':
        return 'Suomi'; // Finnish
      case 'fil':
        return 'Filipino'; // Filipino
      case 'fr':
        return 'Français'; // French
      case 'gl':
        return 'Galego'; // Galician
      case 'gsw':
        return 'Schweizerdütsch'; // Swiss German
      case 'gu':
        return 'ગુજરાતી'; // Gujarati
      case 'he':
        return 'עברית'; // Hebrew
      case 'hi':
        return 'हिन्दी'; // Hindi
      case 'hr':
        return 'Hrvatski'; // Croatian
      case 'hu':
        return 'Magyar'; // Hungarian
      case 'hy':
        return 'Հայերեն'; // Armenian
      case 'id':
        return 'Bahasa Indonesia'; // Indonesian
      case 'is':
        return 'Íslenska'; // Icelandic
      case 'it':
        return 'Italiano'; // Italian
      case 'ja':
        return '日本語'; // Japanese
      case 'ka':
        return 'ქართული'; // Georgian
      case 'kk':
        return 'Қазақша'; // Kazakh
      case 'km':
        return 'ខ្មែរ'; // Khmer
      case 'kn':
        return 'ಕನ್ನಡ'; // Kannada
      case 'ko':
        return '한국어'; // Korean
      case 'ky':
        return 'Кыргызча'; // Kyrgyz
      case 'lo':
        return 'ລາວ'; // Lao
      case 'lt':
        return 'Lietuvių'; // Lithuanian
      case 'lv':
        return 'Latviešu'; // Latvian
      case 'mk':
        return 'Македонски'; // Macedonian
      case 'ml':
        return 'മലയാളം'; // Malayalam
      case 'mn':
        return 'Монгол'; // Mongolian
      case 'mr':
        return 'मराठी'; // Marathi
      case 'ms':
        return 'Bahasa Melayu'; // Malay
      case 'my':
        return 'မြန်မာ'; // Burmese
      case 'nb':
        return 'Norsk Bokmål'; // Norwegian Bokmål
      case 'ne':
        return 'नेपाली'; // Nepali
      case 'nl':
        return 'Nederlands'; // Dutch
      case 'or':
        return 'ଓଡ଼ିଆ'; // Odia
      case 'pa':
        return 'ਪੰਜਾਬੀ'; // Punjabi
      case 'pl':
        return 'Polski'; // Polish
      case 'ps':
        return 'پشتو'; // Pashto
      case 'pt':
        return 'Português'; // Portuguese
      case 'ro':
        return 'Română'; // Romanian
      case 'ru':
        return 'Русский'; // Russian
      case 'si':
        return 'සිංහල'; // Sinhala
      case 'sk':
        return 'Slovenčina'; // Slovak
      case 'sl':
        return 'Slovenščina'; // Slovenian
      case 'sq':
        return 'Shqip'; // Albanian
      case 'sr':
        return 'Српски'; // Serbian
      case 'sv':
        return 'Svenska'; // Swedish
      case 'sw':
        return 'Kiswahili'; // Swahili
      case 'ta':
        return 'தமிழ்'; // Tamil
      case 'te':
        return 'తెలుగు'; // Telugu
      case 'th':
        return 'ไทย'; // Thai
      case 'tl':
        return 'Tagalog'; // Tagalog
      case 'tr':
        return 'Türkçe'; // Turkish
      case 'uk':
        return 'Українська'; // Ukrainian
      case 'ur':
        return 'اردو'; // Urdu
      case 'uz':
        return 'Ўзбек'; // Uzbek
      case 'vi':
        return 'Tiếng Việt'; // Vietnamese
      case 'zh':
        return '中文'; // Chinese
      case 'zu':
        return 'Zulu';
      default:
        return languageCode;
    }
  }
}
