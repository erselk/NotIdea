import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:notidea/core/constants/app_constants.dart';
import 'package:notidea/features/auth/presentation/providers/auth_provider.dart';
import 'package:notidea/features/profile/presentation/providers/profile_provider.dart';
import 'package:notidea/features/profile/domain/models/profile_model.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _usernameController = TextEditingController();
  String? _avatarUrl;
  bool _isUploading = false;
  bool _isCreating = false;
  bool _isCheckingUsername = false;
  bool _usernameTaken = false;
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

  @override
  void dispose() {
    _usernameDebounce?.cancel();
    _displayNameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _onUsernameChanged(String value) {
    _usernameDebounce?.cancel();
    final trimmed = value.trim();
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
        final repo = ref.read(profileRepositoryProvider);
        final taken = await repo.isUsernameTaken(trimmed);
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
              title: const Text('Camera'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Gallery'),
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

    setState(() => _isUploading = true);

    final bytes = await file.readAsBytes();
    final mimeType = file.mimeType;
    final ext = _extensionFromMime(mimeType) ??
        _extensionFromPath(file.path) ??
        'jpg';

    try {
      final url = await ref.read(uploadAvatarProvider.notifier).execute(
            userId: currentUser.id,
            bytes: bytes,
            fileExtension: ext,
          );

      if (mounted) {
        setState(() {
          _avatarUrl = url;
          _isUploading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<void> _completeSetup() async {
    if (!_formKey.currentState!.validate()) return;

    final currentUser = await ref.read(currentUserProvider.future);
    if (currentUser == null) return;

    setState(() => _isCreating = true);

    try {
      final profile = ProfileModel(
        id: currentUser.id,
        username: _usernameController.text.trim(),
        displayName: _displayNameController.text.trim(),
        avatarUrl: _avatarUrl,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await ref.read(createProfileProvider.notifier).execute(profile);

      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isCreating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isLoading = _isCreating || _isUploading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),

                  Text(
                    l10n.completeYourProfile,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.profileSetupSubtitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 40),

                  Center(
                    child: GestureDetector(
                      onTap: isLoading ? null : _pickAvatar,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 56,
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHighest,
                            backgroundImage: _avatarUrl != null
                                ? NetworkImage(_avatarUrl!)
                                : null,
                            child: _isUploading
                                ? const CircularProgressIndicator(
                                    strokeWidth: 2)
                                : _avatarUrl == null
                                    ? Icon(
                                        Icons.person,
                                        size: 56,
                                        color: theme
                                            .colorScheme.onSurfaceVariant,
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
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.tapToAddPhoto,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 32),

                  TextFormField(
                    controller: _displayNameController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    textAlign: TextAlign.center,
                    autofillHints: const [AutofillHints.name],
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

                  TextFormField(
                    controller: _usernameController,
                    textInputAction: TextInputAction.done,
                    textAlign: TextAlign.center,
                    autofillHints: const [AutofillHints.username],
                    enabled: !isLoading,
                    onChanged: _onUsernameChanged,
                    onFieldSubmitted: (_) => _completeSetup(),
                    decoration: InputDecoration(
                      labelText: l10n.username,
                      hintText: l10n.enterUsername,
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
                                !_usernameTaken
                              ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
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
                  const SizedBox(height: 32),

                  FilledButton(
                    onPressed: isLoading ? null : _completeSetup,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.onPrimary,
                            ),
                          )
                        : Text(
                            l10n.getStarted,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
