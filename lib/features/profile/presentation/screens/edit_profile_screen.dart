import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:notidea/core/constants/app_constants.dart';
import 'package:notidea/features/auth/presentation/providers/auth_provider.dart';
import 'package:notidea/features/profile/presentation/providers/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  bool _isInitialized = false;
  bool _isUploadingAvatar = false;
  bool _isSavingProfile = false;
  bool _isCheckingUsername = false;
  bool _usernameTaken = false;
  Timer? _usernameDebounce;
  String? _originalUsername;

  static String? _extensionFromMime(String? mime) {
    if (mime == null) return null;
    const map = {
      'image/jpeg': 'jpg',
      'image/png': 'png',
      'image/webp': 'webp',
      'image/gif': 'gif',
    };
    return map[mime.toLowerCase()];
  }

  static String? _extensionFromPath(String path) {
    final ext = path.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png', 'webp', 'gif'].contains(ext)) return ext;
    return null;
  }
  String? _currentAvatarUrl;

  @override
  void dispose() {
    _usernameDebounce?.cancel();
    _displayNameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _onUsernameChanged(String value) {
    _usernameDebounce?.cancel();
    final trimmed = value.trim();

    if (trimmed == _originalUsername) {
      setState(() {
        _isCheckingUsername = false;
        _usernameTaken = false;
      });
      return;
    }

    if (trimmed.length < AppConstants.minUsernameLength) {
      setState(() {
        _isCheckingUsername = false;
        _usernameTaken = false;
      });
      return;
    }

    setState(() => _isCheckingUsername = true);
    _usernameDebounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        final currentUser = await ref.read(currentUserProvider.future);
        final repo = ref.read(profileRepositoryProvider);
        final taken = await repo.isUsernameTaken(
          trimmed,
          excludeUserId: currentUser?.id,
        );
        if (mounted) {
          setState(() {
            _usernameTaken = taken;
            _isCheckingUsername = false;
          });
        }
      } catch (_) {
        if (mounted) setState(() => _isCheckingUsername = false);
      }
    });
  }

  Future<void> _pickAvatar() async {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: Text(l10n.camera),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.gallery),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );

    if (source == null) return;

    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (file == null) return;

    final currentUser = await ref.read(currentUserProvider.future);
    if (currentUser == null) return;

    final bytes = await file.readAsBytes();
    final mimeType = file.mimeType;
    final ext = _extensionFromMime(mimeType) ??
        _extensionFromPath(file.path) ??
        'jpg';

    setState(() => _isUploadingAvatar = true);
    try {
      final url = await ref.read(uploadAvatarProvider.notifier).execute(
            userId: currentUser.id,
            bytes: bytes,
            fileExtension: ext,
          );

      if (mounted) {
        setState(() {
          _currentAvatarUrl = url;
          _isUploadingAvatar = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.avatarUpdated)),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isUploadingAvatar = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    final profile = ref.read(currentProfileProvider).value;
    if (profile == null) return;

    final updated = profile.copyWith(
      displayName: _displayNameController.text.trim(),
      username: _usernameController.text.trim(),
      bio: _bioController.text.trim().isEmpty
          ? null
          : _bioController.text.trim(),
    );

    setState(() => _isSavingProfile = true);
    try {
      await ref.read(updateProfileProvider.notifier).execute(updated);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.profileUpdated)),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSavingProfile = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _confirmDeleteAccount() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteAccount),
        content: Text(l10n.deleteAccountConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final currentUser =
                  await ref.read(currentUserProvider.future);
              if (currentUser == null) return;

              await ref
                  .read(deleteAccountProvider.notifier)
                  .execute(currentUser.id);

              await ref.read(logoutProvider.notifier).execute();

              if (mounted) {
                context.go('/login');
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final profileAsync = ref.watch(currentProfileProvider);
    final isLoading = _isSavingProfile || _isUploadingAvatar;

    profileAsync.whenData((profile) {
      if (profile != null && !_isInitialized) {
        _displayNameController.text = profile.displayName ?? '';
        _usernameController.text = profile.username;
        _originalUsername = profile.username;
        _bioController.text = profile.bio ?? '';
        _currentAvatarUrl = profile.avatarUrl;
        _isInitialized = true;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editProfile),
        actions: [
          TextButton(
            onPressed: isLoading ? null : _saveProfile,
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.save),
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (profile) {
          if (profile == null) {
            return Center(child: Text(l10n.profileNotFound));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Avatar
                  GestureDetector(
                    onTap: isLoading ? null : _pickAvatar,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: AppConstants.avatarSizeXLarge / 2,
                          backgroundColor:
                              theme.colorScheme.surfaceContainerHighest,
                          backgroundImage: _currentAvatarUrl != null
                              ? CachedNetworkImageProvider(
                                  _currentAvatarUrl!)
                              : null,
                          child: _currentAvatarUrl == null
                              ? Icon(
                                  Icons.person,
                                  size: AppConstants.avatarSizeXLarge / 2,
                                  color:
                                      theme.colorScheme.onSurfaceVariant,
                                )
                              : null,
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.surface,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Display Name
                  TextFormField(
                    controller: _displayNameController,
                    textCapitalization: TextCapitalization.words,
                    enabled: !isLoading,
                    decoration: InputDecoration(
                      labelText: l10n.displayName,
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.displayNameRequired;
                      }
                      if (value.trim().length >
                          AppConstants.maxDisplayNameLength) {
                        return l10n.displayNameTooLong;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Username
                  TextFormField(
                    controller: _usernameController,
                    enabled: !isLoading,
                    onChanged: _onUsernameChanged,
                    decoration: InputDecoration(
                      labelText: l10n.username,
                      prefixIcon: const Icon(Icons.alternate_email),
                      suffixIcon: _isCheckingUsername
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : _usernameController.text.trim().length >=
                                      AppConstants.minUsernameLength &&
                                  !_usernameTaken &&
                                  _usernameController.text.trim() != _originalUsername
                              ? const Icon(Icons.check_circle, color: Colors.green)
                              : _usernameTaken
                                  ? Icon(Icons.cancel, color: theme.colorScheme.error)
                                  : null,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.usernameRequired;
                      }
                      if (value.trim().length <
                          AppConstants.minUsernameLength) {
                        return l10n.usernameTooShort;
                      }
                      if (value.trim().length >
                          AppConstants.maxUsernameLength) {
                        return l10n.usernameTooLong;
                      }
                      if (!RegExp(r'^[a-zA-Z0-9_]+$')
                          .hasMatch(value.trim())) {
                        return l10n.usernameInvalid;
                      }
                      if (_usernameTaken) {
                        return l10n.usernameTaken;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Bio
                  TextFormField(
                    controller: _bioController,
                    maxLines: 3,
                    maxLength: AppConstants.maxBioLength,
                    enabled: !isLoading,
                    decoration: InputDecoration(
                      labelText: l10n.bio,
                      prefixIcon: const Icon(Icons.info_outline),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Delete Account
                  OutlinedButton.icon(
                    onPressed: isLoading ? null : _confirmDeleteAccount,
                    icon: Icon(
                      Icons.delete_forever_outlined,
                      color: theme.colorScheme.error,
                    ),
                    label: Text(
                      l10n.deleteAccount,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      side: BorderSide(color: theme.colorScheme.error),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
