// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'NotIdea';

  @override
  String get appTagline => 'Ваш творческий помощник для создания заметок';

  @override
  String get ok => 'ХОРОШО';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранять';

  @override
  String get delete => 'Удалить';

  @override
  String get edit => 'Редактировать';

  @override
  String get share => 'Делиться';

  @override
  String get search => 'Поиск';

  @override
  String get loading => 'Загрузка...';

  @override
  String get error => 'Ошибка';

  @override
  String get retry => 'Повторить попытку';

  @override
  String get done => 'Сделанный';

  @override
  String get close => 'Закрывать';

  @override
  String get back => 'Назад';

  @override
  String get next => 'Следующий';

  @override
  String get confirm => 'Подтверждать';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get copy => 'Копировать';

  @override
  String get copied => 'Скопировано!';

  @override
  String get selectAll => 'Выбрать все';

  @override
  String get more => 'Более';

  @override
  String get refresh => 'Обновить';

  @override
  String get emptyStateGeneral => 'Здесь пока ничего';

  @override
  String get emptyStateDescription => 'Начните создавать что-то потрясающее';

  @override
  String get login => 'Авторизоваться';

  @override
  String get signup => 'Зарегистрироваться';

  @override
  String get logout => 'Выйти';

  @override
  String get email => 'Электронная почта';

  @override
  String get password => 'Пароль';

  @override
  String get confirmPassword => 'Подтвердите пароль';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get resetPassword => 'Сбросить пароль';

  @override
  String get sendResetLink => 'Отправить ссылку для сброса';

  @override
  String get resetLinkSent =>
      'Ссылка для сброса пароля отправлена ​​на вашу электронную почту';

  @override
  String get loginWithEmail => 'Войти с помощью электронной почты';

  @override
  String get signupWithEmail => 'Зарегистрируйтесь по электронной почте';

  @override
  String get alreadyHaveAccount => 'У вас уже есть аккаунт?';

  @override
  String get dontHaveAccount => 'У вас нет учетной записи?';

  @override
  String get welcomeBack => 'Добро пожаловать';

  @override
  String get createAccount => 'Зарегистрироваться';

  @override
  String get orContinueWith => 'Или продолжить с';

  @override
  String get agreeToTerms =>
      'Регистрируясь, вы соглашаетесь с нашими Условиями обслуживания и Политикой конфиденциальности.';

  @override
  String get emailRequired => 'Требуется электронная почта';

  @override
  String get invalidEmail =>
      'Пожалуйста, введите действительный адрес электронной почты';

  @override
  String get passwordRequired => 'Требуется пароль';

  @override
  String get passwordTooShort => 'Пароль должен быть не менее 8 символов';

  @override
  String get passwordNeedsUppercase =>
      'Пароль должен содержать хотя бы одну заглавную букву';

  @override
  String get passwordNeedsLowercase =>
      'Пароль должен содержать хотя бы одну строчную букву';

  @override
  String get passwordNeedsDigit => 'Пароль должен содержать хотя бы одну цифру';

  @override
  String get passwordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get createNote => 'Создать заметку';

  @override
  String get editNote => 'Редактировать заметку';

  @override
  String get deleteNote => 'Удалить заметку';

  @override
  String get noteTitle => 'Заголовок';

  @override
  String get noteContent => 'Начни писать...';

  @override
  String get noteTitleHint => 'Введите название заметки';

  @override
  String get noteContentHint => 'Напишите заметку в уценке...';

  @override
  String get noteDeleted => 'Примечание удалено.';

  @override
  String get noteRestored => 'Примечание восстановлено';

  @override
  String get noteSaved => 'Заметка сохранена.';

  @override
  String get noteShared => 'Примечание опубликовано';

  @override
  String get deleteNoteConfirm => 'Вы уверены, что хотите удалить эту заметку?';

  @override
  String get deleteNotePermanentConfirm =>
      'Это действие невозможно отменить. Удалить навсегда?';

  @override
  String get noteVisibility => 'Видимость';

  @override
  String get visibilityPrivate => 'Частный';

  @override
  String get visibilityShared => 'Общий';

  @override
  String get visibilityPublic => 'Общественный';

  @override
  String get visibilityPrivateDesc => 'Эту заметку можете видеть только вы';

  @override
  String get visibilitySharedDesc => 'Видно друзьям и участникам группы';

  @override
  String get visibilityPublicDesc => 'Видно всем';

  @override
  String get notes => 'Примечания';

  @override
  String get allNotes => 'Все заметки';

  @override
  String get myNotes => 'Мои заметки';

  @override
  String get noNotes => 'Пока нет заметок';

  @override
  String get noNotesDesc => 'Нажмите +, чтобы создать свою первую заметку.';

  @override
  String get sortBy => 'Сортировать по';

  @override
  String get sortNewest => 'Сначала самые новые';

  @override
  String get sortOldest => 'Сначала самый старый';

  @override
  String get sortAlphabetical => 'Алфавитный';

  @override
  String get sortLastEdited => 'Последнее редактирование';

  @override
  String get pinNote => 'Пин Примечание';

  @override
  String get unpinNote => 'Открепить заметку';

  @override
  String get duplicateNote => 'Дублировать заметку';

  @override
  String get profile => 'Профиль';

  @override
  String get editProfile => 'Редактировать профиль';

  @override
  String get displayName => 'Отображаемое имя';

  @override
  String get username => 'Имя пользователя';

  @override
  String get bio => 'Био';

  @override
  String get bioHint => 'Расскажите нам о себе';

  @override
  String get profileUpdated => 'Профиль обновлен';

  @override
  String get changeAvatar => 'Изменить фото';

  @override
  String get removeAvatar => 'Удалить фото';

  @override
  String get usernameRequired => 'Требуется имя пользователя';

  @override
  String get usernameTooShort =>
      'Имя пользователя должно быть не менее 3 символов';

  @override
  String get usernameTooLong =>
      'Имя пользователя должно содержать не более 20 символов.';

  @override
  String get usernameInvalid =>
      'Имя пользователя может содержать только буквы, цифры и символы подчеркивания.';

  @override
  String get displayNameRequired => 'Требуется отображаемое имя.';

  @override
  String get friends => 'Друзья';

  @override
  String get addFriend => 'Добавить друга';

  @override
  String get removeFriend => 'Удалить друга';

  @override
  String get friendRequests => 'Запросы на добавление в друзья';

  @override
  String get pendingRequests => 'Ожидающие запросы';

  @override
  String get sentRequests => 'Отправленные запросы';

  @override
  String get acceptRequest => 'Принимать';

  @override
  String get declineRequest => 'Отклонить';

  @override
  String get cancelRequest => 'Отменить запрос';

  @override
  String get sendFriendRequest => 'Отправить запрос на добавление в друзья';

  @override
  String get friendRequestSent => 'Запрос на добавление в друзья отправлен';

  @override
  String get friendRequestAccepted => 'Запрос на добавление в друзья принят';

  @override
  String get friendRemoved => 'Друг удален';

  @override
  String get noFriends => 'Друзей пока нет';

  @override
  String get noFriendsDesc => 'Ищите людей и добавляйте их в друзья';

  @override
  String get noFriendRequests => 'Нет запросов в друзья';

  @override
  String get searchFriends => 'Поиск друзей...';

  @override
  String get searchUsers => 'Поиск пользователей...';

  @override
  String get groups => 'Группы';

  @override
  String get createGroup => 'Создать группу';

  @override
  String get groupName => 'Имя группы';

  @override
  String get groupDescription => 'Описание';

  @override
  String get members => 'Члены';

  @override
  String get addMembers => 'Добавить участников';

  @override
  String get removeMember => 'Удалить участника';

  @override
  String get leaveGroup => 'Покинуть группу';

  @override
  String get deleteGroup => 'Удалить группу';

  @override
  String get groupCreated => 'Группа создана';

  @override
  String get groupUpdated => 'Группа обновлена';

  @override
  String get groupDeleted => 'Группа удалена';

  @override
  String get noGroups => 'Группы пока нет';

  @override
  String get noGroupsDesc =>
      'Создайте группу, чтобы делиться заметками с другими';

  @override
  String memberCount(int count) {
    return '$count участников';
  }

  @override
  String get explore => 'Исследовать';

  @override
  String get exploreDesc => 'Откройте для себя публичные заметки сообщества';

  @override
  String get trending => 'Тенденции';

  @override
  String get recent => 'Недавний';

  @override
  String get noExploreResults => 'Публичных заметок пока нет';

  @override
  String get noExploreResultsDesc =>
      'Будьте первым, кто поделится заметкой с сообществом';

  @override
  String get favorites => 'Избранное';

  @override
  String get addToFavorites => 'Добавить в избранное';

  @override
  String get removeFromFavorites => 'Удалить из избранного';

  @override
  String get addedToFavorites => 'Добавлено в избранное';

  @override
  String get removedFromFavorites => 'Удалено из избранного';

  @override
  String get noFavorites => 'Пока нет избранных';

  @override
  String get noFavoritesDesc =>
      'Коснитесь значка сердечка на заметке, чтобы добавить ее сюда.';

  @override
  String get trash => 'Мусор';

  @override
  String get restoreNote => 'Восстановить';

  @override
  String get deletePermanently => 'Удалить навсегда';

  @override
  String get emptyTrash => 'Пустой мусор';

  @override
  String get emptyTrashConfirm => 'Удалить все заметки из корзины навсегда?';

  @override
  String get trashEmpty => 'Корзина пуста';

  @override
  String get trashEmptyDesc => 'Здесь появятся удаленные заметки.';

  @override
  String get trashAutoDeleteInfo =>
      'Заметки в корзине будут удалены навсегда через 30 дней.';

  @override
  String get sharedNotes => 'Общие заметки';

  @override
  String get sharedWithMe => 'Поделились со мной';

  @override
  String get sharedByMe => 'Поделился мной';

  @override
  String get noSharedNotes => 'Нет общих заметок';

  @override
  String get noSharedNotesDesc =>
      'Здесь появятся заметки, которыми с вами поделились.';

  @override
  String get searchHint => 'Поиск заметок, людей, групп...';

  @override
  String get searchNotes => 'Поиск заметок';

  @override
  String get searchResults => 'Результаты поиска';

  @override
  String get noSearchResults => 'Результаты не найдены';

  @override
  String get noSearchResultsDesc => 'Попробуйте разные ключевые слова';

  @override
  String get recentSearches => 'Недавние поиски';

  @override
  String get clearSearchHistory => 'Очистить историю поиска';

  @override
  String get settings => 'Настройки';

  @override
  String get appearance => 'Появление';

  @override
  String get theme => 'Тема';

  @override
  String get themeLight => 'Свет';

  @override
  String get themeDark => 'Темный';

  @override
  String get themeSystem => 'Система';

  @override
  String get language => 'Язык';

  @override
  String get languageEnglish => 'Английский';

  @override
  String get languageTurkish => 'турецкий';

  @override
  String get notifications => 'Уведомления';

  @override
  String get account => 'Счет';

  @override
  String get deleteAccount => 'Удалить аккаунт';

  @override
  String get deleteAccountConfirm =>
      'Это приведет к безвозвратному удалению вашей учетной записи и всех данных. Это действие невозможно отменить.';

  @override
  String get aboutApp => 'О NotIdea';

  @override
  String get version => 'Версия';

  @override
  String get buildNumber => 'Строить';

  @override
  String get updateAvailableTitle => 'Доступно обновление';

  @override
  String get updateAvailableMessage => 'Доступна новая версия NotIdea.';

  @override
  String get updateRequiredTitle => 'Требуется обновление';

  @override
  String get updateRequiredMessage =>
      'Вам необходимо обновиться, чтобы продолжить использование NotIdea.';

  @override
  String get updateNow => 'Обновить сейчас';

  @override
  String get updateLater => 'Позже';

  @override
  String get updateChangelog => 'Что нового';

  @override
  String get openDownloadPage => 'Открыть страницу загрузки';

  @override
  String get legal => 'Юридический';

  @override
  String get privacyPolicy => 'политика конфиденциальности';

  @override
  String get termsOfService => 'Условия использования';

  @override
  String get openSourceLicenses => 'Лицензии с открытым исходным кодом';

  @override
  String get dangerZone => 'Опасная зона';

  @override
  String get changePassword => 'Изменить пароль';

  @override
  String get logoutConfirm => 'Вы уверены, что хотите выйти?';

  @override
  String get noteColorDefault => 'По умолчанию';

  @override
  String get enterYourEmail => 'Введите адрес электронной почты';

  @override
  String get enterYourPassword => 'Введите свой пароль';

  @override
  String get emailInvalid =>
      'Пожалуйста, введите действительный адрес электронной почты';

  @override
  String get loginSubtitle => 'Добро пожаловать! Войдите, чтобы продолжить';

  @override
  String get signUp => 'Зарегистрироваться';

  @override
  String get signupSubtitle => 'Создайте учетную запись, чтобы начать';

  @override
  String get signupSuccess => 'Аккаунт успешно создан!';

  @override
  String get enterDisplayName => 'Введите отображаемое имя';

  @override
  String get displayNameTooLong => 'Отображаемое имя слишком длинное';

  @override
  String get enterUsername => 'Введите свое имя пользователя';

  @override
  String get createPassword => 'Создать пароль';

  @override
  String get confirmYourPassword => 'Подтвердите свой пароль';

  @override
  String get confirmPasswordRequired => 'Пожалуйста, подтвердите свой пароль';

  @override
  String get pleaseAcceptTerms => 'Пожалуйста, примите условия использования';

  @override
  String get iAgreeToThe => 'Я согласен на';

  @override
  String get resetPasswordEmailSent => 'Письмо для сброса пароля отправлено';

  @override
  String get send => 'Отправлять';

  @override
  String get and => 'и';

  @override
  String get bold => 'Смелый';

  @override
  String get italic => 'Курсив';

  @override
  String get heading => 'Заголовок';

  @override
  String get link => 'Связь';

  @override
  String get image => 'Изображение';

  @override
  String get code => 'Код';

  @override
  String get quote => 'Цитировать';

  @override
  String get bulletList => 'Маркированный список';

  @override
  String get numberedList => 'Нумерованный список';

  @override
  String get preview => 'Предварительный просмотр';

  @override
  String get startWriting => 'Начни писать...';

  @override
  String get untitled => 'Без названия';

  @override
  String get newNote => 'Новая заметка';

  @override
  String get noteColor => 'Примечание Цвет';

  @override
  String get visibility => 'Видимость';

  @override
  String get tagsHint => 'Добавляйте теги через запятую';

  @override
  String get unsavedChanges => 'Несохраненные изменения';

  @override
  String get unsavedChangesMessage =>
      'У вас есть несохраненные изменения. Выбросить их?';

  @override
  String get discard => 'Отказаться';

  @override
  String get errorLoadingNote => 'Не удалось загрузить заметку';

  @override
  String get noteNotFound => 'Примечание не найдено';

  @override
  String get onlyYouCanSee => 'Только ты можешь это видеть';

  @override
  String get friendsCanSee => 'Ваши друзья могут это увидеть';

  @override
  String get everyoneCanSee => 'Это может увидеть каждый';

  @override
  String get profileNotFound => 'Профиль не найден';

  @override
  String get errorLoadingProfile => 'Не удалось загрузить профиль';

  @override
  String get deleteAccountConfirmation =>
      'Вы уверены? Это приведет к окончательному удалению вашей учетной записи.';

  @override
  String get camera => 'Камера';

  @override
  String get gallery => 'Галерея';

  @override
  String get avatarUpdated => 'Фотография профиля обновлена';

  @override
  String get errorGeneral =>
      'Что-то пошло не так. Пожалуйста, попробуйте еще раз.';

  @override
  String get errorNetwork =>
      'Нет подключения к Интернету. Пожалуйста, проверьте вашу сеть.';

  @override
  String get errorTimeout =>
      'Время запроса истекло. Пожалуйста, попробуйте еще раз.';

  @override
  String get errorUnauthorized => 'Сессия истекла. Пожалуйста, войдите снова.';

  @override
  String get errorNotFound => 'Запрошенный ресурс не найден.';

  @override
  String get errorServer =>
      'Ошибка сервера. Пожалуйста, повторите попытку позже.';

  @override
  String get errorImageTooLarge =>
      'Изображение слишком велико. Максимальный размер — 5 МБ.';

  @override
  String get errorUnsupportedFormat => 'Неподдерживаемый формат файла.';

  @override
  String get errorUploadFailed =>
      'Загрузка не удалась. Пожалуйста, попробуйте еще раз.';

  @override
  String get successGeneral => 'Операция завершена успешно';

  @override
  String get successSaved => 'Сохранено успешно.';

  @override
  String get successDeleted => 'Удален успешно';

  @override
  String get successUpdated => 'Обновлено успешно';

  @override
  String get successCopied => 'Скопировано в буфер обмена';

  @override
  String get timeAgoNow => 'Прямо сейчас';

  @override
  String timeAgoMinutes(int minutes) {
    return '$minutes мин. назад';
  }

  @override
  String timeAgoHours(int hours) {
    return '$hours часов назад';
  }

  @override
  String timeAgoDays(int days) {
    return '$days дней назад';
  }

  @override
  String get markdownBold => 'Смелый';

  @override
  String get markdownItalic => 'Курсив';

  @override
  String get markdownHeading => 'Заголовок';

  @override
  String get markdownList => 'Список';

  @override
  String get markdownLink => 'Связь';

  @override
  String get markdownImage => 'Изображение';

  @override
  String get markdownCode => 'Код';

  @override
  String get markdownQuote => 'Цитировать';

  @override
  String get markdownPreview => 'Предварительный просмотр';

  @override
  String get markdownEditor => 'Редактор';

  @override
  String get shareNote => 'Поделиться заметкой';

  @override
  String get shareViaLink => 'Поделиться по ссылке';

  @override
  String get copyLink => 'Копировать ссылку';

  @override
  String get linkCopied => 'Ссылка скопирована в буфер обмена';

  @override
  String get selectFriends => 'Выберите друзей';

  @override
  String get selectGroups => 'Выберите группы';

  @override
  String get currentShares => 'Текущие акции';

  @override
  String get removeShare => 'Удалить общий доступ';

  @override
  String get shareWithFriends => 'Поделитесь с друзьями';

  @override
  String get shareWithGroups => 'Поделиться с группами';

  @override
  String get viewerRole => 'Зритель';

  @override
  String get editorRole => 'Редактор';

  @override
  String get add => 'Добавлять';

  @override
  String get permissionUpdated => 'Разрешение обновлено';

  @override
  String get editGroup => 'Редактировать группу';

  @override
  String get owner => 'Владелец';

  @override
  String get admin => 'Админ';

  @override
  String get groupNotes => 'Примечания группы';

  @override
  String get selectMembers => 'Выберите участников';

  @override
  String get groupNameRequired => 'Укажите название группы.';

  @override
  String get noMembersYet => 'Пока нет участников';

  @override
  String get confirmRemoveFriend =>
      'Вы уверены, что хотите удалить этого друга?';

  @override
  String get confirmLeaveGroup => 'Вы уверены, что хотите покинуть эту группу?';

  @override
  String get confirmDeleteGroup =>
      'Вы уверены, что хотите удалить эту группу? Это действие невозможно отменить.';

  @override
  String get alreadyFriends => 'Уже друзья';

  @override
  String get requestPending => 'Запрос находится на рассмотрении';

  @override
  String get statusFriend => 'Друг';

  @override
  String get statusPending => 'В ожидании';

  @override
  String get visibilityFriends => 'Только друзья';

  @override
  String sharedByUser(String name) {
    return 'Поделился $name';
  }

  @override
  String deletedAtDate(String date) {
    return 'Удален $date';
  }

  @override
  String get notesTab => 'Примечания';

  @override
  String get usersTab => 'Пользователи';

  @override
  String get publicTab => 'Общественный';

  @override
  String get noNotesYet => 'Пока нет заметок';

  @override
  String get createFirstNote => 'Нажмите +, чтобы создать свою первую заметку.';

  @override
  String get errorLoadingNotes => 'Не удалось загрузить заметки';

  @override
  String get deleteNoteConfirmation =>
      'Вы уверены, что хотите удалить эту заметку?';

  @override
  String get filterBy => 'Фильтровать по';

  @override
  String get dateModified => 'Дата изменения';

  @override
  String get dateCreated => 'Дата создания';

  @override
  String get titleLabel => 'Заголовок';

  @override
  String get privateNotes => 'Частный';

  @override
  String get publicNotes => 'Общественный';

  @override
  String get friendsNotes => 'Друзья';

  @override
  String get clearFilters => 'Очистить фильтры';

  @override
  String get groupSharedNotes => 'Групповые общие заметки';

  @override
  String get completeYourProfile => 'Заполните свой профиль';

  @override
  String get profileSetupSubtitle => 'Добавьте свои данные, чтобы начать';

  @override
  String get tapToAddPhoto => 'Нажмите, чтобы добавить фотографию профиля';

  @override
  String get getStarted => 'Начать';

  @override
  String get checkEmailToConfirm =>
      'Пожалуйста, проверьте свою электронную почту, чтобы подтвердить свою учетную запись, затем войдите в систему.';

  @override
  String get usernameTaken => 'Это имя пользователя уже занято';

  @override
  String get checkingUsername => 'Проверяем наличие...';

  @override
  String get resetChanges => 'Сбросить изменения';

  @override
  String get resetConfirmTitle => 'Сбросить изменения?';

  @override
  String get resetConfirmMessage =>
      'Все несохраненные изменения будут потеряны. Вы уверены?';

  @override
  String get readOnlyPermission => 'Только чтение';

  @override
  String get readWritePermission => 'Читать и писать';

  @override
  String get selectPermission => 'Выберите разрешение';

  @override
  String get shareViaSocial => 'Поделитесь через социальные сети';

  @override
  String get notePinned => 'Заметка закреплена';

  @override
  String get noteUnpinned => 'Заметка откреплена';

  @override
  String get notePermanentlyDeleted => 'Заметка удалена навсегда';

  @override
  String get movedToTrash => 'Перемещено в корзину';

  @override
  String get noteInfo => 'Примечание Информация';

  @override
  String wordCount(int count) {
    return 'Количество слов: $count';
  }

  @override
  String get fontFamilyTitle => 'Стиль шрифта';

  @override
  String get fontDefault => 'По умолчанию (система)';

  @override
  String get fontSerif => 'с засечками';

  @override
  String get fontMonospace => 'Моноширинный';

  @override
  String get fontCursive => 'Курсив';

  @override
  String get newPassword => 'Новый пароль';

  @override
  String get required => 'Необходимый';

  @override
  String get passwordUppercase =>
      'Пароль должен содержать хотя бы одну заглавную букву';

  @override
  String get passwordLowercase =>
      'Пароль должен содержать хотя бы одну строчную букву';

  @override
  String get passwordDigit => 'Пароль должен содержать хотя бы одну цифру';

  @override
  String get imageLabel => 'Изображение';

  @override
  String get clearAll => 'Очистить все';
}
