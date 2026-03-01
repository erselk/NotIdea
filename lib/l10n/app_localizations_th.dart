// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appName => 'NotIdea';

  @override
  String get appTagline => 'เพื่อนจดบันทึกที่สร้างสรรค์ของคุณ';

  @override
  String get ok => 'ตกลง';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get save => 'บันทึก';

  @override
  String get delete => 'ลบ';

  @override
  String get edit => 'แก้ไข';

  @override
  String get share => 'แบ่งปัน';

  @override
  String get search => 'ค้นหา';

  @override
  String get loading => 'กำลังโหลด...';

  @override
  String get error => 'ข้อผิดพลาด';

  @override
  String get retry => 'ลองอีกครั้ง';

  @override
  String get done => 'เสร็จแล้ว';

  @override
  String get close => 'ปิด';

  @override
  String get back => 'กลับ';

  @override
  String get next => 'ต่อไป';

  @override
  String get confirm => 'ยืนยัน';

  @override
  String get yes => 'ใช่';

  @override
  String get no => 'เลขที่';

  @override
  String get copy => 'สำเนา';

  @override
  String get copied => 'คัดลอก!';

  @override
  String get selectAll => 'เลือกทั้งหมด';

  @override
  String get more => 'มากกว่า';

  @override
  String get refresh => 'รีเฟรช';

  @override
  String get emptyStateGeneral => 'ยังไม่มีอะไรที่นี่';

  @override
  String get emptyStateDescription => 'เริ่มสร้างสิ่งที่น่าทึ่ง';

  @override
  String get login => 'เข้าสู่ระบบ';

  @override
  String get signup => 'ลงทะเบียน';

  @override
  String get logout => 'ออกจากระบบ';

  @override
  String get email => 'อีเมล';

  @override
  String get password => 'รหัสผ่าน';

  @override
  String get confirmPassword => 'ยืนยันรหัสผ่าน';

  @override
  String get forgotPassword => 'ลืมรหัสผ่าน?';

  @override
  String get resetPassword => 'รีเซ็ตรหัสผ่าน';

  @override
  String get sendResetLink => 'ส่งลิงค์รีเซ็ต';

  @override
  String get resetLinkSent => 'ลิงก์รีเซ็ตรหัสผ่านส่งไปยังอีเมลของคุณ';

  @override
  String get loginWithEmail => 'เข้าสู่ระบบด้วยอีเมล';

  @override
  String get signupWithEmail => 'ลงทะเบียนด้วยอีเมล';

  @override
  String get alreadyHaveAccount => 'มีบัญชีอยู่แล้ว?';

  @override
  String get dontHaveAccount => 'ยังไม่มีบัญชี?';

  @override
  String get welcomeBack => 'ยินดีต้อนรับกลับ';

  @override
  String get createAccount => 'สร้างบัญชี';

  @override
  String get orContinueWith => 'หรือต่อด้วย';

  @override
  String get agreeToTerms =>
      'การลงทะเบียนแสดงว่าคุณยอมรับข้อกำหนดในการให้บริการและนโยบายความเป็นส่วนตัวของเรา';

  @override
  String get emailRequired => 'จำเป็นต้องระบุอีเมล';

  @override
  String get invalidEmail => 'กรุณากรอกอีเมล์ที่ถูกต้อง';

  @override
  String get passwordRequired => 'ต้องใช้รหัสผ่าน';

  @override
  String get passwordTooShort => 'รหัสผ่านต้องมีอย่างน้อย 8 ตัวอักษร';

  @override
  String get passwordNeedsUppercase =>
      'รหัสผ่านต้องมีอักษรตัวพิมพ์ใหญ่อย่างน้อยหนึ่งตัว';

  @override
  String get passwordNeedsLowercase =>
      'รหัสผ่านต้องมีตัวอักษรพิมพ์เล็กอย่างน้อยหนึ่งตัว';

  @override
  String get passwordNeedsDigit => 'รหัสผ่านต้องมีอย่างน้อยหนึ่งหลัก';

  @override
  String get passwordsDoNotMatch => 'รหัสผ่านไม่ตรงกัน';

  @override
  String get createNote => 'สร้างบันทึก';

  @override
  String get editNote => 'แก้ไขหมายเหตุ';

  @override
  String get deleteNote => 'ลบบันทึก';

  @override
  String get noteTitle => 'ชื่อ';

  @override
  String get noteContent => 'เริ่มเขียน...';

  @override
  String get noteTitleHint => 'ป้อนชื่อบันทึก';

  @override
  String get noteContentHint => 'เขียนบันทึกของคุณใน markdown...';

  @override
  String get noteDeleted => 'ลบบันทึกแล้ว';

  @override
  String get noteRestored => 'กู้คืนหมายเหตุแล้ว';

  @override
  String get noteSaved => 'บันทึกบันทึกแล้ว';

  @override
  String get noteShared => 'แบ่งปันบันทึกแล้ว';

  @override
  String get deleteNoteConfirm => 'คุณแน่ใจหรือไม่ว่าต้องการลบบันทึกนี้';

  @override
  String get deleteNotePermanentConfirm =>
      'การดำเนินการนี้ไม่สามารถยกเลิกได้ ลบอย่างถาวรใช่ไหม';

  @override
  String get noteVisibility => 'การมองเห็น';

  @override
  String get visibilityPrivate => 'ส่วนตัว';

  @override
  String get visibilityShared => 'แบ่งปันแล้ว';

  @override
  String get visibilityPublic => 'สาธารณะ';

  @override
  String get visibilityPrivateDesc => 'มีเพียงคุณเท่านั้นที่เห็นบันทึกนี้';

  @override
  String get visibilitySharedDesc => 'ปรากฏแก่เพื่อนและสมาชิกกลุ่ม';

  @override
  String get visibilityPublicDesc => 'ปรากฏแก่ทุกคน';

  @override
  String get notes => 'หมายเหตุ';

  @override
  String get allNotes => 'หมายเหตุทั้งหมด';

  @override
  String get myNotes => 'บันทึกของฉัน';

  @override
  String get noNotes => 'ยังไม่มีบันทึก';

  @override
  String get noNotesDesc => 'แตะ + เพื่อสร้างบันทึกแรกของคุณ';

  @override
  String get sortBy => 'เรียงตาม';

  @override
  String get sortNewest => 'ใหม่ล่าสุดก่อน';

  @override
  String get sortOldest => 'เก่าแก่ที่สุดก่อน';

  @override
  String get sortAlphabetical => 'ตามตัวอักษร';

  @override
  String get sortLastEdited => 'แก้ไขครั้งล่าสุด';

  @override
  String get pinNote => 'ปักหมุดหมายเหตุ';

  @override
  String get unpinNote => 'เลิกปักหมุดโน้ต';

  @override
  String get duplicateNote => 'หมายเหตุซ้ำ';

  @override
  String get profile => 'ประวัติโดยย่อ';

  @override
  String get editProfile => 'แก้ไขโปรไฟล์';

  @override
  String get displayName => 'ชื่อที่แสดง';

  @override
  String get username => 'ชื่อผู้ใช้';

  @override
  String get bio => 'ไบโอ';

  @override
  String get bioHint => 'บอกเราเกี่ยวกับตัวคุณ';

  @override
  String get profileUpdated => 'อัปเดตโปรไฟล์แล้ว';

  @override
  String get changeAvatar => 'เปลี่ยนรูปถ่าย';

  @override
  String get removeAvatar => 'ลบรูปภาพ';

  @override
  String get usernameRequired => 'ชื่อผู้ใช้ เป็นสิ่งจำเป็น';

  @override
  String get usernameTooShort => 'ชื่อผู้ใช้ต้องมีอย่างน้อย 3 ตัวอักษร';

  @override
  String get usernameTooLong => 'ชื่อผู้ใช้ต้องมีอักขระไม่เกิน 20 ตัว';

  @override
  String get usernameInvalid =>
      'ชื่อผู้ใช้มีได้เฉพาะตัวอักษร ตัวเลข และขีดล่างเท่านั้น';

  @override
  String get displayNameRequired => 'ต้องระบุชื่อที่แสดง';

  @override
  String get friends => 'เพื่อน';

  @override
  String get addFriend => 'เพิ่มเพื่อน';

  @override
  String get removeFriend => 'ลบเพื่อน';

  @override
  String get friendRequests => 'คำขอเป็นเพื่อน';

  @override
  String get pendingRequests => 'คำขอที่รอดำเนินการ';

  @override
  String get sentRequests => 'ส่งคำขอแล้ว';

  @override
  String get acceptRequest => 'ยอมรับ';

  @override
  String get declineRequest => 'ปฏิเสธ';

  @override
  String get cancelRequest => 'ยกเลิกคำขอ';

  @override
  String get sendFriendRequest => 'ส่งคำขอเป็นเพื่อน';

  @override
  String get friendRequestSent => 'ส่งคำขอเป็นเพื่อนแล้ว';

  @override
  String get friendRequestAccepted => 'ยอมรับคำขอเป็นเพื่อนแล้ว';

  @override
  String get friendRemoved => 'เพื่อนถูกลบออก';

  @override
  String get noFriends => 'ยังไม่มีเพื่อน';

  @override
  String get noFriendsDesc => 'ค้นหาผู้คนและเพิ่มเป็นเพื่อน';

  @override
  String get noFriendRequests => 'ไม่มีการร้องขอเป็นเพื่อน';

  @override
  String get searchFriends => 'ค้นหาเพื่อน...';

  @override
  String get searchUsers => 'ค้นหาผู้ใช้...';

  @override
  String get groups => 'กลุ่ม';

  @override
  String get createGroup => 'สร้างกลุ่ม';

  @override
  String get groupName => 'ชื่อกลุ่ม';

  @override
  String get groupDescription => 'คำอธิบาย';

  @override
  String get members => 'สมาชิก';

  @override
  String get addMembers => 'เพิ่มสมาชิก';

  @override
  String get removeMember => 'ลบสมาชิก';

  @override
  String get leaveGroup => 'ออกจากกลุ่ม';

  @override
  String get deleteGroup => 'ลบกลุ่ม';

  @override
  String get groupCreated => 'สร้างกลุ่มแล้ว';

  @override
  String get groupUpdated => 'อัปเดตกลุ่มแล้ว';

  @override
  String get groupDeleted => 'ลบกลุ่มแล้ว';

  @override
  String get noGroups => 'ยังไม่มีกลุ่ม';

  @override
  String get noGroupsDesc => 'สร้างกลุ่มเพื่อแชร์บันทึกกับผู้อื่น';

  @override
  String memberCount(int count) {
    return 'สมาชิก $count คน';
  }

  @override
  String get explore => 'สำรวจ';

  @override
  String get exploreDesc => 'ค้นพบบันทึกสาธารณะจากชุมชน';

  @override
  String get trending => 'กำลังมาแรง';

  @override
  String get recent => 'ล่าสุด';

  @override
  String get noExploreResults => 'ยังไม่มีบันทึกสาธารณะ';

  @override
  String get noExploreResultsDesc => 'เป็นคนแรกที่จะแบ่งปันบันทึกกับชุมชน';

  @override
  String get favorites => 'รายการโปรด';

  @override
  String get addToFavorites => 'เพิ่มในรายการโปรด';

  @override
  String get removeFromFavorites => 'ลบออกจากรายการโปรด';

  @override
  String get addedToFavorites => 'เพิ่มในรายการโปรดแล้ว';

  @override
  String get removedFromFavorites => 'ลบออกจากรายการโปรดแล้ว';

  @override
  String get noFavorites => 'ยังไม่มีรายการโปรด';

  @override
  String get noFavoritesDesc => 'แตะไอคอนรูปหัวใจบนบันทึกเพื่อเพิ่มที่นี่';

  @override
  String get trash => 'ขยะ';

  @override
  String get restoreNote => 'คืนค่า';

  @override
  String get deletePermanently => 'ลบอย่างถาวร';

  @override
  String get emptyTrash => 'ถังขยะเปล่า';

  @override
  String get emptyTrashConfirm => 'ลบโน้ตทั้งหมดในถังขยะอย่างถาวรใช่ไหม';

  @override
  String get trashEmpty => 'ถังขยะว่างเปล่า';

  @override
  String get trashEmptyDesc => 'บันทึกที่ถูกลบจะปรากฏที่นี่';

  @override
  String get trashAutoDeleteInfo =>
      'โน้ตในถังขยะจะถูกลบอย่างถาวรหลังจากผ่านไป 30 วัน';

  @override
  String get sharedNotes => 'บันทึกที่ใช้ร่วมกัน';

  @override
  String get sharedWithMe => 'แบ่งปันกับฉัน';

  @override
  String get sharedByMe => 'แบ่งปันโดยฉัน';

  @override
  String get noSharedNotes => 'ไม่มีบันทึกที่ใช้ร่วมกัน';

  @override
  String get noSharedNotesDesc => 'บันทึกที่แชร์กับคุณจะปรากฏที่นี่';

  @override
  String get searchHint => 'ค้นหาบันทึก ผู้คน กลุ่ม...';

  @override
  String get searchNotes => 'ค้นหาหมายเหตุ';

  @override
  String get searchResults => 'ผลการค้นหา';

  @override
  String get noSearchResults => 'ไม่พบผลลัพธ์';

  @override
  String get noSearchResultsDesc => 'ลองใช้คำหลักอื่น';

  @override
  String get recentSearches => 'การค้นหาล่าสุด';

  @override
  String get clearSearchHistory => 'ล้างประวัติการค้นหา';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get appearance => 'รูปร่าง';

  @override
  String get theme => 'ธีม';

  @override
  String get themeLight => 'แสงสว่าง';

  @override
  String get themeDark => 'มืด';

  @override
  String get themeSystem => 'ระบบ';

  @override
  String get language => 'ภาษา';

  @override
  String get languageEnglish => 'ภาษาอังกฤษ';

  @override
  String get languageTurkish => 'ภาษาตุรกี';

  @override
  String get notifications => 'การแจ้งเตือน';

  @override
  String get account => 'บัญชี';

  @override
  String get deleteAccount => 'ลบบัญชี';

  @override
  String get deleteAccountConfirm =>
      'การดำเนินการนี้จะลบบัญชีของคุณและข้อมูลทั้งหมดอย่างถาวร การดำเนินการนี้ไม่สามารถยกเลิกได้';

  @override
  String get aboutApp => 'เกี่ยวกับ นอตไอเดีย';

  @override
  String get version => 'เวอร์ชัน';

  @override
  String get buildNumber => 'สร้าง';

  @override
  String get updateAvailableTitle => 'อัปเดตพร้อมใช้งาน';

  @override
  String get updateAvailableMessage => 'NotIdea เวอร์ชันใหม่พร้อมใช้งานแล้ว';

  @override
  String get updateRequiredTitle => 'จำเป็นต้องอัปเดต';

  @override
  String get updateRequiredMessage => 'คุณต้องอัปเดตเพื่อใช้ NotIdea ต่อไป';

  @override
  String get updateNow => 'อัปเดตทันที';

  @override
  String get updateLater => 'ภายหลัง';

  @override
  String get updateChangelog => 'มีอะไรใหม่';

  @override
  String get openDownloadPage => 'เปิดหน้าดาวน์โหลด';

  @override
  String get legal => 'ถูกกฎหมาย';

  @override
  String get privacyPolicy => 'นโยบายความเป็นส่วนตัว';

  @override
  String get termsOfService => 'ข้อกำหนดในการให้บริการ';

  @override
  String get openSourceLicenses => 'ใบอนุญาตโอเพ่นซอร์ส';

  @override
  String get dangerZone => 'โซนอันตราย';

  @override
  String get changePassword => 'เปลี่ยนรหัสผ่าน';

  @override
  String get logoutConfirm => 'คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?';

  @override
  String get noteColorDefault => 'ค่าเริ่มต้น';

  @override
  String get enterYourEmail => 'ใส่อีเมลของคุณ';

  @override
  String get enterYourPassword => 'ใส่รหัสผ่านของคุณ';

  @override
  String get emailInvalid => 'กรุณากรอกที่อยู่อีเมลที่ถูกต้อง';

  @override
  String get loginSubtitle =>
      'ยินดีต้อนรับกลับมา! ลงชื่อเข้าใช้เพื่อดำเนินการต่อ';

  @override
  String get signUp => 'ลงทะเบียน';

  @override
  String get signupSubtitle => 'สร้างบัญชีเพื่อเริ่มต้น';

  @override
  String get signupSuccess => 'สร้างบัญชีสำเร็จแล้ว!';

  @override
  String get enterDisplayName => 'ป้อนชื่อที่แสดงของคุณ';

  @override
  String get displayNameTooLong => 'ชื่อที่แสดงยาวเกินไป';

  @override
  String get enterUsername => 'กรอกชื่อผู้ใช้ของคุณ';

  @override
  String get createPassword => 'สร้างรหัสผ่าน';

  @override
  String get confirmYourPassword => 'ยืนยันรหัสผ่านของคุณ';

  @override
  String get confirmPasswordRequired => 'กรุณายืนยันรหัสผ่านของคุณ';

  @override
  String get pleaseAcceptTerms => 'กรุณายอมรับข้อกำหนดและเงื่อนไข';

  @override
  String get iAgreeToThe => 'ฉันเห็นด้วยกับ';

  @override
  String get resetPasswordEmailSent => 'ส่งอีเมลรีเซ็ตรหัสผ่านแล้ว';

  @override
  String get send => 'ส่ง';

  @override
  String get and => 'และ';

  @override
  String get bold => 'ตัวหนา';

  @override
  String get italic => 'ตัวเอียง';

  @override
  String get heading => 'หัวเรื่อง';

  @override
  String get link => 'ลิงค์';

  @override
  String get image => 'ภาพ';

  @override
  String get code => 'รหัส';

  @override
  String get quote => 'อ้าง';

  @override
  String get bulletList => 'รายการหัวข้อย่อย';

  @override
  String get numberedList => 'รายการลำดับเลข';

  @override
  String get preview => 'ดูตัวอย่าง';

  @override
  String get startWriting => 'เริ่มเขียน...';

  @override
  String get untitled => 'ไม่มีชื่อ';

  @override
  String get newNote => 'หมายเหตุใหม่';

  @override
  String get noteColor => 'หมายเหตุสี';

  @override
  String get visibility => 'การมองเห็น';

  @override
  String get tagsHint => 'เพิ่มแท็กโดยคั่นด้วยเครื่องหมายจุลภาค';

  @override
  String get unsavedChanges => 'การเปลี่ยนแปลงที่ไม่ได้บันทึก';

  @override
  String get unsavedChangesMessage =>
      'คุณมีการเปลี่ยนแปลงที่ยังไม่ได้บันทึก ทิ้งมันไปเหรอ?';

  @override
  String get discard => 'ทิ้ง';

  @override
  String get errorLoadingNote => 'ไม่สามารถโหลดบันทึกได้';

  @override
  String get noteNotFound => 'ไม่พบหมายเหตุ';

  @override
  String get onlyYouCanSee => 'มีเพียงคุณเท่านั้นที่เห็นสิ่งนี้';

  @override
  String get friendsCanSee => 'เพื่อนของคุณสามารถเห็นสิ่งนี้';

  @override
  String get everyoneCanSee => 'ทุกคนสามารถเห็นสิ่งนี้';

  @override
  String get profileNotFound => 'ไม่พบโปรไฟล์';

  @override
  String get errorLoadingProfile => 'ไม่สามารถโหลดโปรไฟล์ได้';

  @override
  String get deleteAccountConfirmation =>
      'คุณแน่ใจเหรอ? การดำเนินการนี้จะลบบัญชีของคุณอย่างถาวร';

  @override
  String get camera => 'กล้อง';

  @override
  String get gallery => 'แกลเลอรี่';

  @override
  String get avatarUpdated => 'อัปเดตรูปโปรไฟล์แล้ว';

  @override
  String get errorGeneral => 'มีบางอย่างผิดพลาด โปรดลองอีกครั้ง';

  @override
  String get errorNetwork =>
      'ไม่มีการเชื่อมต่ออินเทอร์เน็ต โปรดตรวจสอบเครือข่ายของคุณ';

  @override
  String get errorTimeout => 'คำขอหมดเวลา โปรดลองอีกครั้ง';

  @override
  String get errorUnauthorized => 'เซสชั่นหมดอายุแล้ว กรุณาเข้าสู่ระบบอีกครั้ง';

  @override
  String get errorNotFound => 'ไม่พบทรัพยากรที่ร้องขอ';

  @override
  String get errorServer => 'ข้อผิดพลาดของเซิร์ฟเวอร์ โปรดลองอีกครั้งในภายหลัง';

  @override
  String get errorImageTooLarge => 'รูปภาพมีขนาดใหญ่เกินไป ขนาดสูงสุดคือ 5 MB';

  @override
  String get errorUnsupportedFormat => 'รูปแบบไฟล์ที่ไม่รองรับ';

  @override
  String get errorUploadFailed => 'การอัปโหลดล้มเหลว โปรดลองอีกครั้ง';

  @override
  String get successGeneral => 'การดำเนินการเสร็จสมบูรณ์เรียบร้อยแล้ว';

  @override
  String get successSaved => 'บันทึกเรียบร้อยแล้ว';

  @override
  String get successDeleted => 'ลบเรียบร้อยแล้ว';

  @override
  String get successUpdated => 'อัปเดตเรียบร้อยแล้ว';

  @override
  String get successCopied => 'คัดลอกไปยังคลิปบอร์ดแล้ว';

  @override
  String get timeAgoNow => 'แค่ตอนนี้';

  @override
  String timeAgoMinutes(int minutes) {
    return '$minutes นาทีที่แล้ว';
  }

  @override
  String timeAgoHours(int hours) {
    return '$hours ชั่วโมงที่ผ่านมา';
  }

  @override
  String timeAgoDays(int days) {
    return '$days วันที่ผ่านมา';
  }

  @override
  String get markdownBold => 'ตัวหนา';

  @override
  String get markdownItalic => 'ตัวเอียง';

  @override
  String get markdownHeading => 'หัวเรื่อง';

  @override
  String get markdownList => 'รายการ';

  @override
  String get markdownLink => 'ลิงค์';

  @override
  String get markdownImage => 'ภาพ';

  @override
  String get markdownCode => 'รหัส';

  @override
  String get markdownQuote => 'อ้าง';

  @override
  String get markdownPreview => 'ดูตัวอย่าง';

  @override
  String get markdownEditor => 'บรรณาธิการ';

  @override
  String get shareNote => 'แบ่งปันหมายเหตุ';

  @override
  String get shareViaLink => 'แชร์ผ่านลิงก์';

  @override
  String get copyLink => 'คัดลอกลิงค์';

  @override
  String get linkCopied => 'คัดลอกลิงก์ไปยังคลิปบอร์ดแล้ว';

  @override
  String get selectFriends => 'เลือกเพื่อน';

  @override
  String get selectGroups => 'เลือกกลุ่ม';

  @override
  String get currentShares => 'หุ้นปัจจุบัน';

  @override
  String get removeShare => 'ลบการแชร์';

  @override
  String get shareWithFriends => 'แบ่งปันกับเพื่อน';

  @override
  String get shareWithGroups => 'แบ่งปันกับกลุ่ม';

  @override
  String get viewerRole => 'ผู้ดู';

  @override
  String get editorRole => 'บรรณาธิการ';

  @override
  String get add => 'เพิ่ม';

  @override
  String get permissionUpdated => 'อัปเดตสิทธิ์แล้ว';

  @override
  String get editGroup => 'แก้ไขกลุ่ม';

  @override
  String get owner => 'เจ้าของ';

  @override
  String get admin => 'ผู้ดูแลระบบ';

  @override
  String get groupNotes => 'หมายเหตุกลุ่ม';

  @override
  String get selectMembers => 'เลือกสมาชิก';

  @override
  String get groupNameRequired => 'ต้องระบุชื่อกลุ่ม';

  @override
  String get noMembersYet => 'ยังไม่มีสมาชิก';

  @override
  String get confirmRemoveFriend => 'คุณแน่ใจหรือไม่ว่าต้องการลบเพื่อนรายนี้';

  @override
  String get confirmLeaveGroup => 'คุณแน่ใจหรือไม่ว่าต้องการออกจากกลุ่มนี้?';

  @override
  String get confirmDeleteGroup =>
      'คุณแน่ใจหรือไม่ว่าต้องการลบกลุ่มนี้ การดำเนินการนี้ไม่สามารถยกเลิกได้';

  @override
  String get alreadyFriends => 'เป็นเพื่อนกันแล้ว';

  @override
  String get requestPending => 'คำขอที่รอดำเนินการ';

  @override
  String get statusFriend => 'เพื่อน';

  @override
  String get statusPending => 'รอดำเนินการ';

  @override
  String get visibilityFriends => 'เพื่อนเท่านั้น';

  @override
  String sharedByUser(String name) {
    return 'แบ่งปันโดย $name';
  }

  @override
  String deletedAtDate(String date) {
    return 'ลบแล้ว __วันที่__';
  }

  @override
  String get notesTab => 'หมายเหตุ';

  @override
  String get usersTab => 'ผู้ใช้';

  @override
  String get publicTab => 'สาธารณะ';

  @override
  String get noNotesYet => 'ยังไม่มีบันทึก';

  @override
  String get createFirstNote => 'แตะ + เพื่อสร้างบันทึกแรกของคุณ';

  @override
  String get errorLoadingNotes => 'ไม่สามารถโหลดบันทึกได้';

  @override
  String get deleteNoteConfirmation => 'คุณแน่ใจหรือไม่ว่าต้องการลบบันทึกนี้';

  @override
  String get filterBy => 'กรองตาม';

  @override
  String get dateModified => 'วันที่แก้ไข';

  @override
  String get dateCreated => 'วันที่สร้าง';

  @override
  String get titleLabel => 'ชื่อ';

  @override
  String get privateNotes => 'ส่วนตัว';

  @override
  String get publicNotes => 'สาธารณะ';

  @override
  String get friendsNotes => 'เพื่อน';

  @override
  String get clearFilters => 'ล้างตัวกรอง';

  @override
  String get groupSharedNotes => 'บันทึกที่ใช้ร่วมกันของกลุ่ม';

  @override
  String get completeYourProfile => 'กรอกโปรไฟล์ของคุณให้สมบูรณ์';

  @override
  String get profileSetupSubtitle => 'เพิ่มรายละเอียดของคุณเพื่อเริ่มต้น';

  @override
  String get tapToAddPhoto => 'แตะเพื่อเพิ่มรูปโปรไฟล์';

  @override
  String get getStarted => 'เริ่มต้นเลย';

  @override
  String get checkEmailToConfirm =>
      'โปรดตรวจสอบอีเมลของคุณเพื่อยืนยันบัญชีของคุณ จากนั้นเข้าสู่ระบบ';

  @override
  String get usernameTaken => 'ชื่อผู้ใช้นี้ถูกใช้ไปแล้ว';

  @override
  String get checkingUsername => 'กำลังตรวจสอบห้องว่าง...';

  @override
  String get resetChanges => 'รีเซ็ตการเปลี่ยนแปลง';

  @override
  String get resetConfirmTitle => 'รีเซ็ตการเปลี่ยนแปลง?';

  @override
  String get resetConfirmMessage =>
      'การเปลี่ยนแปลงที่ไม่ได้บันทึกทั้งหมดจะสูญหาย คุณแน่ใจเหรอ?';

  @override
  String get readOnlyPermission => 'อ่านอย่างเดียว';

  @override
  String get readWritePermission => 'อ่านและเขียน';

  @override
  String get selectPermission => 'เลือกการอนุญาต';

  @override
  String get shareViaSocial => 'แบ่งปันผ่านโซเชียลมีเดีย';

  @override
  String get notePinned => 'ปักหมุดหมายเหตุแล้ว';

  @override
  String get noteUnpinned => 'เลิกปักหมุดหมายเหตุแล้ว';

  @override
  String get notePermanentlyDeleted => 'หมายเหตุถูกลบอย่างถาวร';

  @override
  String get movedToTrash => 'ย้ายไปถังขยะแล้ว';

  @override
  String get noteInfo => 'ข้อมูลหมายเหตุ';

  @override
  String wordCount(int count) {
    return 'จำนวนคำ: $count';
  }

  @override
  String get fontFamilyTitle => 'รูปแบบตัวอักษร';

  @override
  String get fontDefault => 'ค่าเริ่มต้น (ระบบ)';

  @override
  String get fontSerif => 'เซริฟ';

  @override
  String get fontMonospace => 'โมโนสเปซ';

  @override
  String get fontCursive => 'เล่นหาง';

  @override
  String get newPassword => 'รหัสผ่านใหม่';

  @override
  String get required => 'ที่จำเป็น';

  @override
  String get passwordUppercase =>
      'รหัสผ่านต้องมีอักษรตัวพิมพ์ใหญ่อย่างน้อยหนึ่งตัว';

  @override
  String get passwordLowercase =>
      'รหัสผ่านต้องมีตัวอักษรพิมพ์เล็กอย่างน้อยหนึ่งตัว';

  @override
  String get passwordDigit => 'รหัสผ่านต้องมีตัวเลขอย่างน้อยหนึ่งตัว';

  @override
  String get imageLabel => 'ภาพ';

  @override
  String get clearAll => 'ล้างทั้งหมด';
}
