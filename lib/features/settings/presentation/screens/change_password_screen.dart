import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notidea/core/constants/app_constants.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:notidea/core/utils/extensions.dart';
import 'package:notidea/shared/widgets/app_scaffold.dart';
import 'package:notidea/features/settings/presentation/providers/change_password_provider.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;
    
    await ref.read(changePasswordProvider.notifier).execute(_newPasswordController.text);
    
    if (!context.mounted) return;
    
    final state = ref.read(changePasswordProvider);
    if (state.hasError) {
      context.showError(state.error);
    } else {
      context.showSuccess(l10n.successUpdated);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(changePasswordProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.changePassword),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _obscureNew,
                  decoration: InputDecoration(
                    labelText: l10n.newPassword,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureNew ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscureNew = !_obscureNew),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return l10n.required;
                    if (value.length < AppConstants.minPasswordLength) {
                      return l10n.passwordTooShort;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirm,
                  decoration: InputDecoration(
                    labelText: l10n.confirmPassword,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return l10n.required;
                    if (value != _newPasswordController.text) return l10n.passwordsDoNotMatch;
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: state.isLoading ? null : _submit,
                  child: state.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.save),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
