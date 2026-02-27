import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:notidea/core/constants/app_constants.dart';
import 'package:notidea/core/utils/extensions.dart';
import 'package:notidea/core/utils/validators.dart';
import 'package:notidea/features/auth/presentation/providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = false;
  bool _isSigningUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;

    if (!_acceptedTerms) {
      context.showInfo(l10n.pleaseAcceptTerms);
      return;
    }

    setState(() => _isSigningUp = true);
    try {
      await ref.read(signupProvider.notifier).execute(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      if (!mounted) return;

      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        context.go('/profile-setup');
      } else {
        context.showInfo(l10n.checkEmailToConfirm);
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSigningUp = false);
        context.showError(e);
      }
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isLoading = _isSigningUp;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: AutofillGroup(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),

                    Center(
                      child: SvgPicture.asset(
                        'assets/images/logo.svg',
                        width: 72,
                        height: 72,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: SvgPicture.asset(
                        'assets/images/notidea.svg',
                        width: 150,
                        colorFilter: theme.brightness == Brightness.dark
                            ? ColorFilter.mode(
                                theme.colorScheme.onSurface,
                                BlendMode.srcIn,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.center,
                      autofillHints: const [AutofillHints.email],
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        labelText: l10n.email,
                        hintText: l10n.enterYourEmail,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      validator: (value) => Validators.email(value, l10n),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.center,
                      autofillHints: const [AutofillHints.newPassword],
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        labelText: l10n.password,
                        hintText: l10n.createPassword,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          tooltip: _obscurePassword ? 'Show password' : 'Hide password',
                          onPressed: () {
                            setState(
                                () => _obscurePassword = !_obscurePassword);
                          },
                        ),
                      ),
                      validator: (value) => Validators.password(value, l10n),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      textInputAction: TextInputAction.done,
                      textAlign: TextAlign.center,
                      autofillHints: const [AutofillHints.newPassword],
                      enabled: !isLoading,
                      onFieldSubmitted: (_) => _handleSignup(),
                      decoration: InputDecoration(
                        labelText: l10n.confirmPassword,
                        hintText: l10n.confirmYourPassword,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          tooltip: _obscureConfirmPassword ? 'Show password' : 'Hide password',
                          onPressed: () {
                            setState(() => _obscureConfirmPassword =
                                !_obscureConfirmPassword);
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.confirmPasswordRequired;
                        }
                        if (value != _passwordController.text) {
                          return l10n.passwordsDoNotMatch;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: _acceptedTerms,
                            onChanged: isLoading
                                ? null
                                : (value) {
                                    setState(
                                        () => _acceptedTerms = value ?? false);
                                  },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                l10n.iAgreeToThe,
                                style: theme.textTheme.bodySmall,
                              ),
                              const SizedBox(width: 3),
                              GestureDetector(
                                onTap: () => _openUrl(
                                    'https://www.notidea.ersel.dev/app-terms'),
                                child: Text(
                                  l10n.termsOfService,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                ' ${l10n.and} ',
                                style: theme.textTheme.bodySmall,
                              ),
                              GestureDetector(
                                onTap: () => _openUrl(
                                    'https://www.notidea.ersel.dev/app-privacy'),
                                child: Text(
                                  l10n.privacyPolicy,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    FilledButton(
                      onPressed: isLoading ? null : _handleSignup,
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
                              l10n.signUp,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.alreadyHaveAccount,
                          style: theme.textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: isLoading ? null : () => context.pop(),
                          child: Text(
                            l10n.login,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
