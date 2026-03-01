// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class AppLocalizationsBg extends AppLocalizations {
  AppLocalizationsBg([String locale = 'bg']) : super(locale);

  @override
  String get appName => 'NotIdea';

  @override
  String get appTagline => 'Вашият творчески спътник за водене на бележки';

  @override
  String get ok => 'добре';

  @override
  String get cancel => 'Отказ';

  @override
  String get save => 'Запазване';

  @override
  String get delete => 'Изтриване';

  @override
  String get edit => 'Редактиране';

  @override
  String get share => 'Споделете';

  @override
  String get search => 'Търсене';

  @override
  String get loading => 'Зареждане...';

  @override
  String get error => 'Грешка';

  @override
  String get retry => 'Опитайте отново';

  @override
  String get done => 'Готово';

  @override
  String get close => 'затвори';

  @override
  String get back => 'Назад';

  @override
  String get next => 'Следваща';

  @override
  String get confirm => 'Потвърдете';

  @override
  String get yes => 'да';

  @override
  String get no => 'не';

  @override
  String get copy => 'копие';

  @override
  String get copied => 'Копирано!';

  @override
  String get selectAll => 'Изберете Всички';

  @override
  String get more => 'повече';

  @override
  String get refresh => 'Опресняване';

  @override
  String get emptyStateGeneral => 'Тук още няма нищо';

  @override
  String get emptyStateDescription => 'Започнете да създавате нещо невероятно';

  @override
  String get login => 'влезте';

  @override
  String get signup => 'Регистрирайте се';

  @override
  String get logout => 'Излезте';

  @override
  String get email => 'Имейл';

  @override
  String get password => 'Парола';

  @override
  String get confirmPassword => 'Потвърдете паролата';

  @override
  String get forgotPassword => 'Забравена парола?';

  @override
  String get resetPassword => 'Нулиране на парола';

  @override
  String get sendResetLink => 'Изпратете връзка за нулиране';

  @override
  String get resetLinkSent =>
      'Връзката за повторно задаване на парола е изпратена на вашия имейл';

  @override
  String get loginWithEmail => 'Влезте с имейл';

  @override
  String get signupWithEmail => 'Регистрирайте се с имейл';

  @override
  String get alreadyHaveAccount => 'Вече имате акаунт?';

  @override
  String get dontHaveAccount => 'Нямате акаунт?';

  @override
  String get welcomeBack => 'Добре дошъл обратно';

  @override
  String get createAccount => 'Създаване на акаунт';

  @override
  String get orContinueWith => 'Или продължете с';

  @override
  String get agreeToTerms =>
      'Като се регистрирате, вие се съгласявате с нашите Общи условия и Политика за поверителност';

  @override
  String get emailRequired => 'Изисква се имейл';

  @override
  String get invalidEmail => 'Моля, въведете валиден имейл';

  @override
  String get passwordRequired => 'Изисква се парола';

  @override
  String get passwordTooShort => 'Паролата трябва да е поне 8 знака';

  @override
  String get passwordNeedsUppercase =>
      'Паролата трябва да съдържа поне една главна буква';

  @override
  String get passwordNeedsLowercase =>
      'Паролата трябва да съдържа поне една малка буква';

  @override
  String get passwordNeedsDigit => 'Паролата трябва да съдържа поне една цифра';

  @override
  String get passwordsDoNotMatch => 'Паролите не съвпадат';

  @override
  String get createNote => 'Създаване на бележка';

  @override
  String get editNote => 'Редактиране на бележка';

  @override
  String get deleteNote => 'Изтриване на бележка';

  @override
  String get noteTitle => 'Заглавие';

  @override
  String get noteContent => 'Започнете да пишете...';

  @override
  String get noteTitleHint => 'Въведете заглавие на бележката';

  @override
  String get noteContentHint => 'Напишете бележката си в маркдаун...';

  @override
  String get noteDeleted => 'Бележката е изтрита';

  @override
  String get noteRestored => 'Бележката е възстановена';

  @override
  String get noteSaved => 'Бележката е запазена';

  @override
  String get noteShared => 'Бележката е споделена';

  @override
  String get deleteNoteConfirm =>
      'Сигурни ли сте, че искате да изтриете тази бележка?';

  @override
  String get deleteNotePermanentConfirm =>
      'Това действие не може да бъде отменено. Изтриване за постоянно?';

  @override
  String get noteVisibility => 'Видимост';

  @override
  String get visibilityPrivate => 'Частно';

  @override
  String get visibilityShared => 'Споделено';

  @override
  String get visibilityPublic => 'Обществен';

  @override
  String get visibilityPrivateDesc => 'Само вие можете да видите тази бележка';

  @override
  String get visibilitySharedDesc => 'Видим за приятели и членове на групата';

  @override
  String get visibilityPublicDesc => 'Видим за всички';

  @override
  String get notes => 'Бележки';

  @override
  String get allNotes => 'Всички бележки';

  @override
  String get myNotes => 'Моите бележки';

  @override
  String get noNotes => 'Все още няма бележки';

  @override
  String get noNotesDesc => 'Докоснете +, за да създадете първата си бележка';

  @override
  String get sortBy => 'Сортирай по';

  @override
  String get sortNewest => 'Първо най-новите';

  @override
  String get sortOldest => 'Първо най-старите';

  @override
  String get sortAlphabetical => 'Азбучен ред';

  @override
  String get sortLastEdited => 'Последна редакция';

  @override
  String get pinNote => 'Pin Бележка';

  @override
  String get unpinNote => 'Откачете бележката';

  @override
  String get duplicateNote => 'Дублирана бележка';

  @override
  String get profile => 'Профил';

  @override
  String get editProfile => 'Редактиране на профил';

  @override
  String get displayName => 'Екранно име';

  @override
  String get username => 'Потребителско име';

  @override
  String get bio => 'био';

  @override
  String get bioHint => 'Разкажете ни за себе си';

  @override
  String get profileUpdated => 'Профилът е актуализиран';

  @override
  String get changeAvatar => 'Смяна на снимка';

  @override
  String get removeAvatar => 'Премахване на снимка';

  @override
  String get usernameRequired => 'Изисква се потребителско име';

  @override
  String get usernameTooShort =>
      'Потребителското име трябва да съдържа поне 3 знака';

  @override
  String get usernameTooLong =>
      'Потребителското име трябва да е най-много 20 знака';

  @override
  String get usernameInvalid =>
      'Потребителското име може да съдържа само букви, цифри и долна черта';

  @override
  String get displayNameRequired => 'Изисква се екранно име';

  @override
  String get friends => 'приятели';

  @override
  String get addFriend => 'Добавяне на приятел';

  @override
  String get removeFriend => 'Премахване на приятел';

  @override
  String get friendRequests => 'Заявки за приятелство';

  @override
  String get pendingRequests => 'Чакащи заявки';

  @override
  String get sentRequests => 'Изпратени заявки';

  @override
  String get acceptRequest => 'Приеми';

  @override
  String get declineRequest => 'Откажи';

  @override
  String get cancelRequest => 'Отказ на заявка';

  @override
  String get sendFriendRequest => 'Изпратете покана за приятелство';

  @override
  String get friendRequestSent => 'Молбата за приятелство е изпратена';

  @override
  String get friendRequestAccepted => 'Молбата за приятелство е приета';

  @override
  String get friendRemoved => 'Приятел премахнат';

  @override
  String get noFriends => 'Все още няма приятели';

  @override
  String get noFriendsDesc => 'Търсете хора и ги добавяйте като приятели';

  @override
  String get noFriendRequests => 'Без заявки за приятелство';

  @override
  String get searchFriends => 'Търсете приятели...';

  @override
  String get searchUsers => 'Търсене на потребители...';

  @override
  String get groups => 'Групи';

  @override
  String get createGroup => 'Създаване на група';

  @override
  String get groupName => 'Име на групата';

  @override
  String get groupDescription => 'Описание';

  @override
  String get members => 'Членове';

  @override
  String get addMembers => 'Добавяне на членове';

  @override
  String get removeMember => 'Премахване на член';

  @override
  String get leaveGroup => 'Напускане на групата';

  @override
  String get deleteGroup => 'Изтриване на група';

  @override
  String get groupCreated => 'Групата е създадена';

  @override
  String get groupUpdated => 'Групата е актуализирана';

  @override
  String get groupDeleted => 'Групата е изтрита';

  @override
  String get noGroups => 'Все още няма групи';

  @override
  String get noGroupsDesc => 'Създайте група, за да споделяте бележки с други';

  @override
  String memberCount(int count) {
    return '$count членове';
  }

  @override
  String get explore => 'Разгледайте';

  @override
  String get exploreDesc => 'Открийте публични бележки от общността';

  @override
  String get trending => 'Тенденция';

  @override
  String get recent => 'Скорошни';

  @override
  String get noExploreResults => 'Все още няма публични бележки';

  @override
  String get noExploreResultsDesc =>
      'Бъдете първият, който ще сподели бележка с общността';

  @override
  String get favorites => 'Любими';

  @override
  String get addToFavorites => 'Добавяне към любими';

  @override
  String get removeFromFavorites => 'Премахване от любими';

  @override
  String get addedToFavorites => 'Добавен към любими';

  @override
  String get removedFromFavorites => 'Премахнато от любимите';

  @override
  String get noFavorites => 'Все още няма любими';

  @override
  String get noFavoritesDesc =>
      'Докоснете иконата на сърце върху бележка, за да я добавите тук';

  @override
  String get trash => 'Кошче';

  @override
  String get restoreNote => 'Възстановяване';

  @override
  String get deletePermanently => 'Изтриване за постоянно';

  @override
  String get emptyTrash => 'Изпразване на кошчето';

  @override
  String get emptyTrashConfirm =>
      'Изтриване на всички бележки в кошчето за постоянно?';

  @override
  String get trashEmpty => 'Кошчето е празно';

  @override
  String get trashEmptyDesc => 'Изтритите бележки ще се появят тук';

  @override
  String get trashAutoDeleteInfo =>
      'Бележките в кошчето ще бъдат изтрити за постоянно след 30 дни';

  @override
  String get sharedNotes => 'Споделени бележки';

  @override
  String get sharedWithMe => 'Споделено с мен';

  @override
  String get sharedByMe => 'Споделено от мен';

  @override
  String get noSharedNotes => 'Няма споделени бележки';

  @override
  String get noSharedNotesDesc =>
      'Споделените с вас бележки ще се показват тук';

  @override
  String get searchHint => 'Търсене в бележки, хора, групи...';

  @override
  String get searchNotes => 'Бележки за търсене';

  @override
  String get searchResults => 'Резултати от търсенето';

  @override
  String get noSearchResults => 'Няма намерени резултати';

  @override
  String get noSearchResultsDesc => 'Опитайте различни ключови думи';

  @override
  String get recentSearches => 'Последни търсения';

  @override
  String get clearSearchHistory => 'Изчистване на историята на търсенията';

  @override
  String get settings => 'Настройки';

  @override
  String get appearance => 'Външен вид';

  @override
  String get theme => 'Тема';

  @override
  String get themeLight => 'светлина';

  @override
  String get themeDark => 'Тъмно';

  @override
  String get themeSystem => 'система';

  @override
  String get language => 'език';

  @override
  String get languageEnglish => 'английски';

  @override
  String get languageTurkish => 'турски';

  @override
  String get notifications => 'Известия';

  @override
  String get account => 'акаунт';

  @override
  String get deleteAccount => 'Изтриване на акаунт';

  @override
  String get deleteAccountConfirm =>
      'Това ще изтрие за постоянно вашия акаунт и всички данни. Това действие не може да бъде отменено.';

  @override
  String get aboutApp => 'Относно NotIdea';

  @override
  String get version => 'Версия';

  @override
  String get buildNumber => 'Изграждане';

  @override
  String get legal => 'Законни';

  @override
  String get privacyPolicy => 'Политика за поверителност';

  @override
  String get termsOfService => 'Условия за ползване';

  @override
  String get openSourceLicenses => 'Лицензи с отворен код';

  @override
  String get dangerZone => 'Опасна зона';

  @override
  String get changePassword => 'Промяна на паролата';

  @override
  String get logoutConfirm => 'Сигурни ли сте, че искате да излезете?';

  @override
  String get noteColorDefault => 'По подразбиране';

  @override
  String get enterYourEmail => 'Въведете своя имейл';

  @override
  String get enterYourPassword => 'Въведете вашата парола';

  @override
  String get emailInvalid => 'Моля, въведете валиден имейл адрес';

  @override
  String get loginSubtitle => 'Добре дошли отново! Влезте, за да продължите';

  @override
  String get signUp => 'Регистрирайте се';

  @override
  String get signupSubtitle => 'Създайте акаунт, за да започнете';

  @override
  String get signupSuccess => 'Акаунтът е създаден успешно!';

  @override
  String get enterDisplayName => 'Въведете вашето екранно име';

  @override
  String get displayNameTooLong => 'Показваното име е твърде дълго';

  @override
  String get enterUsername => 'Въведете вашето потребителско име';

  @override
  String get createPassword => 'Създайте парола';

  @override
  String get confirmYourPassword => 'Потвърдете паролата си';

  @override
  String get confirmPasswordRequired => 'Моля, потвърдете паролата си';

  @override
  String get pleaseAcceptTerms => 'Моля, приемете правилата и условията';

  @override
  String get iAgreeToThe => 'Съгласен съм с';

  @override
  String get resetPasswordEmailSent => 'Изпратен имейл за нулиране на парола';

  @override
  String get send => 'Изпратете';

  @override
  String get and => 'и';

  @override
  String get bold => 'Удебелен';

  @override
  String get italic => 'Курсив';

  @override
  String get heading => 'Заглавие';

  @override
  String get link => 'Връзка';

  @override
  String get image => 'Изображение';

  @override
  String get code => 'Код';

  @override
  String get quote => 'цитат';

  @override
  String get bulletList => 'Списък с топчета';

  @override
  String get numberedList => 'Номериран списък';

  @override
  String get preview => 'Преглед';

  @override
  String get startWriting => 'Започнете да пишете...';

  @override
  String get untitled => 'Без заглавие';

  @override
  String get newNote => 'Нова бележка';

  @override
  String get noteColor => 'Забележка Цвят';

  @override
  String get visibility => 'Видимост';

  @override
  String get tagsHint => 'Добавете тагове, разделени със запетаи';

  @override
  String get unsavedChanges => 'Незапазени промени';

  @override
  String get unsavedChangesMessage =>
      'Имате незапазени промени. Да ги изхвърля?';

  @override
  String get discard => 'Изхвърлете';

  @override
  String get errorLoadingNote => 'Бележката не можа да се зареди';

  @override
  String get noteNotFound => 'Бележката не е намерена';

  @override
  String get onlyYouCanSee => 'Само вие можете да видите това';

  @override
  String get friendsCanSee => 'Вашите приятели могат да видят това';

  @override
  String get everyoneCanSee => 'Всеки може да види това';

  @override
  String get profileNotFound => 'Профилът не е намерен';

  @override
  String get errorLoadingProfile => 'Профилът не можа да се зареди';

  @override
  String get deleteAccountConfirmation =>
      'сигурен ли си Това ще изтрие вашия акаунт за постоянно.';

  @override
  String get camera => 'Камера';

  @override
  String get gallery => 'Галерия';

  @override
  String get avatarUpdated => 'Снимката на профила е актуализирана';

  @override
  String get errorGeneral => 'Нещо се обърка. Моля, опитайте отново.';

  @override
  String get errorNetwork =>
      'Няма интернет връзка. Моля, проверете вашата мрежа.';

  @override
  String get errorTimeout =>
      'Времето за изчакване на заявката изтече. Моля, опитайте отново.';

  @override
  String get errorUnauthorized => 'Сесията е изтекла. Моля, влезте отново.';

  @override
  String get errorNotFound => 'Исканият ресурс не беше намерен.';

  @override
  String get errorServer => 'Грешка в сървъра. Моля, опитайте отново по-късно.';

  @override
  String get errorImageTooLarge =>
      'Изображението е твърде голямо. Максималният размер е 5 MB.';

  @override
  String get errorUnsupportedFormat => 'Неподдържан файлов формат.';

  @override
  String get errorUploadFailed =>
      'Качването не бе успешно. Моля, опитайте отново.';

  @override
  String get successGeneral => 'Операцията приключи успешно';

  @override
  String get successSaved => 'Запазено успешно';

  @override
  String get successDeleted => 'Изтрито успешно';

  @override
  String get successUpdated => 'Актуализиран успешно';

  @override
  String get successCopied => 'Копирано в клипборда';

  @override
  String get timeAgoNow => 'Току-що';

  @override
  String timeAgoMinutes(int minutes) {
    return 'Преди $minutes мин';
  }

  @override
  String timeAgoHours(int hours) {
    return 'преди $hours часа';
  }

  @override
  String timeAgoDays(int days) {
    return 'преди $days дни';
  }

  @override
  String get markdownBold => 'Удебелен';

  @override
  String get markdownItalic => 'Курсив';

  @override
  String get markdownHeading => 'Заглавие';

  @override
  String get markdownList => 'списък';

  @override
  String get markdownLink => 'Връзка';

  @override
  String get markdownImage => 'Изображение';

  @override
  String get markdownCode => 'Код';

  @override
  String get markdownQuote => 'цитат';

  @override
  String get markdownPreview => 'Преглед';

  @override
  String get markdownEditor => 'редактор';

  @override
  String get shareNote => 'Споделяне на бележка';

  @override
  String get shareViaLink => 'Споделете чрез връзка';

  @override
  String get copyLink => 'Копиране на връзката';

  @override
  String get linkCopied => 'Връзката е копирана в клипборда';

  @override
  String get selectFriends => 'Изберете Приятели';

  @override
  String get selectGroups => 'Изберете Групи';

  @override
  String get currentShares => 'Текущи акции';

  @override
  String get removeShare => 'Премахване на споделяне';

  @override
  String get shareWithFriends => 'Споделете с приятели';

  @override
  String get shareWithGroups => 'Споделете с Групи';

  @override
  String get viewerRole => 'зрител';

  @override
  String get editorRole => 'редактор';

  @override
  String get add => 'Добавете';

  @override
  String get permissionUpdated => 'Разрешението е актуализирано';

  @override
  String get editGroup => 'Редактиране на група';

  @override
  String get owner => 'Собственик';

  @override
  String get admin => 'Админ';

  @override
  String get groupNotes => 'Групови бележки';

  @override
  String get selectMembers => 'Изберете Членове';

  @override
  String get groupNameRequired => 'Името на групата е задължително';

  @override
  String get noMembersYet => 'Все още няма членове';

  @override
  String get confirmRemoveFriend =>
      'Сигурни ли сте, че искате да премахнете този приятел?';

  @override
  String get confirmLeaveGroup =>
      'Сигурни ли сте, че искате да напуснете тази група?';

  @override
  String get confirmDeleteGroup =>
      'Сигурни ли сте, че искате да изтриете тази група? Това действие не може да бъде отменено.';

  @override
  String get alreadyFriends => 'Вече приятели';

  @override
  String get requestPending => 'Изчакваща заявка';

  @override
  String get statusFriend => 'приятел';

  @override
  String get statusPending => 'В очакване';

  @override
  String get visibilityFriends => 'Само приятели';

  @override
  String sharedByUser(String name) {
    return 'Споделено от $name';
  }

  @override
  String deletedAtDate(String date) {
    return 'Изтрит $date';
  }

  @override
  String get notesTab => 'Бележки';

  @override
  String get usersTab => 'Потребители';

  @override
  String get publicTab => 'Обществен';

  @override
  String get noNotesYet => 'Все още няма бележки';

  @override
  String get createFirstNote =>
      'Докоснете +, за да създадете първата си бележка';

  @override
  String get errorLoadingNotes => 'Бележките не можаха да се заредят';

  @override
  String get deleteNoteConfirmation =>
      'Сигурни ли сте, че искате да изтриете тази бележка?';

  @override
  String get filterBy => 'Филтриране по';

  @override
  String get dateModified => 'Дата на промяна';

  @override
  String get dateCreated => 'Дата на създаване';

  @override
  String get titleLabel => 'Заглавие';

  @override
  String get privateNotes => 'Частно';

  @override
  String get publicNotes => 'Обществен';

  @override
  String get friendsNotes => 'приятели';

  @override
  String get clearFilters => 'Изчистване на филтри';

  @override
  String get groupSharedNotes => 'Групови споделени бележки';

  @override
  String get completeYourProfile => 'Попълнете своя профил';

  @override
  String get profileSetupSubtitle => 'Добавете данните си, за да започнете';

  @override
  String get tapToAddPhoto => 'Докоснете, за да добавите профилна снимка';

  @override
  String get getStarted => 'Започнете';

  @override
  String get checkEmailToConfirm =>
      'Моля, проверете имейла си, за да потвърдите акаунта си, след което влезте.';

  @override
  String get usernameTaken => 'Това потребителско име вече е заето';

  @override
  String get checkingUsername => 'Проверява се наличността...';

  @override
  String get resetChanges => 'Нулиране на промените';

  @override
  String get resetConfirmTitle => 'Нулиране на промените?';

  @override
  String get resetConfirmMessage =>
      'Всички незапазени промени ще бъдат загубени. сигурен ли си';

  @override
  String get readOnlyPermission => 'Само за четене';

  @override
  String get readWritePermission => 'Четене и писане';

  @override
  String get selectPermission => 'Изберете Разрешение';

  @override
  String get shareViaSocial => 'Споделете чрез социални медии';

  @override
  String get notePinned => 'Бележката е фиксирана';

  @override
  String get noteUnpinned => 'Бележката е освободена';

  @override
  String get notePermanentlyDeleted => 'Бележката е изтрита за постоянно';

  @override
  String get movedToTrash => 'Преместено в кошчето';

  @override
  String get noteInfo => 'Забележка Информация';

  @override
  String wordCount(int count) {
    return 'Брой думи: $count';
  }

  @override
  String get fontFamilyTitle => 'Стил на шрифта';

  @override
  String get fontDefault => 'По подразбиране (система)';

  @override
  String get fontSerif => 'Serif';

  @override
  String get fontMonospace => 'Монопространство';

  @override
  String get fontCursive => 'Курсив';

  @override
  String get newPassword => 'Нова парола';

  @override
  String get required => 'Задължително';

  @override
  String get passwordUppercase =>
      'Паролата трябва да съдържа поне една главна буква';

  @override
  String get passwordLowercase =>
      'Паролата трябва да съдържа поне една малка буква';

  @override
  String get passwordDigit => 'Паролата трябва да съдържа поне едно число';

  @override
  String get imageLabel => 'Изображение';

  @override
  String get clearAll => 'Изчистване на всички';
}
