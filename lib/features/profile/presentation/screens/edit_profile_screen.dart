import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:notidea/core/constants/app_constants.dart';
import 'package:notidea/core/utils/extensions.dart';
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
  final _emailController = TextEditingController();
  final _bioController = TextEditingController();
  bool _isInitialized = false;
  bool _isUploadingAvatar = false;
  bool _isSavingProfile = false;
  Timer? _usernameDebounce;

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
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  // Removed _onUsernameChanged since username is now read-only.

  Future<void> _pickAvatar() async {
    final l10n = AppLocalizations.of(context)!;

    final choice = await showModalBottomSheet<String>(
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
              onTap: () => Navigator.pop(ctx, 'camera'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.gallery),
              onTap: () => Navigator.pop(ctx, 'gallery'),
            ),
            if (_currentAvatarUrl != null)
              ListTile(
                leading: Icon(Icons.delete_outline, color: Theme.of(ctx).colorScheme.error),
                title: Text(l10n.removeAvatar, style: TextStyle(color: Theme.of(ctx).colorScheme.error)),
                onTap: () => Navigator.pop(ctx, 'remove'),
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );

    if (choice == null) return;
    if (choice == 'remove') {
      final profile = ref.read(currentProfileProvider).value;
      if (profile == null) return;
      setState(() => _isUploadingAvatar = true);
      try {
        await ref.read(updateProfileProvider.notifier).execute(profile.copyWith(avatarUrl: null));
        if (mounted) {
          setState(() {
            _currentAvatarUrl = null;
            _isUploadingAvatar = false;
          });
          context.showSuccess(l10n.avatarUpdated);
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isUploadingAvatar = false);
          context.showError(e);
        }
      }
      return;
    }
    final source = choice == 'camera' ? ImageSource.camera : ImageSource.gallery;

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
        context.showSuccess(l10n.avatarUpdated);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isUploadingAvatar = false);
        context.showError(e);
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
      bio: _bioController.text.trim().isEmpty
          ? null
          : _bioController.text.trim(),
    );

    setState(() => _isSavingProfile = true);
    try {
      await ref.read(updateProfileProvider.notifier).execute(updated);

      if (mounted) {
        context.showSuccess(l10n.profileUpdated);
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSavingProfile = false);
        context.showError(e);
      }
    }
  }

  // Removed _confirmDeleteAccount as requested.

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final profileAsync = ref.watch(currentProfileProvider);
    final isLoading = _isSavingProfile || _isUploadingAvatar;

    final userAsync = ref.watch(currentUserProvider);

    profileAsync.whenData((profile) {
      if (profile != null && !_isInitialized) {
        _displayNameController.text = profile.displayName ?? '';
        _usernameController.text = profile.username;
        _bioController.text = profile.bio ?? '';
        _currentAvatarUrl = profile.avatarUrl;

        // Fetch email from userAsync
        userAsync.whenData((user) {
          if (user != null) {
            _emailController.text = user.email;
          }
        });

        _isInitialized = true;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editProfile),
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
                    textAlign: TextAlign.center,
                    enabled: !isLoading,
                    decoration: InputDecoration(
                      labelText: l10n.displayName,
                      hintText: l10n.enterDisplayName,
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

                  // Email (Read-only)
                  TextFormField(
                    controller: _emailController,
                    readOnly: true,
                    enabled: false,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: l10n.email,
                      prefixIcon: const Icon(Icons.email_outlined),
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Username (Read-only)
                  TextFormField(
                    controller: _usernameController,
                    readOnly: true,
                    enabled: false,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: l10n.username,
                      prefixIcon: const Icon(Icons.alternate_email),
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    ),
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

                  // Save Button
                  FilledButton(
                    onPressed: isLoading ? null : _saveProfile,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.onPrimary,
                            ),
                          )
                        : Text(
                            l10n.save,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
