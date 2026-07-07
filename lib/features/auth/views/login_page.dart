import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_router.dart';
import '../../../theme/theme.dart';
import '../view_models/auth_notifier.dart';

/// Email / password sign-in screen, reached from the splash welcome CTA.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    try {
      await ref
          .read(authProvider.notifier)
          .login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
      if (!mounted) return;
      const HomeRootRoute().go(context);
    } catch (_) {
      // Handled via the AsyncError state read in build().
    }
  }

  void _forgotPassword() {
    // TODO: navigate to the password-reset flow.
  }

  void _createAccount() {
    // TODO: navigate to the account-creation flow.
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final loading = authState.isLoading;
    final errorText = authState is AsyncError ? _loginErrorText() : null;

    return Scaffold(
      backgroundColor: FigmaColors.pageBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageHorizontal,
          ),
          // Freeze the form while a sign-in request is in flight so the user
          // can't edit fields or fire a second login attempt.
          child: AbsorbPointer(
            absorbing: loading,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 94),
                    child: Center(
                      child: _AuthForm(
                        emailController: _emailController,
                        passwordController: _passwordController,
                        obscurePassword: _obscurePassword,
                        onToggleObscure: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        loading: loading,
                        errorText: errorText,
                        onSubmit: _login,
                        onForgotPassword: _forgotPassword,
                      ),
                    ),
                  ),
                ),
                _CreateAccountRow(onCreateAccount: _createAccount),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _loginErrorText() {
    // The repository surfaces API/validation failures; keep the copy generic
    // so we don't leak backend detail to the sign-in screen.
    return 'Sign-in failed. Check your email and password and try again.';
  }
}

class _AuthForm extends StatelessWidget {
  const _AuthForm({
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.loading,
    required this.errorText,
    required this.onSubmit,
    required this.onForgotPassword,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final bool loading;
  final String? errorText;
  final VoidCallback onSubmit;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(
            Icons.auto_awesome,
            color: FigmaColors.brandSecondary,
            size: 28,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Welcome TAO pulse',
            textAlign: TextAlign.center,
            style: FigmaTypography.h4Semibold.copyWith(
              color: FigmaColors.textNeutralPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Your Bittensor network, at a glance.',
            textAlign: TextAlign.center,
            style: FigmaTypography.bodySmallRegular.copyWith(
              color: FigmaColors.textNeutralSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          _AuthTextField(
            controller: emailController,
            hintText: 'Email Address',
            icon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.md),
          _AuthTextField(
            controller: passwordController,
            hintText: 'Password',
            icon: Icons.key_outlined,
            obscureText: obscurePassword,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => onSubmit(),
            suffixIcon: IconButton(
              onPressed: onToggleObscure,
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: FigmaColors.iconNeutralSecondary,
                size: 20,
              ),
            ),
          ),
          if (errorText != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              errorText!,
              style: FigmaTypography.bodySmallRegular.copyWith(
                color: FigmaColors.textErrorSubtle,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: onForgotPassword,
              behavior: HitTestBehavior.opaque,
              child: Text(
                'Forgot Password?',
                style: FigmaTypography.bodySmallMedium.copyWith(
                  color: FigmaColors.textNeutralSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: loading ? null : onSubmit,
            style: FilledButton.styleFrom(
              backgroundColor: FigmaColors.brandPrimary,
              foregroundColor: FigmaColors.neutralPrimary,
              disabledBackgroundColor: FigmaColors.brandPrimary,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: const StadiumBorder(),
              textStyle: FigmaTypography.bodyRegularSemibold,
            ),
            child: loading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: FigmaColors.neutralPrimary,
                    ),
                  )
                : const Text('Log In'),
          ),
        ],
      ),
    );
  }
}

class _AuthTextField extends StatelessWidget {
  const _AuthTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.suffixIcon,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? suffixIcon;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(AppRadius.button));

    OutlineInputBorder border(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      onSubmitted: onSubmitted,
      style: FigmaTypography.bodyRegularRegular.copyWith(
        color: FigmaColors.textNeutralPrimary,
      ),
      cursorColor: FigmaColors.brandPrimary,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: FigmaTypography.bodyRegularRegular.copyWith(
          color: FigmaColors.textNeutralTertiary,
        ),
        prefixIcon: Icon(
          icon,
          color: FigmaColors.iconNeutralSecondary,
          size: 20,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: FigmaColors.neutralPrimary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: 18,
        ),
        enabledBorder: border(FigmaColors.borderNeutralInversePrimary),
        border: border(FigmaColors.borderNeutralInversePrimary),
        focusedBorder: border(FigmaColors.brandPrimary, 1.5),
      ),
    );
  }
}

class _CreateAccountRow extends StatelessWidget {
  const _CreateAccountRow({required this.onCreateAccount});

  final VoidCallback onCreateAccount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.xl),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Didn't have an account? ",
            style: FigmaTypography.bodySmallRegular.copyWith(
              color: FigmaColors.textNeutralSecondary,
            ),
          ),
          GestureDetector(
            onTap: onCreateAccount,
            behavior: HitTestBehavior.opaque,
            child: Text(
              'Create Account',
              style: FigmaTypography.bodySmallSemibold.copyWith(
                color: FigmaColors.brandSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
