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
  String? _currentAvatarUrl;

  @override
  void dispose() {
    _displayNameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
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
    final ext = file.path.split('.').last.toLowerCase();

    final url = await ref.read(uploadAvatarProvider.notifier).execute(
          userId: currentUser.id,
          bytes: bytes,
          fileExtension: ext,
        );

    if (url != null && mounted) {
      setState(() => _currentAvatarUrl = url);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.avatarUpdated)),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    final profile = ref.read(currentProfileProvider).valueOrNull;
    if (profile == null) return;

    final updated = profile.copyWith(
      displayName: _displayNameController.text.trim(),
      username: _usernameController.text.trim(),
      bio: _bioController.text.trim().isEmpty
          ? null
          : _bioController.text.trim(),
    );

    await ref.read(updateProfileProvider.notifier).execute(updated);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.profileUpdated)),
      );
      context.pop();
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
    final updateState = ref.watch(updateProfileProvider);
    final uploadState = ref.watch(uploadAvatarProvider);

    final isLoading = updateState.isLoading || uploadState.isLoading;

    // Initialize fields from profile data
    profileAsync.whenData((profile) {
      if (profile != null && !_isInitialized) {
        _displayNameController.text = profile.displayName ?? '';
        _usernameController.text = profile.username;
        _bioController.text = profile.bio ?? '';
        _currentAvatarUrl = profile.avatarUrl;
        _isInitialized = true;
      }
    });

    ref.listen(updateProfileProvider, (prev, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: theme.colorScheme.error,
          ),
        );
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
                    decoration: InputDecoration(
                      labelText: l10n.username,
                      prefixIcon: const Icon(Icons.alternate_email),
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
