// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appName => 'NotIdea';

  @override
  String get appTagline => 'Ваш творчий компаньйон у нотатках';

  @override
  String get ok => 'добре';

  @override
  String get cancel => 'Скасувати';

  @override
  String get save => 'зберегти';

  @override
  String get delete => 'Видалити';

  @override
  String get edit => 'Редагувати';

  @override
  String get share => 'Поділіться';

  @override
  String get search => 'Пошук';

  @override
  String get loading => 'Завантаження...';

  @override
  String get error => 'Помилка';

  @override
  String get retry => 'Повторіть спробу';

  @override
  String get done => 'Готово';

  @override
  String get close => 'Закрити';

  @override
  String get back => 'Назад';

  @override
  String get next => 'Далі';

  @override
  String get confirm => 'Підтвердити';

  @override
  String get yes => 'так';

  @override
  String get no => 'немає';

  @override
  String get copy => 'Копія';

  @override
  String get copied => 'Скопійовано!';

  @override
  String get selectAll => 'Виберіть усі';

  @override
  String get more => 'більше';

  @override
  String get refresh => 'Оновити';

  @override
  String get emptyStateGeneral => 'Тут ще нічого немає';

  @override
  String get emptyStateDescription => 'Почніть створювати щось дивовижне';

  @override
  String get login => 'Увійти';

  @override
  String get signup => 'Зареєструватися';

  @override
  String get logout => 'Вийти';

  @override
  String get email => 'Електронна пошта';

  @override
  String get password => 'Пароль';

  @override
  String get confirmPassword => 'Підтвердьте пароль';

  @override
  String get forgotPassword => 'Забули пароль?';

  @override
  String get resetPassword => 'Скинути пароль';

  @override
  String get sendResetLink => 'Надіслати посилання для скидання';

  @override
  String get resetLinkSent =>
      'Посилання для зміни пароля надіслано на вашу електронну адресу';

  @override
  String get loginWithEmail => 'Увійдіть за допомогою електронної пошти';

  @override
  String get signupWithEmail =>
      'Зареєструватися за допомогою електронної пошти';

  @override
  String get alreadyHaveAccount => 'Вже маєте акаунт?';

  @override
  String get dontHaveAccount => 'Немає облікового запису?';

  @override
  String get welcomeBack => 'Ласкаво просимо назад';

  @override
  String get createAccount => 'Створити акаунт';

  @override
  String get orContinueWith => 'Або продовжити';

  @override
  String get agreeToTerms =>
      'Реєструючись, ви погоджуєтеся з нашими Умовами обслуговування та Політикою конфіденційності';

  @override
  String get emailRequired => 'Необхідно вказати адресу електронної пошти';

  @override
  String get invalidEmail => 'Введіть дійсну адресу електронної пошти';

  @override
  String get passwordRequired => 'Необхідно ввести пароль';

  @override
  String get passwordTooShort => 'Пароль має бути не менше 8 символів';

  @override
  String get passwordNeedsUppercase =>
      'Пароль має містити принаймні одну велику літеру';

  @override
  String get passwordNeedsLowercase =>
      'Пароль має містити принаймні одну малу літеру';

  @override
  String get passwordNeedsDigit => 'Пароль має містити хоча б одну цифру';

  @override
  String get passwordsDoNotMatch => 'Паролі не збігаються';

  @override
  String get createNote => 'Створити примітку';

  @override
  String get editNote => 'Редагувати примітку';

  @override
  String get deleteNote => 'Видалити примітку';

  @override
  String get noteTitle => 'Назва';

  @override
  String get noteContent => 'Почніть писати...';

  @override
  String get noteTitleHint => 'Введіть назву нотатки';

  @override
  String get noteContentHint => 'Напишіть свою нотатку в розмітці...';

  @override
  String get noteDeleted => 'Примітку видалено';

  @override
  String get noteRestored => 'Примітку відновлено';

  @override
  String get noteSaved => 'Нотатку збережено';

  @override
  String get noteShared => 'Примітка поділена';

  @override
  String get deleteNoteConfirm => 'Ви впевнені, що хочете видалити цю нотатку?';

  @override
  String get deleteNotePermanentConfirm =>
      'Цю дію не можна скасувати. Видалити остаточно?';

  @override
  String get noteVisibility => 'Видимість';

  @override
  String get visibilityPrivate => 'Приватний';

  @override
  String get visibilityShared => 'Спільний доступ';

  @override
  String get visibilityPublic => 'Громадський';

  @override
  String get visibilityPrivateDesc => 'Тільки ви можете бачити цю нотатку';

  @override
  String get visibilitySharedDesc => 'Видно друзям і учасникам групи';

  @override
  String get visibilityPublicDesc => 'Видно для всіх';

  @override
  String get notes => 'Примітки';

  @override
  String get allNotes => 'Усі нотатки';

  @override
  String get myNotes => 'Мої нотатки';

  @override
  String get noNotes => 'Приміток ще немає';

  @override
  String get noNotesDesc => 'Торкніться +, щоб створити свою першу нотатку';

  @override
  String get sortBy => 'Сортувати за';

  @override
  String get sortNewest => 'Спочатку найновіші';

  @override
  String get sortOldest => 'Спочатку найстаріші';

  @override
  String get sortAlphabetical => 'Алфавітний';

  @override
  String get sortLastEdited => 'Останнє редагування';

  @override
  String get pinNote => 'Закріпити примітку';

  @override
  String get unpinNote => 'Відкріпити примітку';

  @override
  String get duplicateNote => 'Дублікат примітки';

  @override
  String get profile => 'Профіль';

  @override
  String get editProfile => 'Редагувати профіль';

  @override
  String get displayName => 'Відображуване ім\'я';

  @override
  String get username => 'Ім\'я користувача';

  @override
  String get bio => 'біографія';

  @override
  String get bioHint => 'Розкажіть нам про себе';

  @override
  String get profileUpdated => 'Профіль оновлено';

  @override
  String get changeAvatar => 'Змінити фото';

  @override
  String get removeAvatar => 'Видалити фото';

  @override
  String get usernameRequired => 'Потрібно ввести ім\'я користувача';

  @override
  String get usernameTooShort =>
      'Ім\'я користувача має бути не менше 3 символів';

  @override
  String get usernameTooLong =>
      'Ім\'я користувача має містити не більше 20 символів';

  @override
  String get usernameInvalid =>
      'Ім\'я користувача може містити лише літери, цифри та підкреслення';

  @override
  String get displayNameRequired => 'Введіть відображуване ім’я';

  @override
  String get friends => 'друзі';

  @override
  String get addFriend => 'Додати друга';

  @override
  String get removeFriend => 'Видалити друга';

  @override
  String get friendRequests => 'Запити в друзі';

  @override
  String get pendingRequests => 'Запити, що очікують на розгляд';

  @override
  String get sentRequests => 'Відправлені запити';

  @override
  String get acceptRequest => 'прийняти';

  @override
  String get declineRequest => 'відхилити';

  @override
  String get cancelRequest => 'Скасувати запит';

  @override
  String get sendFriendRequest => 'Надіслати запит у друзі';

  @override
  String get friendRequestSent => 'Запит на дружбу надіслано';

  @override
  String get friendRequestAccepted => 'Запит на дружбу прийнято';

  @override
  String get friendRemoved => 'Друг видалений';

  @override
  String get noFriends => 'Друзів ще немає';

  @override
  String get noFriendsDesc => 'Шукайте людей і додавайте їх у друзі';

  @override
  String get noFriendRequests => 'Жодних запитів у друзі';

  @override
  String get searchFriends => 'Пошук друзів...';

  @override
  String get searchUsers => 'Пошук користувачів...';

  @override
  String get groups => 'Групи';

  @override
  String get createGroup => 'Створити групу';

  @override
  String get groupName => 'Назва групи';

  @override
  String get groupDescription => 'опис';

  @override
  String get members => 'Члени';

  @override
  String get addMembers => 'Додати учасників';

  @override
  String get removeMember => 'Видалити учасника';

  @override
  String get leaveGroup => 'Вийти з групи';

  @override
  String get deleteGroup => 'Видалити групу';

  @override
  String get groupCreated => 'Групу створено';

  @override
  String get groupUpdated => 'Групу оновлено';

  @override
  String get groupDeleted => 'Групу видалено';

  @override
  String get noGroups => 'Груп ще немає';

  @override
  String get noGroupsDesc =>
      'Створіть групу, щоб поділитися нотатками з іншими';

  @override
  String memberCount(int count) {
    return '$count учасників';
  }

  @override
  String get explore => 'Досліджуйте';

  @override
  String get exploreDesc => 'Відкрийте для себе публічні нотатки спільноти';

  @override
  String get trending => 'В тренді';

  @override
  String get recent => 'Останні';

  @override
  String get noExploreResults => 'Публічних нотаток ще немає';

  @override
  String get noExploreResultsDesc =>
      'Будьте першим, хто поділіться заміткою зі спільнотою';

  @override
  String get favorites => 'Вибране';

  @override
  String get addToFavorites => 'Додати в обране';

  @override
  String get removeFromFavorites => 'Видалити з вибраного';

  @override
  String get addedToFavorites => 'Додано до обраних';

  @override
  String get removedFromFavorites => 'Видалено з вибраного';

  @override
  String get noFavorites => 'Вибраних ще немає';

  @override
  String get noFavoritesDesc =>
      'Торкніться значка серця на нотатці, щоб додати її сюди';

  @override
  String get trash => 'сміття';

  @override
  String get restoreNote => 'Відновити';

  @override
  String get deletePermanently => 'Видалити назавжди';

  @override
  String get emptyTrash => 'Очистити кошик';

  @override
  String get emptyTrashConfirm => 'Видалити всі нотатки в кошик назавжди?';

  @override
  String get trashEmpty => 'Кошик порожній';

  @override
  String get trashEmptyDesc => 'Видалені нотатки з’являться тут';

  @override
  String get trashAutoDeleteInfo =>
      'Нотатки в кошику буде остаточно видалено через 30 днів';

  @override
  String get sharedNotes => 'Спільні нотатки';

  @override
  String get sharedWithMe => 'Поділився зі мною';

  @override
  String get sharedByMe => 'Поділився мною';

  @override
  String get noSharedNotes => 'Немає спільних нотаток';

  @override
  String get noSharedNotesDesc => 'Тут з’являться нотатки, якими ви поділилися';

  @override
  String get searchHint => 'Пошук нотаток, людей, груп...';

  @override
  String get searchNotes => 'Пошукові примітки';

  @override
  String get searchResults => 'Результати пошуку';

  @override
  String get noSearchResults => 'Результатів не знайдено';

  @override
  String get noSearchResultsDesc => 'Спробуйте різні ключові слова';

  @override
  String get recentSearches => 'Останні пошуки';

  @override
  String get clearSearchHistory => 'Очистити історію пошуку';

  @override
  String get settings => 'Налаштування';

  @override
  String get appearance => 'Зовнішній вигляд';

  @override
  String get theme => 'Тема';

  @override
  String get themeLight => 'світло';

  @override
  String get themeDark => 'Темний';

  @override
  String get themeSystem => 'система';

  @override
  String get language => 'Мова';

  @override
  String get languageEnglish => 'англійська';

  @override
  String get languageTurkish => 'турецька';

  @override
  String get notifications => 'Сповіщення';

  @override
  String get account => 'Обліковий запис';

  @override
  String get deleteAccount => 'Видалити акаунт';

  @override
  String get deleteAccountConfirm =>
      'Це призведе до остаточного видалення вашого облікового запису та всіх даних. Цю дію не можна скасувати.';

  @override
  String get aboutApp => 'Про NotIdea';

  @override
  String get version => 'Версія';

  @override
  String get buildNumber => 'Будувати';

  @override
  String get updateAvailableTitle => 'Оновлення доступне';

  @override
  String get updateAvailableMessage => 'Доступна нова версія NotIdea.';

  @override
  String get updateRequiredTitle => 'Потрібне оновлення';

  @override
  String get updateRequiredMessage =>
      'Ви повинні оновити, щоб продовжити використання NotIdea.';

  @override
  String get updateNow => 'Оновити зараз';

  @override
  String get updateLater => 'Пізніше';

  @override
  String get updateChangelog => 'Що нового';

  @override
  String get openDownloadPage => 'Відкрити сторінку завантаження';

  @override
  String get legal => 'юридичний';

  @override
  String get privacyPolicy => 'Політика конфіденційності';

  @override
  String get termsOfService => 'Умови обслуговування';

  @override
  String get openSourceLicenses => 'Ліцензії з відкритим кодом';

  @override
  String get dangerZone => 'НЕБЕЗПЕЧНА ЗОНА';

  @override
  String get changePassword => 'Змінити пароль';

  @override
  String get logoutConfirm => 'Ви впевнені, що бажаєте вийти?';

  @override
  String get noteColorDefault => 'За замовчуванням';

  @override
  String get enterYourEmail => 'Введіть адресу електронної пошти';

  @override
  String get enterYourPassword => 'Введіть свій пароль';

  @override
  String get emailInvalid => 'Введіть дійсну електронну адресу';

  @override
  String get loginSubtitle => 'Ласкаво просимо назад! Увійдіть, щоб продовжити';

  @override
  String get signUp => 'Зареєструватися';

  @override
  String get signupSubtitle => 'Створіть обліковий запис, щоб почати';

  @override
  String get signupSuccess => 'Обліковий запис успішно створено!';

  @override
  String get enterDisplayName => 'Введіть своє відображуване ім\'я';

  @override
  String get displayNameTooLong => 'Відображуване ім\'я задовге';

  @override
  String get enterUsername => 'Введіть своє ім\'я користувача';

  @override
  String get createPassword => 'Створіть пароль';

  @override
  String get confirmYourPassword => 'Підтвердьте свій пароль';

  @override
  String get confirmPasswordRequired => 'Будь ласка, підтвердьте свій пароль';

  @override
  String get pleaseAcceptTerms => 'Будь ласка, прийміть положення та умови';

  @override
  String get iAgreeToThe => 'Я згоден на';

  @override
  String get resetPasswordEmailSent =>
      'Електронний лист для зміни пароля надіслано';

  @override
  String get send => 'Надіслати';

  @override
  String get and => 'і';

  @override
  String get bold => 'жирний';

  @override
  String get italic => 'Курсив';

  @override
  String get heading => 'Заголовок';

  @override
  String get link => 'Посилання';

  @override
  String get image => 'Зображення';

  @override
  String get code => 'Код';

  @override
  String get quote => 'Цитата';

  @override
  String get bulletList => 'Список маркерів';

  @override
  String get numberedList => 'Нумерований список';

  @override
  String get preview => 'Попередній перегляд';

  @override
  String get startWriting => 'Почніть писати...';

  @override
  String get untitled => 'Без назви';

  @override
  String get newNote => 'Нова примітка';

  @override
  String get noteColor => 'Колір примітки';

  @override
  String get visibility => 'Видимість';

  @override
  String get tagsHint => 'Додайте теги, розділені комами';

  @override
  String get unsavedChanges => 'Незбережені зміни';

  @override
  String get unsavedChangesMessage =>
      'У вас є незбережені зміни. Відкинути їх?';

  @override
  String get discard => 'Відкинути';

  @override
  String get errorLoadingNote => 'Не вдалося завантажити нотатку';

  @override
  String get noteNotFound => 'Примітка не знайдена';

  @override
  String get onlyYouCanSee => 'Тільки ви можете бачити це';

  @override
  String get friendsCanSee => 'Ваші друзі можуть це побачити';

  @override
  String get everyoneCanSee => 'Це може побачити кожен';

  @override
  String get profileNotFound => 'Профіль не знайдено';

  @override
  String get errorLoadingProfile => 'Не вдалося завантажити профіль';

  @override
  String get deleteAccountConfirmation =>
      'Ви впевнені? Це призведе до остаточного видалення вашого облікового запису.';

  @override
  String get camera => 'Камера';

  @override
  String get gallery => 'Галерея';

  @override
  String get avatarUpdated => 'Фото профілю оновлено';

  @override
  String get errorGeneral => 'Щось пішло не так. Спробуйте ще раз.';

  @override
  String get errorNetwork =>
      'Немає підключення до Інтернету. Перевірте свою мережу.';

  @override
  String get errorTimeout => 'Час очікування запиту минув. Спробуйте ще раз.';

  @override
  String get errorUnauthorized =>
      'Сеанс закінчився. Будь ласка, увійдіть знову.';

  @override
  String get errorNotFound => 'Потрібний ресурс не знайдено.';

  @override
  String get errorServer => 'Помилка сервера. Спробуйте пізніше.';

  @override
  String get errorImageTooLarge =>
      'Зображення завелике. Максимальний розмір – 5 Мб.';

  @override
  String get errorUnsupportedFormat => 'Непідтримуваний формат файлу.';

  @override
  String get errorUploadFailed => 'Помилка завантаження. Спробуйте ще раз.';

  @override
  String get successGeneral => 'Операцію успішно завершено';

  @override
  String get successSaved => 'Успішно збережено';

  @override
  String get successDeleted => 'Успішно видалено';

  @override
  String get successUpdated => 'Оновлено успішно';

  @override
  String get successCopied => 'Скопійовано в буфер обміну';

  @override
  String get timeAgoNow => 'Просто зараз';

  @override
  String timeAgoMinutes(int minutes) {
    return '$minutes хв тому';
  }

  @override
  String timeAgoHours(int hours) {
    return '$hours годин тому';
  }

  @override
  String timeAgoDays(int days) {
    return '$days днів тому';
  }

  @override
  String get markdownBold => 'жирний';

  @override
  String get markdownItalic => 'Курсив';

  @override
  String get markdownHeading => 'Заголовок';

  @override
  String get markdownList => 'Список';

  @override
  String get markdownLink => 'Посилання';

  @override
  String get markdownImage => 'Зображення';

  @override
  String get markdownCode => 'Код';

  @override
  String get markdownQuote => 'Цитата';

  @override
  String get markdownPreview => 'Попередній перегляд';

  @override
  String get markdownEditor => 'редактор';

  @override
  String get shareNote => 'Поділитися приміткою';

  @override
  String get shareViaLink => 'Поділіться через посилання';

  @override
  String get copyLink => 'Копіювати посилання';

  @override
  String get linkCopied => 'Посилання скопійовано в буфер обміну';

  @override
  String get selectFriends => 'Виберіть Друзі';

  @override
  String get selectGroups => 'Виберіть Групи';

  @override
  String get currentShares => 'Поточні акції';

  @override
  String get removeShare => 'Видалити спільний доступ';

  @override
  String get shareWithFriends => 'Поділіться з друзями';

  @override
  String get shareWithGroups => 'Поділіться з Групами';

  @override
  String get viewerRole => 'Переглядач';

  @override
  String get editorRole => 'редактор';

  @override
  String get add => 'додати';

  @override
  String get permissionUpdated => 'Дозвіл оновлено';

  @override
  String get editGroup => 'Редагувати групу';

  @override
  String get owner => 'Власник';

  @override
  String get admin => 'адмін';

  @override
  String get groupNotes => 'Нотатки групи';

  @override
  String get selectMembers => 'Виберіть Учасники';

  @override
  String get groupNameRequired => 'Потрібно вказати назву групи';

  @override
  String get noMembersYet => 'Ще немає учасників';

  @override
  String get confirmRemoveFriend =>
      'Ви впевнені, що хочете видалити цього друга?';

  @override
  String get confirmLeaveGroup => 'Ви впевнені, що бажаєте залишити цю групу?';

  @override
  String get confirmDeleteGroup =>
      'Ви впевнені, що хочете видалити цю групу? Цю дію не можна скасувати.';

  @override
  String get alreadyFriends => 'Вже друзі';

  @override
  String get requestPending => 'Запит очікує на розгляд';

  @override
  String get statusFriend => 'Друг';

  @override
  String get statusPending => 'В очікуванні';

  @override
  String get visibilityFriends => 'Тільки друзі';

  @override
  String sharedByUser(String name) {
    return 'Поділився $name';
  }

  @override
  String deletedAtDate(String date) {
    return 'Видалено $date';
  }

  @override
  String get notesTab => 'Примітки';

  @override
  String get usersTab => 'Користувачі';

  @override
  String get publicTab => 'Громадський';

  @override
  String get noNotesYet => 'Приміток ще немає';

  @override
  String get createFirstNote => 'Торкніться +, щоб створити свою першу нотатку';

  @override
  String get errorLoadingNotes => 'Не вдалося завантажити нотатки';

  @override
  String get deleteNoteConfirmation =>
      'Ви впевнені, що хочете видалити цю нотатку?';

  @override
  String get filterBy => 'Фільтрувати за';

  @override
  String get dateModified => 'Дата зміни';

  @override
  String get dateCreated => 'Дата створення';

  @override
  String get titleLabel => 'Назва';

  @override
  String get privateNotes => 'Приватний';

  @override
  String get publicNotes => 'Громадський';

  @override
  String get friendsNotes => 'друзі';

  @override
  String get clearFilters => 'Очистити фільтри';

  @override
  String get groupSharedNotes => 'Спільні нотатки групи';

  @override
  String get completeYourProfile => 'Заповніть свій профіль';

  @override
  String get profileSetupSubtitle => 'Додайте свої дані, щоб почати';

  @override
  String get tapToAddPhoto => 'Торкніться, щоб додати фотографію профілю';

  @override
  String get getStarted => 'Почніть роботу';

  @override
  String get checkEmailToConfirm =>
      'Перевірте свою електронну пошту, щоб підтвердити обліковий запис, а потім увійдіть.';

  @override
  String get usernameTaken => 'Це ім\'я користувача вже зайняте';

  @override
  String get checkingUsername => 'Перевірка наявності...';

  @override
  String get resetChanges => 'Скинути зміни';

  @override
  String get resetConfirmTitle => 'Скинути зміни?';

  @override
  String get resetConfirmMessage =>
      'Усі незбережені зміни буде втрачено. Ви впевнені?';

  @override
  String get readOnlyPermission => 'Тільки для читання';

  @override
  String get readWritePermission => 'Читати та писати';

  @override
  String get selectPermission => 'Виберіть Дозвіл';

  @override
  String get shareViaSocial => 'Поділіться через соціальні мережі';

  @override
  String get notePinned => 'Нотатку закріплено';

  @override
  String get noteUnpinned => 'Нотатку відкріплено';

  @override
  String get notePermanentlyDeleted => 'Нотатку видалено остаточно';

  @override
  String get movedToTrash => 'Переміщено в кошик';

  @override
  String get noteInfo => 'Примітка Інформація';

  @override
  String wordCount(int count) {
    return 'Кількість слів: $count';
  }

  @override
  String get fontFamilyTitle => 'Стиль шрифту';

  @override
  String get fontDefault => 'За замовчуванням (система)';

  @override
  String get fontSerif => 'Засічки';

  @override
  String get fontMonospace => 'Моноширинні';

  @override
  String get fontCursive => 'Курсив';

  @override
  String get newPassword => 'Новий пароль';

  @override
  String get required => 'Обов\'язковий';

  @override
  String get passwordUppercase =>
      'Пароль має містити принаймні одну велику літеру';

  @override
  String get passwordLowercase =>
      'Пароль має містити принаймні одну малу літеру';

  @override
  String get passwordDigit => 'Пароль повинен містити хоча б одне число';

  @override
  String get imageLabel => 'Зображення';

  @override
  String get clearAll => 'Очистити все';
}
