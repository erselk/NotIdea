import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_version_model.freezed.dart';
part 'app_version_model.g.dart';

@freezed
sealed class AppVersionModel with _$AppVersionModel {
  const AppVersionModel._();

  const factory AppVersionModel({
    required String id,
    required String platform,
    required String version,
    @JsonKey(name: 'min_supported_version') required String minSupportedVersion,
    @JsonKey(name: 'download_url') required String downloadUrl,
    @JsonKey(name: 'force_update') @Default(false) bool forceUpdate,
    @JsonKey(name: 'changelog_tr') String? changelogTr,
    @JsonKey(name: 'changelog_en') String? changelogEn,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _AppVersionModel;

  bool get hasChangelog {
    final text = (changelogTr ?? changelogEn ?? '').trim();
    return text.isNotEmpty;
  }

  factory AppVersionModel.fromJson(Map<String, dynamic> json) =>
      _$AppVersionModelFromJson(json);
}

