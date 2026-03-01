// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appName => 'NotIdea';

  @override
  String get appTagline => 'Kreatív jegyzetkészítő társad';

  @override
  String get ok => 'RENDBEN';

  @override
  String get cancel => 'Mégsem';

  @override
  String get save => 'Megtakarítás';

  @override
  String get delete => 'Töröl';

  @override
  String get edit => 'Szerkesztés';

  @override
  String get share => 'Részesedés';

  @override
  String get search => 'Keresés';

  @override
  String get loading => 'Terhelés...';

  @override
  String get error => 'Hiba';

  @override
  String get retry => 'Próbálja újra';

  @override
  String get done => 'Kész';

  @override
  String get close => 'Közeli';

  @override
  String get back => 'Vissza';

  @override
  String get next => 'Következő';

  @override
  String get confirm => 'Erősítse meg';

  @override
  String get yes => 'Igen';

  @override
  String get no => 'Nem';

  @override
  String get copy => 'Másolat';

  @override
  String get copied => 'Másolva!';

  @override
  String get selectAll => 'Válassza az Összes lehetőséget';

  @override
  String get more => 'Több';

  @override
  String get refresh => 'Frissítés';

  @override
  String get emptyStateGeneral => 'Itt még semmi';

  @override
  String get emptyStateDescription => 'Kezdj el valami csodálatosat alkotni';

  @override
  String get login => 'Bejelentkezés';

  @override
  String get signup => 'Regisztráljon';

  @override
  String get logout => 'Jelentkezzen ki';

  @override
  String get email => 'Email';

  @override
  String get password => 'Jelszó';

  @override
  String get confirmPassword => 'Jelszó megerősítése';

  @override
  String get forgotPassword => 'Elfelejtett jelszó?';

  @override
  String get resetPassword => 'Jelszó visszaállítása';

  @override
  String get sendResetLink => 'Reset Link küldése';

  @override
  String get resetLinkSent =>
      'Jelszó-visszaállítási linket elküldtünk az e-mail címére';

  @override
  String get loginWithEmail => 'Jelentkezzen be e-mail címmel';

  @override
  String get signupWithEmail => 'Regisztráljon e-mailben';

  @override
  String get alreadyHaveAccount => 'Már van fiókja?';

  @override
  String get dontHaveAccount => 'Nincs fiókja?';

  @override
  String get welcomeBack => 'Üdvözöljük Vissza';

  @override
  String get createAccount => 'Fiók létrehozása';

  @override
  String get orContinueWith => 'Vagy folytassa ezzel';

  @override
  String get agreeToTerms =>
      'A regisztrációval Ön elfogadja szolgáltatási feltételeinket és adatvédelmi szabályzatunkat';

  @override
  String get emailRequired => 'E-mail megadása kötelező';

  @override
  String get invalidEmail => 'Kérjük, adjon meg egy érvényes e-mail-címet';

  @override
  String get passwordRequired => 'Jelszó megadása kötelező';

  @override
  String get passwordTooShort =>
      'A jelszónak legalább 8 karakterből kell állnia';

  @override
  String get passwordNeedsUppercase =>
      'A jelszónak legalább egy nagybetűt kell tartalmaznia';

  @override
  String get passwordNeedsLowercase =>
      'A jelszónak legalább egy kisbetűt kell tartalmaznia';

  @override
  String get passwordNeedsDigit =>
      'A jelszónak legalább egy számjegyet kell tartalmaznia';

  @override
  String get passwordsDoNotMatch => 'A jelszavak nem egyeznek';

  @override
  String get createNote => 'Jegyzet létrehozása';

  @override
  String get editNote => 'Jegyzet szerkesztése';

  @override
  String get deleteNote => 'Jegyzet törlése';

  @override
  String get noteTitle => 'Cím';

  @override
  String get noteContent => 'Kezdj el írni...';

  @override
  String get noteTitleHint => 'Írja be a jegyzet címét';

  @override
  String get noteContentHint => 'Írd be a jegyzeted a markdownba...';

  @override
  String get noteDeleted => 'Megjegyzés törölve';

  @override
  String get noteRestored => 'Jegyzet visszaállítva';

  @override
  String get noteSaved => 'Jegyzet mentve';

  @override
  String get noteShared => 'Jegyzet megosztva';

  @override
  String get deleteNoteConfirm => 'Biztosan törli ezt a jegyzetet?';

  @override
  String get deleteNotePermanentConfirm =>
      'Ez a művelet nem vonható vissza. Véglegesen törli?';

  @override
  String get noteVisibility => 'Láthatóság';

  @override
  String get visibilityPrivate => 'Magán';

  @override
  String get visibilityShared => 'Megosztva';

  @override
  String get visibilityPublic => 'Nyilvános';

  @override
  String get visibilityPrivateDesc => 'Ezt a megjegyzést csak Ön láthatja';

  @override
  String get visibilitySharedDesc =>
      'Látható a barátok és a csoporttagok számára';

  @override
  String get visibilityPublicDesc => 'Mindenki számára látható';

  @override
  String get notes => 'Megjegyzések';

  @override
  String get allNotes => 'Minden jegyzet';

  @override
  String get myNotes => 'Saját jegyzetek';

  @override
  String get noNotes => 'Még nincsenek jegyzetek';

  @override
  String get noNotesDesc =>
      'Érintse meg a + gombot az első jegyzet létrehozásához';

  @override
  String get sortBy => 'Rendezés';

  @override
  String get sortNewest => 'Először a legújabb';

  @override
  String get sortOldest => 'Először a legidősebb';

  @override
  String get sortAlphabetical => 'Betűrendes';

  @override
  String get sortLastEdited => 'Utoljára szerkesztve';

  @override
  String get pinNote => 'Pin Megjegyzés';

  @override
  String get unpinNote => 'Megjegyzés rögzítésének feloldása';

  @override
  String get duplicateNote => 'Jegyzet másodpéldánya';

  @override
  String get profile => 'Profil';

  @override
  String get editProfile => 'Profil szerkesztése';

  @override
  String get displayName => 'Megjelenítési név';

  @override
  String get username => 'Felhasználónév';

  @override
  String get bio => 'Bio';

  @override
  String get bioHint => 'Mesélj magadról';

  @override
  String get profileUpdated => 'Profil frissítve';

  @override
  String get changeAvatar => 'Fotó módosítása';

  @override
  String get removeAvatar => 'Fotó eltávolítása';

  @override
  String get usernameRequired => 'Felhasználónév megadása kötelező';

  @override
  String get usernameTooShort =>
      'A felhasználónévnek legalább 3 karakterből kell állnia';

  @override
  String get usernameTooLong =>
      'A felhasználónév legfeljebb 20 karakterből állhat';

  @override
  String get usernameInvalid =>
      'A felhasználónév csak betűket, számokat és aláhúzásjelet tartalmazhat';

  @override
  String get displayNameRequired => 'A megjelenített név kötelező';

  @override
  String get friends => 'Barátok';

  @override
  String get addFriend => 'Barát hozzáadása';

  @override
  String get removeFriend => 'Ismerős eltávolítása';

  @override
  String get friendRequests => 'Baráti kérések';

  @override
  String get pendingRequests => 'Függőben lévő kérések';

  @override
  String get sentRequests => 'Elküldött kérések';

  @override
  String get acceptRequest => 'Elfogadás';

  @override
  String get declineRequest => 'Hanyatlás';

  @override
  String get cancelRequest => 'Kérelem visszavonása';

  @override
  String get sendFriendRequest => 'Baráti felkérés küldése';

  @override
  String get friendRequestSent => 'Ismerős felkérés elküldve';

  @override
  String get friendRequestAccepted => 'Ismerős felkérés elfogadva';

  @override
  String get friendRemoved => 'Ismerős eltávolítva';

  @override
  String get noFriends => 'Még nincsenek barátok';

  @override
  String get noFriendsDesc => 'Keressen embereket, és vegye fel őket barátként';

  @override
  String get noFriendRequests => 'Nincsenek baráti kérések';

  @override
  String get searchFriends => 'Ismerősök keresése...';

  @override
  String get searchUsers => 'Felhasználók keresése...';

  @override
  String get groups => 'Csoportok';

  @override
  String get createGroup => 'Csoport létrehozása';

  @override
  String get groupName => 'Csoport neve';

  @override
  String get groupDescription => 'Leírás';

  @override
  String get members => 'tagok';

  @override
  String get addMembers => 'Tagok hozzáadása';

  @override
  String get removeMember => 'Tag eltávolítása';

  @override
  String get leaveGroup => 'Kilépés a csoportból';

  @override
  String get deleteGroup => 'Csoport törlése';

  @override
  String get groupCreated => 'Csoport létrehozva';

  @override
  String get groupUpdated => 'Csoport frissítve';

  @override
  String get groupDeleted => 'Csoport törölve';

  @override
  String get noGroups => 'Még nincsenek csoportok';

  @override
  String get noGroupsDesc =>
      'Hozzon létre egy csoportot a jegyzetek megosztásához másokkal';

  @override
  String memberCount(int count) {
    return '$count tag';
  }

  @override
  String get explore => 'Fedezze fel';

  @override
  String get exploreDesc => 'Fedezze fel a közösség nyilvános jegyzeteit';

  @override
  String get trending => 'Felkapott';

  @override
  String get recent => 'Legutóbbi';

  @override
  String get noExploreResults => 'Még nincsenek nyilvános jegyzetek';

  @override
  String get noExploreResultsDesc =>
      'Legyen Ön az első, aki megoszt egy jegyzetet a közösséggel';

  @override
  String get favorites => 'Kedvencek';

  @override
  String get addToFavorites => 'Hozzáadás a kedvencekhez';

  @override
  String get removeFromFavorites => 'Eltávolítás a Kedvencek közül';

  @override
  String get addedToFavorites => 'Hozzáadva a kedvencekhez';

  @override
  String get removedFromFavorites => 'Eltávolítva a kedvencek közül';

  @override
  String get noFavorites => 'Még nincs kedvenc';

  @override
  String get noFavoritesDesc =>
      'Koppintson a szív ikonra egy jegyzeten, hogy ide adja hozzá';

  @override
  String get trash => 'Szemét';

  @override
  String get restoreNote => 'Visszaállítás';

  @override
  String get deletePermanently => 'Végleges törlés';

  @override
  String get emptyTrash => 'Ürítse ki a szemetet';

  @override
  String get emptyTrashConfirm =>
      'Véglegesen törli az összes jegyzetet a kukában?';

  @override
  String get trashEmpty => 'A kuka üres';

  @override
  String get trashEmptyDesc => 'A törölt jegyzetek itt jelennek meg';

  @override
  String get trashAutoDeleteInfo =>
      'A kukában lévő jegyzetek 30 nap elteltével véglegesen törlődnek';

  @override
  String get sharedNotes => 'Megosztott jegyzetek';

  @override
  String get sharedWithMe => 'Megosztva velem';

  @override
  String get sharedByMe => 'Megosztottam';

  @override
  String get noSharedNotes => 'Nincsenek megosztott jegyzetek';

  @override
  String get noSharedNotesDesc =>
      'Az Önnel megosztott jegyzetek itt jelennek meg';

  @override
  String get searchHint => 'Jegyzetek, személyek, csoportok keresése...';

  @override
  String get searchNotes => 'Jegyzetek keresése';

  @override
  String get searchResults => 'Keresési eredmények';

  @override
  String get noSearchResults => 'Nincs találat';

  @override
  String get noSearchResultsDesc => 'Próbáljon ki különböző kulcsszavakat';

  @override
  String get recentSearches => 'Legutóbbi keresések';

  @override
  String get clearSearchHistory => 'Keresési előzmények törlése';

  @override
  String get settings => 'Beállítások elemre';

  @override
  String get appearance => 'Megjelenés';

  @override
  String get theme => 'Téma';

  @override
  String get themeLight => 'Fény';

  @override
  String get themeDark => 'Sötét';

  @override
  String get themeSystem => 'Rendszer';

  @override
  String get language => 'Nyelv';

  @override
  String get languageEnglish => 'angol';

  @override
  String get languageTurkish => 'török';

  @override
  String get notifications => 'Értesítések';

  @override
  String get account => 'fiók';

  @override
  String get deleteAccount => 'Fiók törlése lehetőségre';

  @override
  String get deleteAccountConfirm =>
      'Ezzel véglegesen törli a fiókját és az összes adatot. Ez a művelet nem vonható vissza.';

  @override
  String get aboutApp => 'A NotIdeáról';

  @override
  String get version => 'Változat';

  @override
  String get buildNumber => 'Épít';

  @override
  String get updateAvailableTitle => 'Frissítés elérhető';

  @override
  String get updateAvailableMessage => 'Megjelent a NotIdea új verziója.';

  @override
  String get updateRequiredTitle => 'Frissítés szükséges';

  @override
  String get updateRequiredMessage =>
      'A NotIdea használatának folytatásához frissítenie kell.';

  @override
  String get updateNow => 'Frissítés most';

  @override
  String get updateLater => 'Később';

  @override
  String get updateChangelog => 'Újdonságok';

  @override
  String get openDownloadPage => 'Nyissa meg a letöltési oldalt';

  @override
  String get legal => 'Jogi';

  @override
  String get privacyPolicy => 'Adatvédelmi szabályzat';

  @override
  String get termsOfService => 'Szolgáltatási feltételek';

  @override
  String get openSourceLicenses => 'Nyílt forráskódú licencek';

  @override
  String get dangerZone => 'Veszélyzóna';

  @override
  String get changePassword => 'Jelszó módosítása';

  @override
  String get logoutConfirm => 'Biztosan ki akar jelentkezni?';

  @override
  String get noteColorDefault => 'Alapértelmezett';

  @override
  String get enterYourEmail => 'Adja meg e-mail címét';

  @override
  String get enterYourPassword => 'Adja meg jelszavát';

  @override
  String get emailInvalid => 'Kérjük, adjon meg egy érvényes e-mail címet';

  @override
  String get loginSubtitle =>
      'Isten hozott újra! A folytatáshoz jelentkezzen be';

  @override
  String get signUp => 'Regisztráljon';

  @override
  String get signupSubtitle => 'A kezdéshez hozzon létre egy fiókot';

  @override
  String get signupSuccess => 'A fiók sikeresen létrehozva!';

  @override
  String get enterDisplayName => 'Adja meg megjelenített nevét';

  @override
  String get displayNameTooLong => 'A megjelenített név túl hosszú';

  @override
  String get enterUsername => 'Adja meg felhasználónevét';

  @override
  String get createPassword => 'Hozzon létre egy jelszót';

  @override
  String get confirmYourPassword => 'Erősítse meg jelszavát';

  @override
  String get confirmPasswordRequired => 'Kérjük, erősítse meg jelszavát';

  @override
  String get pleaseAcceptTerms => 'Kérjük, fogadja el a feltételeket';

  @override
  String get iAgreeToThe => 'Egyetértek a';

  @override
  String get resetPasswordEmailSent => 'Jelszó-visszaállítási e-mail elküldve';

  @override
  String get send => 'Elküld';

  @override
  String get and => 'és';

  @override
  String get bold => 'Bátor';

  @override
  String get italic => 'Dőlt';

  @override
  String get heading => 'Cím';

  @override
  String get link => 'Link';

  @override
  String get image => 'Kép';

  @override
  String get code => 'Kód';

  @override
  String get quote => 'Idézet';

  @override
  String get bulletList => 'Bullet List';

  @override
  String get numberedList => 'Számozott lista';

  @override
  String get preview => 'Előnézet';

  @override
  String get startWriting => 'Kezdj el írni...';

  @override
  String get untitled => 'Cím nélkül';

  @override
  String get newNote => 'Új megjegyzés';

  @override
  String get noteColor => 'Megjegyzés Szín';

  @override
  String get visibility => 'Láthatóság';

  @override
  String get tagsHint => 'Adjon hozzá címkéket vesszővel elválasztva';

  @override
  String get unsavedChanges => 'Nem mentett módosítások';

  @override
  String get unsavedChangesMessage =>
      'Nem mentett módosításai vannak. Eldobni őket?';

  @override
  String get discard => 'Eldobni';

  @override
  String get errorLoadingNote => 'Nem sikerült betölteni a jegyzetet';

  @override
  String get noteNotFound => 'Megjegyzés nem található';

  @override
  String get onlyYouCanSee => 'Ezt csak te láthatod';

  @override
  String get friendsCanSee => 'A barátaid láthatják ezt';

  @override
  String get everyoneCanSee => 'Ezt mindenki láthatja';

  @override
  String get profileNotFound => 'A profil nem található';

  @override
  String get errorLoadingProfile => 'Nem sikerült betölteni a profilt';

  @override
  String get deleteAccountConfirmation =>
      'Biztos vagy benne? Ezzel véglegesen törli a fiókját.';

  @override
  String get camera => 'Kamera';

  @override
  String get gallery => 'Galéria';

  @override
  String get avatarUpdated => 'Profilfotó frissítve';

  @override
  String get errorGeneral => 'Valami elromlott. Kérjük, próbálja újra.';

  @override
  String get errorNetwork =>
      'Nincs internet kapcsolat. Kérjük, ellenőrizze a hálózatát.';

  @override
  String get errorTimeout => 'A kérelem lejárt. Kérjük, próbálja újra.';

  @override
  String get errorUnauthorized =>
      'A munkamenet lejárt. Kérjük, jelentkezzen be újra.';

  @override
  String get errorNotFound => 'A kért erőforrás nem található.';

  @override
  String get errorServer => 'Szerver hiba. Kérjük, próbálja újra később.';

  @override
  String get errorImageTooLarge => 'A kép túl nagy. A maximális méret 5 MB.';

  @override
  String get errorUnsupportedFormat => 'Nem támogatott fájlformátum.';

  @override
  String get errorUploadFailed =>
      'A feltöltés sikertelen. Kérjük, próbálja újra.';

  @override
  String get successGeneral => 'A művelet sikeresen befejeződött';

  @override
  String get successSaved => 'Sikeresen mentve';

  @override
  String get successDeleted => 'Sikeresen törölve';

  @override
  String get successUpdated => 'Sikeresen frissítve';

  @override
  String get successCopied => 'Vágólapra másolva';

  @override
  String get timeAgoNow => 'Éppen most';

  @override
  String timeAgoMinutes(int minutes) {
    return '$minutes perce';
  }

  @override
  String timeAgoHours(int hours) {
    return '$hours órája';
  }

  @override
  String timeAgoDays(int days) {
    return '$days napja';
  }

  @override
  String get markdownBold => 'Bátor';

  @override
  String get markdownItalic => 'Dőlt';

  @override
  String get markdownHeading => 'Cím';

  @override
  String get markdownList => 'Lista';

  @override
  String get markdownLink => 'Link';

  @override
  String get markdownImage => 'Kép';

  @override
  String get markdownCode => 'Kód';

  @override
  String get markdownQuote => 'Idézet';

  @override
  String get markdownPreview => 'Előnézet';

  @override
  String get markdownEditor => 'Szerkesztő';

  @override
  String get shareNote => 'Megjegyzés megosztása';

  @override
  String get shareViaLink => 'Megosztás linken keresztül';

  @override
  String get copyLink => 'Link másolása';

  @override
  String get linkCopied => 'Link a vágólapra másolva';

  @override
  String get selectFriends => 'Válassza a Barátok lehetőséget';

  @override
  String get selectGroups => 'Válassza a Csoportok lehetőséget';

  @override
  String get currentShares => 'Aktuális részvények';

  @override
  String get removeShare => 'Megosztás eltávolítása';

  @override
  String get shareWithFriends => 'Ossza meg barátaival';

  @override
  String get shareWithGroups => 'Megosztás a Csoportokkal';

  @override
  String get viewerRole => 'Néző';

  @override
  String get editorRole => 'Szerkesztő';

  @override
  String get add => 'Hozzáadás';

  @override
  String get permissionUpdated => 'Az engedély frissítve';

  @override
  String get editGroup => 'Csoport szerkesztése';

  @override
  String get owner => 'Tulajdonos';

  @override
  String get admin => 'Admin';

  @override
  String get groupNotes => 'Csoportjegyzetek';

  @override
  String get selectMembers => 'Válassza a Tagok lehetőséget';

  @override
  String get groupNameRequired => 'A csoportnév megadása kötelező';

  @override
  String get noMembersYet => 'Még nincsenek tagok';

  @override
  String get confirmRemoveFriend => 'Biztosan eltávolítja ezt az ismerőst?';

  @override
  String get confirmLeaveGroup => 'Biztos, hogy kilép ebből a csoportból?';

  @override
  String get confirmDeleteGroup =>
      'Biztosan törli ezt a csoportot? Ez a művelet nem vonható vissza.';

  @override
  String get alreadyFriends => 'Már barátok';

  @override
  String get requestPending => 'Kérés függőben';

  @override
  String get statusFriend => 'Barát';

  @override
  String get statusPending => 'Függőben levő';

  @override
  String get visibilityFriends => 'Csak barátok';

  @override
  String sharedByUser(String name) {
    return 'Megosztva: $name';
  }

  @override
  String deletedAtDate(String date) {
    return 'Törölve $date';
  }

  @override
  String get notesTab => 'Megjegyzések';

  @override
  String get usersTab => 'Felhasználók';

  @override
  String get publicTab => 'Nyilvános';

  @override
  String get noNotesYet => 'Még nincsenek jegyzetek';

  @override
  String get createFirstNote =>
      'Érintse meg a + gombot az első jegyzet létrehozásához';

  @override
  String get errorLoadingNotes => 'Nem sikerült betölteni a jegyzeteket';

  @override
  String get deleteNoteConfirmation => 'Biztosan törli ezt a jegyzetet?';

  @override
  String get filterBy => 'Szűrés szerint';

  @override
  String get dateModified => 'Módosítás dátuma';

  @override
  String get dateCreated => 'Létrehozás dátuma';

  @override
  String get titleLabel => 'Cím';

  @override
  String get privateNotes => 'Magán';

  @override
  String get publicNotes => 'Nyilvános';

  @override
  String get friendsNotes => 'Barátok';

  @override
  String get clearFilters => 'Szűrők törlése';

  @override
  String get groupSharedNotes => 'Csoportos megosztott jegyzetek';

  @override
  String get completeYourProfile => 'Töltse ki profilját';

  @override
  String get profileSetupSubtitle => 'A kezdéshez adja meg adatait';

  @override
  String get tapToAddPhoto => 'Koppintson profilfotó hozzáadásához';

  @override
  String get getStarted => 'Kezdje el';

  @override
  String get checkEmailToConfirm =>
      'Kérjük, ellenőrizze e-mailjeit a fiók megerősítéséhez, majd jelentkezzen be.';

  @override
  String get usernameTaken => 'Ez a felhasználónév már foglalt';

  @override
  String get checkingUsername => 'Elérhetőség ellenőrzése...';

  @override
  String get resetChanges => 'Változások visszaállítása';

  @override
  String get resetConfirmTitle => 'Visszaállítja a változtatásokat?';

  @override
  String get resetConfirmMessage =>
      'Minden el nem mentett módosítás elvész. Biztos vagy benne?';

  @override
  String get readOnlyPermission => 'Csak olvasható';

  @override
  String get readWritePermission => 'Olvasás és írás';

  @override
  String get selectPermission => 'Válassza az Engedély lehetőséget';

  @override
  String get shareViaSocial => 'Oszd meg a közösségi médián keresztül';

  @override
  String get notePinned => 'Jegyzet rögzítve';

  @override
  String get noteUnpinned => 'Jegyzet feloldva';

  @override
  String get notePermanentlyDeleted => 'Jegyzet véglegesen törölve';

  @override
  String get movedToTrash => 'Áthelyezve a kukába';

  @override
  String get noteInfo => 'Megjegyzés Info';

  @override
  String wordCount(int count) {
    return 'Szószám: $count';
  }

  @override
  String get fontFamilyTitle => 'Betűstílus';

  @override
  String get fontDefault => 'Alapértelmezett (rendszer)';

  @override
  String get fontSerif => 'Serif';

  @override
  String get fontMonospace => 'Monospace';

  @override
  String get fontCursive => 'Kurzív';

  @override
  String get newPassword => 'Új jelszó';

  @override
  String get required => 'Kívánt';

  @override
  String get passwordUppercase =>
      'A jelszónak legalább egy nagybetűt kell tartalmaznia';

  @override
  String get passwordLowercase =>
      'A jelszónak legalább egy kisbetűt kell tartalmaznia';

  @override
  String get passwordDigit =>
      'A jelszónak legalább egy számot kell tartalmaznia';

  @override
  String get imageLabel => 'Kép';

  @override
  String get clearAll => 'Összes törlése';
}
