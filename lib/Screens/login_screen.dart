import 'package:flutter/material.dart';
import 'package:voice_assistant_project/Screens/sales_survery_screen.dart';
import 'package:voice_assistant_project/Theme/theme.dart';
import 'package:voice_assistant_project/Screens/home_screen.dart';
//want a hardcoded login testuser@gmail.com and password = Testing@123 navigqate to HomeScreen and testsurvery@gmail.com and password Testing@123 then navigate to SurveyScreenView()
import 'package:flutter/material.dart';
import 'package:voice_assistant_project/Theme/theme.dart';
import 'package:voice_assistant_project/Screens/home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int tab = 0;

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
      // ➜ Go to HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else if (email == 'testsurvery@gmail.com' && password == 'Testing@123') {
      
      // ➜ Go to SurveyScreenView
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SurveyScreenView()),
      );
    } else {
      // invalid combo
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
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.10),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  tab == 0 ? 'Welcome back 👋' : 'Create your account',
                  style: const TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  tab == 0
                      ? 'Login to manage your rewards and transfers.'
                      : 'Sign up to start earning and sharing points.',
                  style: const TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 12.5,
                    color: Color(0xFF75748A),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              _AuthToggle(
                activeIndex: tab,
                onChanged: (i) {
                  FocusScope.of(context).unfocus();
                  _loginFormKey.currentState?.reset();
                  _signupFormKey.currentState?.reset();
                  setState(() => tab = i);
                },
              ),

              const SizedBox(height: 24),

              if (tab == 0) _buildLoginForm(),
              if (tab == 1) _buildSignupForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          _InputCard(
            hint: 'Email',
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
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Text(
                'Forgot password?',
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 150,
            height: 42,
            child: _PrimaryGradientButton(
              text: _loginLoading ? 'PLEASE WAIT...' : 'LOGIN',
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
            hint: 'Full Name',
            icon: Icons.person_outline_rounded,
            controller: _signupNameCtrl,
            validator: _validateName,
          ),
          const SizedBox(height: 12),
          _InputCard(
            hint: 'Email',
            icon: Icons.email_outlined,
            controller: _signupEmailCtrl,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
          ),
          const SizedBox(height: 12),
          _InputCard(
            hint: 'Phone Number',
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
            hint: 'Confirm Password',
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
            width: 150,
            height: 42,
            child: _PrimaryGradientButton(
              text: _signupLoading ? 'PLEASE WAIT...' : 'SIGN UP',
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.primary.withOpacity(.08),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: AnimatedContainer(
              height: 44,
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color:
                    activeIndex == 0 ? AppTheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(22),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: () => onChanged(0),
                child: Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: activeIndex == 0
                          ? Colors.white
                          : AppTheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: AnimatedContainer(
              height: 44,
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color:
                    activeIndex == 1 ? AppTheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(22),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: () => onChanged(1),
                child: Center(
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: activeIndex == 1
                          ? Colors.white
                          : AppTheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.primary.withOpacity(.08),
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
                    color: Color(0xFF9A8EB5),
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
              decoration: TextDecoration.underline,
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
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [AppTheme.primary, AppTheme.accent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.20),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: disabled ? null : onPressed,
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
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
                          fontSize: 16,
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

//   Future<void> _submitLogin() async {
//     final form = _loginFormKey.currentState;
//     if (form == null) return;
//     FocusScope.of(context).unfocus();
//     if (!form.validate()) return;

//     setState(() => _loginLoading = true);
//     await Future.delayed(const Duration(seconds: 1)); // TODO: hook API
//     setState(() => _loginLoading = false);

//     if (!mounted) return;
//    Navigator.pushReplacement(
//   context,
//   MaterialPageRoute(builder: (context) => HomeScreen()),
// );
//     // ScaffoldMessenger.of(context).showSnackBar(
//     //   const SnackBar(content: Text('Logged in! (wire your API here)')),
//     // );
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
//       // similar light bg as HomeScreen
//       backgroundColor: const Color(0xFFF7F8FA),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(height: MediaQuery.of(context).size.height *0.10,),
//               // const SizedBox(height: 32),

//               // App title area (sober, like HomeScreen)
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

//               // Toggle
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

//               // Forms
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
//                 color: activeIndex == 0 ? AppTheme.primary : Colors.transparent,
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
//                 color: activeIndex == 1 ? AppTheme.primary : Colors.transparent,
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
//               decoration: TextDecoration.underline,
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

