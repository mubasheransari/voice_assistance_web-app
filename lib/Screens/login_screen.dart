import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:voice_assistant_project/Screens/sales_survery_screen.dart';
import 'package:voice_assistant_project/Theme/theme.dart';
import 'package:voice_assistant_project/Screens/home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int tab = 0;
  var storage = GetStorage();

  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();

  final _loginEmailCtrl = TextEditingController();
  final _loginPassCtrl = TextEditingController();

  final _signupNameCtrl = TextEditingController();
  final _signupEmailCtrl = TextEditingController();
  final _signupPhoneCtrl = TextEditingController();
  final _signupPassCtrl = TextEditingController();
  final _signupConfirmCtrl = TextEditingController();

  bool _loginObscure = true;
  bool _signupObscure = true;
  bool _signupConfirmObscure = true;

  bool _loginLoading = false;
  bool _signupLoading = false;

  @override
  void dispose() {
    _loginEmailCtrl.dispose();
    _loginPassCtrl.dispose();
    _signupNameCtrl.dispose();
    _signupEmailCtrl.dispose();
    _signupPhoneCtrl.dispose();
    _signupPassCtrl.dispose();
    _signupConfirmCtrl.dispose();
    super.dispose();
  }

  // ----------------- validators -----------------
  String? _validateEmail(String? v) {
    final s = v?.trim() ?? '';
    if (s.isEmpty) return 'Email is required';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(s);
    return ok ? null : 'Enter a valid email';
  }

  String? _validatePassword(String? v) {
    final s = v ?? '';
    if (s.isEmpty) return 'Password is required';
    if (s.length < 6) return 'Use at least 6 characters';
    return null;
  }

  String? _validateName(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Name is required';
    if (s.length < 2) return 'Enter a valid name';
    return null;
  }

  String? _validatePhone(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Phone is required';
    if (s.length < 8) return 'Enter a valid phone number';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v == null || v.isEmpty) return 'Confirm your password';
    if (v != _signupPassCtrl.text) return 'Passwords do not match';
    return null;
  }

  // ----------------- LOGIN (HARDCODED) -----------------
  Future<void> _submitLogin() async {
    final form = _loginFormKey.currentState;
    if (form == null) return;
    FocusScope.of(context).unfocus();
    if (!form.validate()) return;

    setState(() => _loginLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loginLoading = false);

    if (!mounted) return;

    final email = _loginEmailCtrl.text.trim();
    final password = _loginPassCtrl.text;

    if (email == 'testuser@gmail.com' && password == 'Testing@123') {
      storage.write("user", 1);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else if (email == 'testsurvery@gmail.com' && password == 'Testing@123') {
      storage.write("supervisor", 2);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SurveyScreenView()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password'),
        ),
      );
    }
  }

  Future<void> _submitSignup() async {
    final form = _signupFormKey.currentState;
    if (form == null) return;
    FocusScope.of(context).unfocus();
    if (!form.validate()) return;

    setState(() => _signupLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // TODO: hook API
    setState(() => _signupLoading = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account created! (wire your API here)')),
    );

    setState(() => tab = 0);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white
          // gradient: LinearGradient(
          //   colors: [
          //     Color(0xFF0B0B14),
          //     Color(0xFF1E1235),
          //   ],
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          // ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 440,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/mezan_tea-removebg-preview.png'),
                    // ---------- Brand header ----------
                /*    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 42,
                          width: 42,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: const LinearGradient(
                              colors: [AppTheme.accent, AppTheme.primary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.local_cafe_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Mezan Loyalty',
                              style: TextStyle(
                                fontFamily: AppTheme.fontFamily,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Rewards • Surveys • Transfers',
                              style: TextStyle(
                                fontFamily: AppTheme.fontFamily,
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.75),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),*/

                 //   const SizedBox(height: 3),

                    // ---------- Card ----------
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDFDFE),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.35),
                            blurRadius: 30,
                            offset: const Offset(0, 18),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white.withOpacity(0.7),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tab == 0 ? 'Welcome back 👋' : 'Create your account',
                            style: const TextStyle(
                              fontFamily: AppTheme.fontFamily,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            tab == 0
                                ? 'Login to manage your rewards and transfers.'
                                : 'Sign up to start earning and sharing points.',
                            style: const TextStyle(
                              fontFamily: AppTheme.fontFamily,
                              fontSize: 12.5,
                              color: Color(0xFF7A7890),
                            ),
                          ),

                          const SizedBox(height: 20),

                          _AuthToggle(
                            activeIndex: tab,
                            onChanged: (i) {
                              FocusScope.of(context).unfocus();
                              _loginFormKey.currentState?.reset();
                              _signupFormKey.currentState?.reset();
                              setState(() => tab = i);
                            },
                          ),

                          const SizedBox(height: 20),

                          if (tab == 0) _buildLoginForm(),
                          if (tab == 1) _buildSignupForm(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      '© ${DateTime.now().year} Mezan Group • All rights reserved',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------- FORMS (logic same, only spacing) ----------

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          _InputCard(
            hint: 'Email address',
            icon: Icons.email_outlined,
            controller: _loginEmailCtrl,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
          ),
          const SizedBox(height: 14),
          _InputCard(
            hint: 'Password',
            icon: Icons.lock_outline_rounded,
            controller: _loginPassCtrl,
            validator: _validatePassword,
            obscureText: _loginObscure,
            onToggleObscure: () =>
                setState(() => _loginObscure = !_loginObscure),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Text(
                'Forgot password?',
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: _PrimaryGradientButton(
              text: _loginLoading ? 'PLEASE WAIT...' : 'Continue',
              loading: _loginLoading,
              onPressed: _loginLoading ? null : _submitLogin,
            ),
          ),
          const SizedBox(height: 18),
          _FooterSwitch(
            prompt: "Don’t have an account? ",
            action: "Sign up",
            onTap: () => setState(() => tab = 1),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupForm() {
    return Form(
      key: _signupFormKey,
      child: Column(
        children: [
          _InputCard(
            hint: 'Full name',
            icon: Icons.person_outline_rounded,
            controller: _signupNameCtrl,
            validator: _validateName,
          ),
          const SizedBox(height: 12),
          _InputCard(
            hint: 'Email address',
            icon: Icons.email_outlined,
            controller: _signupEmailCtrl,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
          ),
          const SizedBox(height: 12),
          _InputCard(
            hint: 'Phone number',
            icon: Icons.phone_rounded,
            controller: _signupPhoneCtrl,
            keyboardType: TextInputType.phone,
            validator: _validatePhone,
          ),
          const SizedBox(height: 12),
          _InputCard(
            hint: 'Password',
            icon: Icons.lock_outline_rounded,
            controller: _signupPassCtrl,
            validator: _validatePassword,
            obscureText: _signupObscure,
            onToggleObscure: () =>
                setState(() => _signupObscure = !_signupObscure),
          ),
          const SizedBox(height: 12),
          _InputCard(
            hint: 'Confirm password',
            icon: Icons.lock_outline_rounded,
            controller: _signupConfirmCtrl,
            validator: _validateConfirm,
            obscureText: _signupConfirmObscure,
            onToggleObscure: () => setState(
              () => _signupConfirmObscure = !_signupConfirmObscure,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: _PrimaryGradientButton(
              text: _signupLoading ? 'PLEASE WAIT...' : 'Create account',
              loading: _signupLoading,
              onPressed: _signupLoading ? null : _submitSignup,
            ),
          ),
          const SizedBox(height: 18),
          _FooterSwitch(
            prompt: "Already have an account? ",
            action: "Login",
            onTap: () => setState(() => tab = 0),
          ),
        ],
      ),
    );
  }
}

/* ----------------- UI components ----------------- */

class _AuthToggle extends StatelessWidget {
  const _AuthToggle({required this.activeIndex, required this.onChanged});
  final int activeIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F2FA),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppTheme.primary.withOpacity(.10),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleItem(
              label: 'Login',
              selected: activeIndex == 0,
              onTap: () => onChanged(0),
            ),
          ),
          Expanded(
            child: _ToggleItem(
              label: 'Sign up',
              selected: activeIndex == 1,
              onTap: () => onChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleItem extends StatelessWidget {
  const _ToggleItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: selected ? AppTheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : AppTheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  const _InputCard({
    required this.hint,
    required this.icon,
    this.controller,
    this.keyboardType,
    this.validator,
    this.obscureText = false,
    this.onToggleObscure,
  });

  final String hint;
  final IconData icon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final VoidCallback? onToggleObscure;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE2DEFA),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppTheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                validator: validator,
                obscureText: obscureText,
                style: const TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  color: Color(0xFF1F1235),
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                  isCollapsed: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10),
                  hintStyle: const TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    color: Color(0xFFB2AEC9),
                    fontSize: 13.5,
                  ),
                ),
              ),
            ),
            if (onToggleObscure != null)
              IconButton(
                onPressed: onToggleObscure,
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: const Color(0xFFB1A4CC),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FooterSwitch extends StatelessWidget {
  const _FooterSwitch({
    required this.prompt,
    required this.action,
    required this.onTap,
  });
  final String prompt;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          prompt,
          style: const TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 13.5,
            color: Color(0xFF75748A),
            fontWeight: FontWeight.w500,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            action,
            style: const TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 13.5,
              color: AppTheme.accent,
              decorationThickness: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _PrimaryGradientButton extends StatelessWidget {
  const _PrimaryGradientButton({
    required this.text,
    required this.onPressed,
    this.loading = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final disabled = loading || onPressed == null;

    return Opacity(
      opacity: disabled ? 0.7 : 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient: const LinearGradient(
            colors: [AppTheme.primary, AppTheme.accent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.22),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: disabled ? null : onPressed,
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        text,
                        style: const TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



// class AuthScreen extends StatefulWidget {
//   const AuthScreen({super.key});

//   @override
//   State<AuthScreen> createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen> {
//   int tab = 0;
//   var storage = GetStorage();

//   final _loginFormKey = GlobalKey<FormState>();
//   final _signupFormKey = GlobalKey<FormState>();

//   final _loginEmailCtrl = TextEditingController();
//   final _loginPassCtrl = TextEditingController();

//   final _signupNameCtrl = TextEditingController();
//   final _signupEmailCtrl = TextEditingController();
//   final _signupPhoneCtrl = TextEditingController();
//   final _signupPassCtrl = TextEditingController();
//   final _signupConfirmCtrl = TextEditingController();

//   bool _loginObscure = true;
//   bool _signupObscure = true;
//   bool _signupConfirmObscure = true;

//   bool _loginLoading = false;
//   bool _signupLoading = false;

//   @override
//   void dispose() {
//     _loginEmailCtrl.dispose();
//     _loginPassCtrl.dispose();
//     _signupNameCtrl.dispose();
//     _signupEmailCtrl.dispose();
//     _signupPhoneCtrl.dispose();
//     _signupPassCtrl.dispose();
//     _signupConfirmCtrl.dispose();
//     super.dispose();
//   }

//   // ----------------- validators -----------------
//   String? _validateEmail(String? v) {
//     final s = v?.trim() ?? '';
//     if (s.isEmpty) return 'Email is required';
//     final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(s);
//     return ok ? null : 'Enter a valid email';
//   }

//   String? _validatePassword(String? v) {
//     final s = v ?? '';
//     if (s.isEmpty) return 'Password is required';
//     if (s.length < 6) return 'Use at least 6 characters';
//     return null;
//   }

//   String? _validateName(String? v) {
//     final s = (v ?? '').trim();
//     if (s.isEmpty) return 'Name is required';
//     if (s.length < 2) return 'Enter a valid name';
//     return null;
//   }

//   String? _validatePhone(String? v) {
//     final s = (v ?? '').trim();
//     if (s.isEmpty) return 'Phone is required';
//     if (s.length < 8) return 'Enter a valid phone number';
//     return null;
//   }

//   String? _validateConfirm(String? v) {
//     if (v == null || v.isEmpty) return 'Confirm your password';
//     if (v != _signupPassCtrl.text) return 'Passwords do not match';
//     return null;
//   }

//   // ----------------- LOGIN (HARDCODED) -----------------
//   Future<void> _submitLogin() async {
//     final form = _loginFormKey.currentState;
//     if (form == null) return;
//     FocusScope.of(context).unfocus();
//     if (!form.validate()) return;

//     setState(() => _loginLoading = true);
//     await Future.delayed(const Duration(seconds: 1));
//     setState(() => _loginLoading = false);

//     if (!mounted) return;

//     final email = _loginEmailCtrl.text.trim();
//     final password = _loginPassCtrl.text;

//     if (email == 'testuser@gmail.com' && password == 'Testing@123') {
//       storage.write("user", 1);
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const HomeScreen()),
//       );
//     } else if (email == 'testsurvery@gmail.com' && password == 'Testing@123') {
//       storage.write("supervisor", 2);
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const SurveyScreenView()),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Invalid email or password'),
//         ),
//       );
//     }
//   }

//   Future<void> _submitSignup() async {
//     final form = _signupFormKey.currentState;
//     if (form == null) return;
//     FocusScope.of(context).unfocus();
//     if (!form.validate()) return;

//     setState(() => _signupLoading = true);
//     await Future.delayed(const Duration(seconds: 1)); // TODO: hook API
//     setState(() => _signupLoading = false);

//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Account created! (wire your API here)')),
//     );

//     setState(() => tab = 0);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       // No plain background; we’ll do full-screen hero behind everything
//       body: Stack(
//         children: [
//           // ---------- HERO BACKGROUND (like Mezan Tea banner) ----------
//           Positioned(
//             child: Image.asset(
//               'assets/mezan_tea-removebg-preview.png', // 🔁 put your tea hero image here
//               fit: BoxFit.contain,
//             ),
//           ),
//           // Dark overlay to make card pop
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.black.withOpacity(0.55),
//                     Colors.black.withOpacity(0.75),
//                   ],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//             ),
//           ),

//           // ---------- CONTENT ----------
//           SafeArea(
//             child: Center(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
//                 child: ConstrainedBox(
//                   constraints: const BoxConstraints(
//                     maxWidth: 430,
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       // ---- Top title like "MEZAN TEA" hero ----
//                       Text(
//                         'MEZAN TEA',
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           fontFamily: AppTheme.fontFamily,
//                           fontSize: 26,
//                           letterSpacing: 2,
//                           fontWeight: FontWeight.w800,
//                           color: Colors.white,
//                         ),
//                       ),
//                       Container(
//                         width: 155,
//                         height: 3,
//                         decoration: BoxDecoration(
//                           color: Colors.red,
//                           borderRadius: BorderRadius.circular(999),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         'Rich taste & strong aroma.\nManage your rewards and surveys here.',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontFamily: AppTheme.fontFamily,
//                           fontSize: 13,
//                           color: Colors.white.withOpacity(0.85),
//                           height: 1.4,
//                         ),
//                       ),

//                       const SizedBox(height: 28),

//                       // ---------- GLASS / CARD PANEL ----------
//                       Container(
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.96),
//                           borderRadius: BorderRadius.circular(26),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.25),
//                               blurRadius: 22,
//                               offset: const Offset(0, 14),
//                             ),
//                           ],
//                           border: Border.all(
//                             color: Colors.white.withOpacity(0.6),
//                             width: 1,
//                           ),
//                         ),
//                         padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Small label / breadcrumb style like website
//                             Text(
//                               tab == 0 ? 'LOGIN • REWARDS PORTAL' : 'SIGN UP • NEW ACCOUNT',
//                               style: const TextStyle(
//                                 fontFamily: AppTheme.fontFamily,
//                                 fontSize: 11.5,
//                                 letterSpacing: 1.1,
//                                 fontWeight: FontWeight.w600,
//                                 color: Color(0xFF9A8EB5),
//                               ),
//                             ),
//                             const SizedBox(height: 12),

//                             Text(
//                               tab == 0 ? 'Welcome back 👋' : 'Create your account',
//                               style: const TextStyle(
//                                 fontFamily: AppTheme.fontFamily,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w700,
//                                 color: AppTheme.primary,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               tab == 0
//                                   ? 'Login to manage your rewards and transfers.'
//                                   : 'Sign up to start earning and sharing points.',
//                               style: const TextStyle(
//                                 fontFamily: AppTheme.fontFamily,
//                                 fontSize: 12.5,
//                                 color: Color(0xFF75748A),
//                               ),
//                             ),

//                             const SizedBox(height: 20),

//                             _AuthToggle(
//                               activeIndex: tab,
//                               onChanged: (i) {
//                                 FocusScope.of(context).unfocus();
//                                 _loginFormKey.currentState?.reset();
//                                 _signupFormKey.currentState?.reset();
//                                 setState(() => tab = i);
//                               },
//                             ),

//                             const SizedBox(height: 20),

//                             if (tab == 0) _buildLoginForm(),
//                             if (tab == 1) _buildSignupForm(),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 18),

//                       // Optional tiny footer text (like certifications area vibe)
//                       Text(
//                         'Powered by Mezan Group Loyalty • © ${DateTime.now().year}',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontFamily: AppTheme.fontFamily,
//                           fontSize: 11,
//                           color: Colors.white.withOpacity(0.75),
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'Rich Taste • Strong Aroma • Togetherness',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontFamily: AppTheme.fontFamily,
//                           fontSize: 11,
//                           color: Colors.white.withOpacity(0.7),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ---------- FORMS (unchanged logic, only styling from your existing code) ----------

//   Widget _buildLoginForm() {
//     return Form(
//       key: _loginFormKey,
//       child: Column(
//         children: [
//           _InputCard(
//             hint: 'Email',
//             icon: Icons.email_outlined,
//             controller: _loginEmailCtrl,
//             keyboardType: TextInputType.emailAddress,
//             validator: _validateEmail,
//           ),
//           const SizedBox(height: 14),
//           _InputCard(
//             hint: 'Password',
//             icon: Icons.lock_outline_rounded,
//             controller: _loginPassCtrl,
//             validator: _validatePassword,
//             obscureText: _loginObscure,
//             onToggleObscure: () =>
//                 setState(() => _loginObscure = !_loginObscure),
//           ),
//           const SizedBox(height: 8),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: const [
//               Text(
//                 'Forgot password?',
//                 style: TextStyle(
//                   fontFamily: AppTheme.fontFamily,
//                   fontSize: 13.5,
//                   fontWeight: FontWeight.w600,
//                   color: AppTheme.primary,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             width: 180,
//             height: 44,
//             child: _PrimaryGradientButton(
//               text: _loginLoading ? 'PLEASE WAIT...' : 'LOGIN',
//               loading: _loginLoading,
//               onPressed: _loginLoading ? null : _submitLogin,
//             ),
//           ),
//           const SizedBox(height: 18),
//           _FooterSwitch(
//             prompt: "Don’t have an account? ",
//             action: "Sign up",
//             onTap: () => setState(() => tab = 1),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSignupForm() {
//     return Form(
//       key: _signupFormKey,
//       child: Column(
//         children: [
//           _InputCard(
//             hint: 'Full Name',
//             icon: Icons.person_outline_rounded,
//             controller: _signupNameCtrl,
//             validator: _validateName,
//           ),
//           const SizedBox(height: 12),
//           _InputCard(
//             hint: 'Email',
//             icon: Icons.email_outlined,
//             controller: _signupEmailCtrl,
//             keyboardType: TextInputType.emailAddress,
//             validator: _validateEmail,
//           ),
//           const SizedBox(height: 12),
//           _InputCard(
//             hint: 'Phone Number',
//             icon: Icons.phone_rounded,
//             controller: _signupPhoneCtrl,
//             keyboardType: TextInputType.phone,
//             validator: _validatePhone,
//           ),
//           const SizedBox(height: 12),
//           _InputCard(
//             hint: 'Password',
//             icon: Icons.lock_outline_rounded,
//             controller: _signupPassCtrl,
//             validator: _validatePassword,
//             obscureText: _signupObscure,
//             onToggleObscure: () =>
//                 setState(() => _signupObscure = !_signupObscure),
//           ),
//           const SizedBox(height: 12),
//           _InputCard(
//             hint: 'Confirm Password',
//             icon: Icons.lock_outline_rounded,
//             controller: _signupConfirmCtrl,
//             validator: _validateConfirm,
//             obscureText: _signupConfirmObscure,
//             onToggleObscure: () => setState(
//               () => _signupConfirmObscure = !_signupConfirmObscure,
//             ),
//           ),
//           const SizedBox(height: 20),
//           SizedBox(
//             width: 180,
//             height: 44,
//             child: _PrimaryGradientButton(
//               text: _signupLoading ? 'PLEASE WAIT...' : 'SIGN UP',
//               loading: _signupLoading,
//               onPressed: _signupLoading ? null : _submitSignup,
//             ),
//           ),
//           const SizedBox(height: 18),
//           _FooterSwitch(
//             prompt: "Already have an account? ",
//             action: "Login",
//             onTap: () => setState(() => tab = 0),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /* ----------------- UI components (unchanged from your code) ----------------- */

// class _AuthToggle extends StatelessWidget {
//   const _AuthToggle({required this.activeIndex, required this.onChanged});
//   final int activeIndex;
//   final ValueChanged<int> onChanged;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 44,
//       decoration: BoxDecoration(
//         color: const Color(0xFFF3F1FA),
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(
//           color: AppTheme.primary.withOpacity(.10),
//           width: 1,
//         ),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: AnimatedContainer(
//               height: 44,
//               duration: const Duration(milliseconds: 200),
//               decoration: BoxDecoration(
//                 color:
//                     activeIndex == 0 ? AppTheme.primary : Colors.transparent,
//                 borderRadius: BorderRadius.circular(22),
//               ),
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(22),
//                 onTap: () => onChanged(0),
//                 child: Center(
//                   child: Text(
//                     'Login',
//                     style: TextStyle(
//                       fontFamily: AppTheme.fontFamily,
//                       fontSize: 15.5,
//                       fontWeight: FontWeight.w700,
//                       color: activeIndex == 0
//                           ? Colors.white
//                           : AppTheme.primary,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: AnimatedContainer(
//               height: 44,
//               duration: const Duration(milliseconds: 200),
//               decoration: BoxDecoration(
//                 color:
//                     activeIndex == 1 ? AppTheme.primary : Colors.transparent,
//                 borderRadius: BorderRadius.circular(22),
//               ),
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(22),
//                 onTap: () => onChanged(1),
//                 child: Center(
//                   child: Text(
//                     'Sign up',
//                     style: TextStyle(
//                       fontFamily: AppTheme.fontFamily,
//                       fontSize: 15.5,
//                       fontWeight: FontWeight.w700,
//                       color: activeIndex == 1
//                           ? Colors.white
//                           : AppTheme.primary,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _InputCard extends StatelessWidget {
//   const _InputCard({
//     required this.hint,
//     required this.icon,
//     this.controller,
//     this.keyboardType,
//     this.validator,
//     this.obscureText = false,
//     this.onToggleObscure,
//   });

//   final String hint;
//   final IconData icon;
//   final TextEditingController? controller;
//   final TextInputType? keyboardType;
//   final String? Function(String?)? validator;
//   final bool obscureText;
//   final VoidCallback? onToggleObscure;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(16),
//       elevation: 0,
//       child: Container(
//         height: 54,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: AppTheme.primary.withOpacity(.08),
//           ),
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 14),
//         child: Row(
//           children: [
//             Icon(icon, size: 20, color: AppTheme.primary),
//             const SizedBox(width: 10),
//             Expanded(
//               child: TextFormField(
//                 controller: controller,
//                 keyboardType: keyboardType,
//                 validator: validator,
//                 obscureText: obscureText,
//                 style: const TextStyle(
//                   fontFamily: AppTheme.fontFamily,
//                   color: Color(0xFF1F1235),
//                   fontSize: 14.5,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 decoration: InputDecoration(
//                   hintText: hint,
//                   border: InputBorder.none,
//                   isCollapsed: true,
//                   contentPadding:
//                       const EdgeInsets.symmetric(vertical: 10),
//                   hintStyle: const TextStyle(
//                     fontFamily: AppTheme.fontFamily,
//                     color: Color(0xFF9A8EB5),
//                     fontSize: 13.5,
//                   ),
//                 ),
//               ),
//             ),
//             if (onToggleObscure != null)
//               IconButton(
//                 onPressed: onToggleObscure,
//                 icon: Icon(
//                   obscureText
//                       ? Icons.visibility_off_outlined
//                       : Icons.visibility_outlined,
//                   size: 20,
//                   color: const Color(0xFFB1A4CC),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _FooterSwitch extends StatelessWidget {
//   const _FooterSwitch({
//     required this.prompt,
//     required this.action,
//     required this.onTap,
//   });
//   final String prompt;
//   final String action;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       alignment: WrapAlignment.center,
//       crossAxisAlignment: WrapCrossAlignment.center,
//       children: [
//         Text(
//           prompt,
//           style: const TextStyle(
//             fontFamily: AppTheme.fontFamily,
//             fontSize: 13.5,
//             color: Color(0xFF75748A),
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         GestureDetector(
//           onTap: onTap,
//           child: Text(
//             action,
//             style: const TextStyle(
//               fontFamily: AppTheme.fontFamily,
//               fontSize: 13.5,
//               color: AppTheme.accent,
//               decorationThickness: 1.4,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _PrimaryGradientButton extends StatelessWidget {
//   const _PrimaryGradientButton({
//     required this.text,
//     required this.onPressed,
//     this.loading = false,
//   });

//   final String text;
//   final VoidCallback? onPressed;
//   final bool loading;

//   @override
//   Widget build(BuildContext context) {
//     final disabled = loading || onPressed == null;

//     return Opacity(
//       opacity: disabled ? 0.7 : 1,
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(28),
//           gradient: const LinearGradient(
//             colors: [AppTheme.primary, AppTheme.accent],
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: AppTheme.primary.withOpacity(0.20),
//               blurRadius: 16,
//               offset: const Offset(0, 8),
//             ),
//           ],
//         ),
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             borderRadius: BorderRadius.circular(28),
//             onTap: disabled ? null : onPressed,
//             child: Center(
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
//                 child: loading
//                     ? const SizedBox(
//                         height: 20,
//                         width: 20,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           valueColor:
//                               AlwaysStoppedAnimation<Color>(Colors.white),
//                         ),
//                       )
//                     : Text(
//                         text,
//                         style: const TextStyle(
//                           fontFamily: AppTheme.fontFamily,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


// class AuthScreen extends StatefulWidget {
//   const AuthScreen({super.key});

//   @override
//   State<AuthScreen> createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen> {
//   int tab = 0;
//   var storage = GetStorage();

//   final _loginFormKey = GlobalKey<FormState>();
//   final _signupFormKey = GlobalKey<FormState>();

//   final _loginEmailCtrl = TextEditingController();
//   final _loginPassCtrl = TextEditingController();

//   final _signupNameCtrl = TextEditingController();
//   final _signupEmailCtrl = TextEditingController();
//   final _signupPhoneCtrl = TextEditingController();
//   final _signupPassCtrl = TextEditingController();
//   final _signupConfirmCtrl = TextEditingController();

//   bool _loginObscure = true;
//   bool _signupObscure = true;
//   bool _signupConfirmObscure = true;

//   bool _loginLoading = false;
//   bool _signupLoading = false;

//   @override
//   void dispose() {
//     _loginEmailCtrl.dispose();
//     _loginPassCtrl.dispose();
//     _signupNameCtrl.dispose();
//     _signupEmailCtrl.dispose();
//     _signupPhoneCtrl.dispose();
//     _signupPassCtrl.dispose();
//     _signupConfirmCtrl.dispose();
//     super.dispose();
//   }

//   // ----------------- validators -----------------
//   String? _validateEmail(String? v) {
//     final s = v?.trim() ?? '';
//     if (s.isEmpty) return 'Email is required';
//     final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(s);
//     return ok ? null : 'Enter a valid email';
//   }

//   String? _validatePassword(String? v) {
//     final s = v ?? '';
//     if (s.isEmpty) return 'Password is required';
//     if (s.length < 6) return 'Use at least 6 characters';
//     return null;
//   }

//   String? _validateName(String? v) {
//     final s = (v ?? '').trim();
//     if (s.isEmpty) return 'Name is required';
//     if (s.length < 2) return 'Enter a valid name';
//     return null;
//   }

//   String? _validatePhone(String? v) {
//     final s = (v ?? '').trim();
//     if (s.isEmpty) return 'Phone is required';
//     if (s.length < 8) return 'Enter a valid phone number';
//     return null;
//   }

//   String? _validateConfirm(String? v) {
//     if (v == null || v.isEmpty) return 'Confirm your password';
//     if (v != _signupPassCtrl.text) return 'Passwords do not match';
//     return null;
//   }

//   // ----------------- LOGIN (HARDCODED) -----------------
//   Future<void> _submitLogin() async {
//     final form = _loginFormKey.currentState;
//     if (form == null) return;
//     FocusScope.of(context).unfocus();
//     if (!form.validate()) return;

//     setState(() => _loginLoading = true);
//     await Future.delayed(const Duration(seconds: 1));
//     setState(() => _loginLoading = false);

//     if (!mounted) return;

//     final email = _loginEmailCtrl.text.trim();
//     final password = _loginPassCtrl.text;

//     if (email == 'testuser@gmail.com' && password == 'Testing@123') {
//       // ➜ Go to HomeScreen
//           storage.write("user", 1);
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const HomeScreen()),
    
//       );
//     } else if (email == 'testsurvery@gmail.com' && password == 'Testing@123') {
//    storage.write("supervisor", 2);
//       // ➜ Go to SurveyScreenView
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const SurveyScreenView()),
//       );
//     } else {
//       // invalid combo
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Invalid email or password'),
//         ),
//       );
//     }
//   }

//   Future<void> _submitSignup() async {
//     final form = _signupFormKey.currentState;
//     if (form == null) return;
//     FocusScope.of(context).unfocus();
//     if (!form.validate()) return;

//     setState(() => _signupLoading = true);
//     await Future.delayed(const Duration(seconds: 1)); // TODO: hook API
//     setState(() => _signupLoading = false);

//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Account created! (wire your API here)')),
//     );

//     setState(() => tab = 0);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F8FA),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(height: MediaQuery.of(context).size.height * 0.10),

//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   tab == 0 ? 'Welcome back 👋' : 'Create your account',
//                   style: const TextStyle(
//                     fontFamily: AppTheme.fontFamily,
//                     fontSize: 20,
//                     fontWeight: FontWeight.w700,
//                     color: AppTheme.primary,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   tab == 0
//                       ? 'Login to manage your rewards and transfers.'
//                       : 'Sign up to start earning and sharing points.',
//                   style: const TextStyle(
//                     fontFamily: AppTheme.fontFamily,
//                     fontSize: 12.5,
//                     color: Color(0xFF75748A),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 24),

//               _AuthToggle(
//                 activeIndex: tab,
//                 onChanged: (i) {
//                   FocusScope.of(context).unfocus();
//                   _loginFormKey.currentState?.reset();
//                   _signupFormKey.currentState?.reset();
//                   setState(() => tab = i);
//                 },
//               ),

//               const SizedBox(height: 24),

//               if (tab == 0) _buildLoginForm(),
//               if (tab == 1) _buildSignupForm(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLoginForm() {
//     return Form(
//       key: _loginFormKey,
//       child: Column(
//         children: [
//           _InputCard(
//             hint: 'Email',
//             icon: Icons.email_outlined,
//             controller: _loginEmailCtrl,
//             keyboardType: TextInputType.emailAddress,
//             validator: _validateEmail,
//           ),
//           const SizedBox(height: 14),
//           _InputCard(
//             hint: 'Password',
//             icon: Icons.lock_outline_rounded,
//             controller: _loginPassCtrl,
//             validator: _validatePassword,
//             obscureText: _loginObscure,
//             onToggleObscure: () =>
//                 setState(() => _loginObscure = !_loginObscure),
//           ),
//           const SizedBox(height: 8),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: const [
//               Text(
//                 'Forgot password?',
//                 style: TextStyle(
//                   fontFamily: AppTheme.fontFamily,
//                   fontSize: 13.5,
//                   fontWeight: FontWeight.w600,
//                   color: AppTheme.primary,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             width: 150,
//             height: 42,
//             child: _PrimaryGradientButton(
//               text: _loginLoading ? 'PLEASE WAIT...' : 'LOGIN',
//               loading: _loginLoading,
//               onPressed: _loginLoading ? null : _submitLogin,
//             ),
//           ),
//           const SizedBox(height: 18),
//           _FooterSwitch(
//             prompt: "Don’t have an account? ",
//             action: "Sign up",
//             onTap: () => setState(() => tab = 1),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSignupForm() {
//     return Form(
//       key: _signupFormKey,
//       child: Column(
//         children: [
//           _InputCard(
//             hint: 'Full Name',
//             icon: Icons.person_outline_rounded,
//             controller: _signupNameCtrl,
//             validator: _validateName,
//           ),
//           const SizedBox(height: 12),
//           _InputCard(
//             hint: 'Email',
//             icon: Icons.email_outlined,
//             controller: _signupEmailCtrl,
//             keyboardType: TextInputType.emailAddress,
//             validator: _validateEmail,
//           ),
//           const SizedBox(height: 12),
//           _InputCard(
//             hint: 'Phone Number',
//             icon: Icons.phone_rounded,
//             controller: _signupPhoneCtrl,
//             keyboardType: TextInputType.phone,
//             validator: _validatePhone,
//           ),
//           const SizedBox(height: 12),
//           _InputCard(
//             hint: 'Password',
//             icon: Icons.lock_outline_rounded,
//             controller: _signupPassCtrl,
//             validator: _validatePassword,
//             obscureText: _signupObscure,
//             onToggleObscure: () =>
//                 setState(() => _signupObscure = !_signupObscure),
//           ),
//           const SizedBox(height: 12),
//           _InputCard(
//             hint: 'Confirm Password',
//             icon: Icons.lock_outline_rounded,
//             controller: _signupConfirmCtrl,
//             validator: _validateConfirm,
//             obscureText: _signupConfirmObscure,
//             onToggleObscure: () => setState(
//               () => _signupConfirmObscure = !_signupConfirmObscure,
//             ),
//           ),
//           const SizedBox(height: 20),
//           SizedBox(
//             width: 150,
//             height: 42,
//             child: _PrimaryGradientButton(
//               text: _signupLoading ? 'PLEASE WAIT...' : 'SIGN UP',
//               loading: _signupLoading,
//               onPressed: _signupLoading ? null : _submitSignup,
//             ),
//           ),
//           const SizedBox(height: 18),
//           _FooterSwitch(
//             prompt: "Already have an account? ",
//             action: "Login",
//             onTap: () => setState(() => tab = 0),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /* ----------------- UI components ----------------- */

// class _AuthToggle extends StatelessWidget {
//   const _AuthToggle({required this.activeIndex, required this.onChanged});
//   final int activeIndex;
//   final ValueChanged<int> onChanged;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 44,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(
//           color: AppTheme.primary.withOpacity(.08),
//           width: 1,
//         ),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: AnimatedContainer(
//               height: 44,
//               duration: const Duration(milliseconds: 200),
//               decoration: BoxDecoration(
//                 color:
//                     activeIndex == 0 ? AppTheme.primary : Colors.transparent,
//                 borderRadius: BorderRadius.circular(22),
//               ),
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(22),
//                 onTap: () => onChanged(0),
//                 child: Center(
//                   child: Text(
//                     'Login',
//                     style: TextStyle(
//                       fontFamily: AppTheme.fontFamily,
//                       fontSize: 15.5,
//                       fontWeight: FontWeight.w700,
//                       color: activeIndex == 0
//                           ? Colors.white
//                           : AppTheme.primary,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: AnimatedContainer(
//               height: 44,
//               duration: const Duration(milliseconds: 200),
//               decoration: BoxDecoration(
//                 color:
//                     activeIndex == 1 ? AppTheme.primary : Colors.transparent,
//                 borderRadius: BorderRadius.circular(22),
//               ),
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(22),
//                 onTap: () => onChanged(1),
//                 child: Center(
//                   child: Text(
//                     'Sign up',
//                     style: TextStyle(
//                       fontFamily: AppTheme.fontFamily,
//                       fontSize: 15.5,
//                       fontWeight: FontWeight.w700,
//                       color: activeIndex == 1
//                           ? Colors.white
//                           : AppTheme.primary,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _InputCard extends StatelessWidget {
//   const _InputCard({
//     required this.hint,
//     required this.icon,
//     this.controller,
//     this.keyboardType,
//     this.validator,
//     this.obscureText = false,
//     this.onToggleObscure,
//   });

//   final String hint;
//   final IconData icon;
//   final TextEditingController? controller;
//   final TextInputType? keyboardType;
//   final String? Function(String?)? validator;
//   final bool obscureText;
//   final VoidCallback? onToggleObscure;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(16),
//       elevation: 0,
//       child: Container(
//         height: 54,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: AppTheme.primary.withOpacity(.08),
//           ),
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 14),
//         child: Row(
//           children: [
//             Icon(icon, size: 20, color: AppTheme.primary),
//             const SizedBox(width: 10),
//             Expanded(
//               child: TextFormField(
//                 controller: controller,
//                 keyboardType: keyboardType,
//                 validator: validator,
//                 obscureText: obscureText,
//                 style: const TextStyle(
//                   fontFamily: AppTheme.fontFamily,
//                   color: Color(0xFF1F1235),
//                   fontSize: 14.5,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 decoration: InputDecoration(
//                   hintText: hint,
//                   border: InputBorder.none,
//                   isCollapsed: true,
//                   contentPadding:
//                       const EdgeInsets.symmetric(vertical: 10),
//                   hintStyle: const TextStyle(
//                     fontFamily: AppTheme.fontFamily,
//                     color: Color(0xFF9A8EB5),
//                     fontSize: 13.5,
//                   ),
//                 ),
//               ),
//             ),
//             if (onToggleObscure != null)
//               IconButton(
//                 onPressed: onToggleObscure,
//                 icon: Icon(
//                   obscureText
//                       ? Icons.visibility_off_outlined
//                       : Icons.visibility_outlined,
//                   size: 20,
//                   color: const Color(0xFFB1A4CC),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _FooterSwitch extends StatelessWidget {
//   const _FooterSwitch({
//     required this.prompt,
//     required this.action,
//     required this.onTap,
//   });
//   final String prompt;
//   final String action;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       alignment: WrapAlignment.center,
//       crossAxisAlignment: WrapCrossAlignment.center,
//       children: [
//         Text(
//           prompt,
//           style: const TextStyle(
//             fontFamily: AppTheme.fontFamily,
//             fontSize: 13.5,
//             color: Color(0xFF75748A),
//             fontWeight: FontWeight.w500
//           ),
//         ),
//         GestureDetector(
//           onTap: onTap,
//           child: Text(
//             action,
//             style: const TextStyle(
//               fontFamily: AppTheme.fontFamily,
//               fontSize: 13.5,
//               color: AppTheme.accent,
//           //    decoration: TextDecoration.underline,
//               decorationThickness: 1.4,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _PrimaryGradientButton extends StatelessWidget {
//   const _PrimaryGradientButton({
//     required this.text,
//     required this.onPressed,
//     this.loading = false,
//   });

//   final String text;
//   final VoidCallback? onPressed;
//   final bool loading;

//   @override
//   Widget build(BuildContext context) {
//     final disabled = loading || onPressed == null;

//     return Opacity(
//       opacity: disabled ? 0.7 : 1,
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(28),
//           gradient: const LinearGradient(
//             colors: [AppTheme.primary, AppTheme.accent],
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: AppTheme.primary.withOpacity(0.20),
//               blurRadius: 16,
//               offset: const Offset(0, 8),
//             ),
//           ],
//         ),
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             borderRadius: BorderRadius.circular(28),
//             onTap: disabled ? null : onPressed,
//             child: Center(
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
//                 child: loading
//                     ? const SizedBox(
//                         height: 20,
//                         width: 20,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           valueColor:
//                               AlwaysStoppedAnimation<Color>(Colors.white),
//                         ),
//                       )
//                     : Text(
//                         text,
//                         style: const TextStyle(
//                           fontFamily: AppTheme.fontFamily,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
