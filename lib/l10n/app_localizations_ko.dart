// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appName => 'NotIdea';

  @override
  String get appTagline => '창의적인 메모 작성 동반자';

  @override
  String get ok => '좋아요';

  @override
  String get cancel => '취소';

  @override
  String get save => '구하다';

  @override
  String get delete => '삭제';

  @override
  String get edit => '편집하다';

  @override
  String get share => '공유하다';

  @override
  String get search => '찾다';

  @override
  String get loading => '로드 중...';

  @override
  String get error => '오류';

  @override
  String get retry => '다시 해 보다';

  @override
  String get done => '완료';

  @override
  String get close => '닫다';

  @override
  String get back => '뒤쪽에';

  @override
  String get next => '다음';

  @override
  String get confirm => '확인하다';

  @override
  String get yes => '예';

  @override
  String get no => '아니요';

  @override
  String get copy => '복사';

  @override
  String get copied => '복사되었습니다!';

  @override
  String get selectAll => '모두 선택';

  @override
  String get more => '더';

  @override
  String get refresh => '새로 고치다';

  @override
  String get emptyStateGeneral => '아직 아무것도 없습니다';

  @override
  String get emptyStateDescription => '놀라운 것을 창조해 보세요';

  @override
  String get login => '로그인';

  @override
  String get signup => '가입';

  @override
  String get logout => '로그아웃';

  @override
  String get email => '이메일';

  @override
  String get password => '비밀번호';

  @override
  String get confirmPassword => '비밀번호 확인';

  @override
  String get forgotPassword => '비밀번호를 잊으셨나요?';

  @override
  String get resetPassword => '비밀번호 재설정';

  @override
  String get sendResetLink => '재설정 링크 보내기';

  @override
  String get resetLinkSent => '귀하의 이메일로 비밀번호 재설정 링크가 전송되었습니다.';

  @override
  String get loginWithEmail => '이메일로 로그인';

  @override
  String get signupWithEmail => '이메일로 가입';

  @override
  String get alreadyHaveAccount => '이미 계정이 있나요?';

  @override
  String get dontHaveAccount => '계정이 없나요?';

  @override
  String get welcomeBack => '돌아온 것을 환영합니다';

  @override
  String get createAccount => '계정 만들기';

  @override
  String get orContinueWith => '아니면 계속해서';

  @override
  String get agreeToTerms => '가입하시면 서비스 약관 및 개인정보 보호정책에 동의하시는 것으로 간주됩니다.';

  @override
  String get emailRequired => '이메일은 필수입니다';

  @override
  String get invalidEmail => '유효한 이메일을 입력해주세요';

  @override
  String get passwordRequired => '비밀번호가 필요합니다';

  @override
  String get passwordTooShort => '비밀번호는 8자 이상이어야 합니다.';

  @override
  String get passwordNeedsUppercase => '비밀번호에는 대문자가 하나 이상 포함되어야 합니다.';

  @override
  String get passwordNeedsLowercase => '비밀번호에는 소문자가 하나 이상 포함되어야 합니다.';

  @override
  String get passwordNeedsDigit => '비밀번호에는 숫자가 1개 이상 포함되어야 합니다.';

  @override
  String get passwordsDoNotMatch => '비밀번호가 일치하지 않습니다.';

  @override
  String get createNote => '메모 작성';

  @override
  String get editNote => '메모 편집';

  @override
  String get deleteNote => '메모 삭제';

  @override
  String get noteTitle => '제목';

  @override
  String get noteContent => '글쓰기를 시작하세요...';

  @override
  String get noteTitleHint => '메모 제목 입력';

  @override
  String get noteContentHint => '마크다운으로 메모를 작성하세요...';

  @override
  String get noteDeleted => '메모가 삭제되었습니다.';

  @override
  String get noteRestored => '메모가 복원되었습니다.';

  @override
  String get noteSaved => '메모가 저장되었습니다.';

  @override
  String get noteShared => '메모가 공유됨';

  @override
  String get deleteNoteConfirm => '이 메모를 삭제하시겠습니까?';

  @override
  String get deleteNotePermanentConfirm => '이 작업은 취소할 수 없습니다. 영구적으로 삭제하시겠습니까?';

  @override
  String get noteVisibility => '시계';

  @override
  String get visibilityPrivate => '사적인';

  @override
  String get visibilityShared => '공유됨';

  @override
  String get visibilityPublic => '공공의';

  @override
  String get visibilityPrivateDesc => '이 메모는 나만 볼 수 있습니다.';

  @override
  String get visibilitySharedDesc => '친구와 그룹 회원에게 표시됩니다.';

  @override
  String get visibilityPublicDesc => '모든 사람에게 공개';

  @override
  String get notes => '메모';

  @override
  String get allNotes => '모든 노트';

  @override
  String get myNotes => '내 노트';

  @override
  String get noNotes => '아직 메모가 없습니다.';

  @override
  String get noNotesDesc => '첫 번째 메모를 작성하려면 +를 탭하세요.';

  @override
  String get sortBy => '정렬 기준';

  @override
  String get sortNewest => '최신순';

  @override
  String get sortOldest => '오래된 것부터';

  @override
  String get sortAlphabetical => '알파벳순';

  @override
  String get sortLastEdited => '마지막으로 수정됨';

  @override
  String get pinNote => '핀 노트';

  @override
  String get unpinNote => '메모 고정 해제';

  @override
  String get duplicateNote => '중복된 메모';

  @override
  String get profile => '윤곽';

  @override
  String get editProfile => '프로필 편집';

  @override
  String get displayName => '표시 이름';

  @override
  String get username => '사용자 이름';

  @override
  String get bio => '바이오';

  @override
  String get bioHint => '자신에 대해 알려주세요';

  @override
  String get profileUpdated => '프로필이 업데이트되었습니다.';

  @override
  String get changeAvatar => '사진 변경';

  @override
  String get removeAvatar => '사진 삭제';

  @override
  String get usernameRequired => '사용자 이름이 필요합니다';

  @override
  String get usernameTooShort => '사용자 이름은 3자 이상이어야 합니다.';

  @override
  String get usernameTooLong => '사용자 이름은 최대 20자여야 합니다.';

  @override
  String get usernameInvalid => '사용자 이름에는 문자, 숫자, 밑줄만 포함할 수 있습니다.';

  @override
  String get displayNameRequired => '표시 이름은 필수 항목입니다.';

  @override
  String get friends => '친구';

  @override
  String get addFriend => '친구 추가';

  @override
  String get removeFriend => '친구 삭제';

  @override
  String get friendRequests => '친구 요청';

  @override
  String get pendingRequests => '보류 중인 요청';

  @override
  String get sentRequests => '보낸 요청';

  @override
  String get acceptRequest => '수용하다';

  @override
  String get declineRequest => '감소';

  @override
  String get cancelRequest => '요청 취소';

  @override
  String get sendFriendRequest => '친구 요청 보내기';

  @override
  String get friendRequestSent => '친구 요청이 전송되었습니다';

  @override
  String get friendRequestAccepted => '친구 요청이 수락되었습니다.';

  @override
  String get friendRemoved => '친구가 삭제되었습니다.';

  @override
  String get noFriends => '아직 친구가 없습니다';

  @override
  String get noFriendsDesc => '사람을 검색하고 친구로 추가하세요.';

  @override
  String get noFriendRequests => '친구 요청 없음';

  @override
  String get searchFriends => '친구 검색...';

  @override
  String get searchUsers => '사용자 검색...';

  @override
  String get groups => '여러 떼';

  @override
  String get createGroup => '그룹 만들기';

  @override
  String get groupName => '그룹 이름';

  @override
  String get groupDescription => '설명';

  @override
  String get members => '회원';

  @override
  String get addMembers => '회원 추가';

  @override
  String get removeMember => '회원 삭제';

  @override
  String get leaveGroup => '그룹 탈퇴';

  @override
  String get deleteGroup => '그룹 삭제';

  @override
  String get groupCreated => '그룹이 생성되었습니다.';

  @override
  String get groupUpdated => '그룹이 업데이트되었습니다.';

  @override
  String get groupDeleted => '그룹이 삭제되었습니다.';

  @override
  String get noGroups => '아직 그룹이 없습니다.';

  @override
  String get noGroupsDesc => '그룹을 만들어 다른 사람들과 메모를 공유하세요';

  @override
  String memberCount(int count) {
    return '$count명의 회원';
  }

  @override
  String get explore => '탐구하다';

  @override
  String get exploreDesc => '커뮤니티의 공개 메모를 찾아보세요';

  @override
  String get trending => '인기 급상승';

  @override
  String get recent => '최근의';

  @override
  String get noExploreResults => '아직 공개 메모가 없습니다.';

  @override
  String get noExploreResultsDesc => '커뮤니티와 가장 먼저 메모를 공유하세요';

  @override
  String get favorites => '즐겨찾기';

  @override
  String get addToFavorites => '즐겨찾기에 추가';

  @override
  String get removeFromFavorites => '즐겨찾기에서 제거';

  @override
  String get addedToFavorites => '즐겨찾기에 추가됨';

  @override
  String get removedFromFavorites => '즐겨찾기에서 삭제됨';

  @override
  String get noFavorites => '아직 즐겨찾기가 없습니다.';

  @override
  String get noFavoritesDesc => '여기에 추가하려면 메모의 하트 아이콘을 탭하세요.';

  @override
  String get trash => '쓰레기';

  @override
  String get restoreNote => '복원하다';

  @override
  String get deletePermanently => '영구적으로 삭제';

  @override
  String get emptyTrash => '휴지통 비우기';

  @override
  String get emptyTrashConfirm => '휴지통에 있는 모든 메모를 영구적으로 삭제하시겠습니까?';

  @override
  String get trashEmpty => '휴지통이 비어 있습니다.';

  @override
  String get trashEmptyDesc => '삭제된 메모가 여기에 표시됩니다.';

  @override
  String get trashAutoDeleteInfo => '휴지통에 있는 메모는 30일 후에 영구적으로 삭제됩니다.';

  @override
  String get sharedNotes => '공유 노트';

  @override
  String get sharedWithMe => '나와 공유됨';

  @override
  String get sharedByMe => '내가 공유함';

  @override
  String get noSharedNotes => '공유된 메모 없음';

  @override
  String get noSharedNotesDesc => '나와 공유된 메모가 여기에 표시됩니다.';

  @override
  String get searchHint => '메모, 사람, 그룹 검색...';

  @override
  String get searchNotes => '노트 검색';

  @override
  String get searchResults => '검색결과';

  @override
  String get noSearchResults => '검색결과가 없습니다';

  @override
  String get noSearchResultsDesc => '다른 키워드를 사용해 보세요';

  @override
  String get recentSearches => '최근 검색';

  @override
  String get clearSearchHistory => '검색 기록 지우기';

  @override
  String get settings => '설정';

  @override
  String get appearance => '모습';

  @override
  String get theme => '주제';

  @override
  String get themeLight => '빛';

  @override
  String get themeDark => '어두운';

  @override
  String get themeSystem => '체계';

  @override
  String get language => '언어';

  @override
  String get languageEnglish => '영어';

  @override
  String get languageTurkish => '터키어';

  @override
  String get notifications => '알림';

  @override
  String get account => '계정';

  @override
  String get deleteAccount => '계정 삭제';

  @override
  String get deleteAccountConfirm =>
      '이렇게 하면 귀하의 계정과 모든 데이터가 영구적으로 삭제됩니다. 이 작업은 취소할 수 없습니다.';

  @override
  String get aboutApp => 'NotIdea 소개';

  @override
  String get version => '버전';

  @override
  String get buildNumber => '짓다';

  @override
  String get updateAvailableTitle => '업데이트 가능';

  @override
  String get updateAvailableMessage => 'NotIdea의 새 버전을 사용할 수 있습니다.';

  @override
  String get updateRequiredTitle => '업데이트 필요';

  @override
  String get updateRequiredMessage => 'NotIdea를 계속 사용하려면 업데이트해야 합니다.';

  @override
  String get updateNow => '지금 업데이트';

  @override
  String get updateLater => '나중에';

  @override
  String get updateChangelog => '새로운 소식';

  @override
  String get openDownloadPage => '다운로드 페이지 열기';

  @override
  String get legal => '합법적인';

  @override
  String get privacyPolicy => '개인 정보 보호 정책';

  @override
  String get termsOfService => '서비스 약관';

  @override
  String get openSourceLicenses => '오픈 소스 라이선스';

  @override
  String get dangerZone => '위험지대';

  @override
  String get changePassword => '비밀번호 변경';

  @override
  String get logoutConfirm => '정말로 로그아웃하시겠습니까?';

  @override
  String get noteColorDefault => '기본';

  @override
  String get enterYourEmail => '이메일을 입력하세요';

  @override
  String get enterYourPassword => '비밀번호를 입력하세요';

  @override
  String get emailInvalid => '유효한 이메일 주소를 입력하세요.';

  @override
  String get loginSubtitle => '돌아온 것을 환영합니다! 계속하려면 로그인하세요.';

  @override
  String get signUp => '가입';

  @override
  String get signupSubtitle => '시작하려면 계정을 만드세요';

  @override
  String get signupSuccess => '계정이 성공적으로 생성되었습니다!';

  @override
  String get enterDisplayName => '표시 이름을 입력하세요.';

  @override
  String get displayNameTooLong => '표시 이름이 너무 깁니다.';

  @override
  String get enterUsername => '사용자 이름을 입력하세요';

  @override
  String get createPassword => '비밀번호 만들기';

  @override
  String get confirmYourPassword => '비밀번호를 확인하세요';

  @override
  String get confirmPasswordRequired => '비밀번호를 확인해 주세요';

  @override
  String get pleaseAcceptTerms => '이용약관에 동의해 주세요.';

  @override
  String get iAgreeToThe => '나는 다음에 동의한다.';

  @override
  String get resetPasswordEmailSent => '비밀번호 재설정 이메일이 전송되었습니다';

  @override
  String get send => '보내다';

  @override
  String get and => '그리고';

  @override
  String get bold => '용감한';

  @override
  String get italic => '이탤릭체';

  @override
  String get heading => '표제';

  @override
  String get link => '링크';

  @override
  String get image => '영상';

  @override
  String get code => '암호';

  @override
  String get quote => '인용하다';

  @override
  String get bulletList => '글머리 기호 목록';

  @override
  String get numberedList => '번호 매기기 목록';

  @override
  String get preview => '시사';

  @override
  String get startWriting => '글쓰기를 시작하세요...';

  @override
  String get untitled => '제목 없음';

  @override
  String get newNote => '새 메모';

  @override
  String get noteColor => '참고 색상';

  @override
  String get visibility => '시계';

  @override
  String get tagsHint => '쉼표로 구분된 태그 추가';

  @override
  String get unsavedChanges => '저장되지 않은 변경사항';

  @override
  String get unsavedChangesMessage => '저장되지 않은 변경사항이 있습니다. 폐기하시겠습니까?';

  @override
  String get discard => '버리다';

  @override
  String get errorLoadingNote => '메모를 로드할 수 없습니다.';

  @override
  String get noteNotFound => '메모를 찾을 수 없습니다.';

  @override
  String get onlyYouCanSee => '이 내용은 나만 볼 수 있습니다.';

  @override
  String get friendsCanSee => '친구가 이 내용을 볼 수 있습니다.';

  @override
  String get everyoneCanSee => '누구나 볼 수 있습니다.';

  @override
  String get profileNotFound => '프로필을 찾을 수 없습니다';

  @override
  String get errorLoadingProfile => '프로필을 로드할 수 없습니다.';

  @override
  String get deleteAccountConfirmation => '확실합니까? 그러면 귀하의 계정이 영구적으로 삭제됩니다.';

  @override
  String get camera => '카메라';

  @override
  String get gallery => '갱도';

  @override
  String get avatarUpdated => '프로필 사진이 업데이트되었습니다.';

  @override
  String get errorGeneral => '문제가 발생했습니다. 다시 시도해 주세요.';

  @override
  String get errorNetwork => '인터넷에 연결되어 있지 않습니다. 네트워크를 확인하세요.';

  @override
  String get errorTimeout => '요청 시간이 초과되었습니다. 다시 시도해 주세요.';

  @override
  String get errorUnauthorized => '세션이 만료되었습니다. 다시 로그인해주세요.';

  @override
  String get errorNotFound => '요청한 리소스를 찾을 수 없습니다.';

  @override
  String get errorServer => '서버 오류입니다. 나중에 다시 시도해 주세요.';

  @override
  String get errorImageTooLarge => '이미지가 너무 큽니다. 최대 크기는 5MB입니다.';

  @override
  String get errorUnsupportedFormat => '지원되지 않는 파일 형식입니다.';

  @override
  String get errorUploadFailed => '업로드에 실패했습니다. 다시 시도해 주세요.';

  @override
  String get successGeneral => '작업이 성공적으로 완료되었습니다.';

  @override
  String get successSaved => '성공적으로 저장되었습니다';

  @override
  String get successDeleted => '삭제되었습니다.';

  @override
  String get successUpdated => '업데이트되었습니다.';

  @override
  String get successCopied => '클립보드에 복사됨';

  @override
  String get timeAgoNow => '방금';

  @override
  String timeAgoMinutes(int minutes) {
    return '$minutes분 전';
  }

  @override
  String timeAgoHours(int hours) {
    return '$hours시간 전';
  }

  @override
  String timeAgoDays(int days) {
    return '$days일 전';
  }

  @override
  String get markdownBold => '용감한';

  @override
  String get markdownItalic => '이탤릭체';

  @override
  String get markdownHeading => '표제';

  @override
  String get markdownList => '목록';

  @override
  String get markdownLink => '링크';

  @override
  String get markdownImage => '영상';

  @override
  String get markdownCode => '암호';

  @override
  String get markdownQuote => '인용하다';

  @override
  String get markdownPreview => '시사';

  @override
  String get markdownEditor => '편집자';

  @override
  String get shareNote => '노트 공유';

  @override
  String get shareViaLink => '링크를 통해 공유';

  @override
  String get copyLink => '링크 복사';

  @override
  String get linkCopied => '링크가 클립보드에 복사되었습니다.';

  @override
  String get selectFriends => '친구 선택';

  @override
  String get selectGroups => '그룹 선택';

  @override
  String get currentShares => '현재 주식';

  @override
  String get removeShare => '공유 제거';

  @override
  String get shareWithFriends => '친구와 공유';

  @override
  String get shareWithGroups => '그룹과 공유';

  @override
  String get viewerRole => '뷰어';

  @override
  String get editorRole => '편집자';

  @override
  String get add => '추가하다';

  @override
  String get permissionUpdated => '권한이 업데이트되었습니다.';

  @override
  String get editGroup => '그룹 편집';

  @override
  String get owner => '소유자';

  @override
  String get admin => '관리자';

  @override
  String get groupNotes => '그룹 노트';

  @override
  String get selectMembers => '회원 선택';

  @override
  String get groupNameRequired => '그룹 이름은 필수 항목입니다.';

  @override
  String get noMembersYet => '아직 회원이 없습니다.';

  @override
  String get confirmRemoveFriend => '이 친구를 삭제하시겠습니까?';

  @override
  String get confirmLeaveGroup => '이 그룹에서 탈퇴하시겠습니까?';

  @override
  String get confirmDeleteGroup => '이 그룹을 삭제하시겠습니까? 이 작업은 취소할 수 없습니다.';

  @override
  String get alreadyFriends => '이미 친구';

  @override
  String get requestPending => '요청 보류 중';

  @override
  String get statusFriend => '친구';

  @override
  String get statusPending => '보류 중';

  @override
  String get visibilityFriends => '친구만';

  @override
  String sharedByUser(String name) {
    return '$name님이 공유함';
  }

  @override
  String deletedAtDate(String date) {
    return '$date에 삭제됨';
  }

  @override
  String get notesTab => '메모';

  @override
  String get usersTab => '사용자';

  @override
  String get publicTab => '공공의';

  @override
  String get noNotesYet => '아직 메모가 없습니다.';

  @override
  String get createFirstNote => '첫 번째 메모를 작성하려면 +를 탭하세요.';

  @override
  String get errorLoadingNotes => '메모를 로드할 수 없습니다.';

  @override
  String get deleteNoteConfirmation => '이 메모를 삭제하시겠습니까?';

  @override
  String get filterBy => '필터링 기준';

  @override
  String get dateModified => '수정된 날짜';

  @override
  String get dateCreated => '생성된 날짜';

  @override
  String get titleLabel => '제목';

  @override
  String get privateNotes => '사적인';

  @override
  String get publicNotes => '공공의';

  @override
  String get friendsNotes => '친구';

  @override
  String get clearFilters => '필터 지우기';

  @override
  String get groupSharedNotes => '그룹 공유 노트';

  @override
  String get completeYourProfile => '프로필을 작성하세요';

  @override
  String get profileSetupSubtitle => '시작하려면 세부정보를 추가하세요.';

  @override
  String get tapToAddPhoto => '프로필 사진을 추가하려면 탭하세요.';

  @override
  String get getStarted => '시작하기';

  @override
  String get checkEmailToConfirm => '이메일을 확인하여 계정을 확인한 후 로그인하세요.';

  @override
  String get usernameTaken => '이 사용자 이름은 이미 사용 중입니다.';

  @override
  String get checkingUsername => '이용 가능 여부 확인 중...';

  @override
  String get resetChanges => '변경사항 재설정';

  @override
  String get resetConfirmTitle => '변경사항을 재설정하시겠습니까?';

  @override
  String get resetConfirmMessage => '저장되지 않은 모든 변경사항은 손실됩니다. 확실합니까?';

  @override
  String get readOnlyPermission => '읽기 전용';

  @override
  String get readWritePermission => '읽기 및 쓰기';

  @override
  String get selectPermission => '권한 선택';

  @override
  String get shareViaSocial => '소셜 미디어를 통해 공유';

  @override
  String get notePinned => '메모가 고정되었습니다.';

  @override
  String get noteUnpinned => '메모가 고정 해제되었습니다.';

  @override
  String get notePermanentlyDeleted => '메모가 영구적으로 삭제되었습니다.';

  @override
  String get movedToTrash => '휴지통으로 이동됨';

  @override
  String get noteInfo => '참고 정보';

  @override
  String wordCount(int count) {
    return '단어 수: $count';
  }

  @override
  String get fontFamilyTitle => '글꼴 스타일';

  @override
  String get fontDefault => '기본값(시스템)';

  @override
  String get fontSerif => '가는 장식 선';

  @override
  String get fontMonospace => '고정 폭';

  @override
  String get fontCursive => '필기체';

  @override
  String get newPassword => '새 비밀번호';

  @override
  String get required => '필수의';

  @override
  String get passwordUppercase => '비밀번호에는 대문자가 하나 이상 포함되어야 합니다.';

  @override
  String get passwordLowercase => '비밀번호에는 소문자가 하나 이상 포함되어야 합니다.';

  @override
  String get passwordDigit => '비밀번호에는 숫자가 하나 이상 포함되어야 합니다.';

  @override
  String get imageLabel => '영상';

  @override
  String get clearAll => '모두 지우기';
}
