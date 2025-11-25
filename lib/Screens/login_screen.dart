import 'package:flutter/material.dart';
import 'package:voice_assistant_project/Theme/theme.dart';


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

  Future<void> _submitLogin() async {
    final form = _loginFormKey.currentState;
    if (form == null) return;
    FocusScope.of(context).unfocus();
    if (!form.validate()) return;

    setState(() => _loginLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // TODO: hook API
    setState(() => _loginLoading = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged in! (wire your API here)')),
    );
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
      // similar light bg as HomeScreen
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height *0.10,),
              // const SizedBox(height: 32),

              // App title area (sober, like HomeScreen)
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

              // Toggle
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

              // Forms
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
            width: 190,
            height: 46,
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
            width: 190,
            height: 46,
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
                color: activeIndex == 0 ? AppTheme.primary : Colors.transparent,
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
                color: activeIndex == 1 ? AppTheme.primary : Colors.transparent,
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
//   int tab = 0; // 0 = login, 1 = signup

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

//   final _scrollCtrl = ScrollController();
//   double _scrollY = 0.0;

//   static const _purple = Color(0xFF5C2E91);
//   static const _reddish = Color(0xFFE85B7F);
//   static const _bgLight = Color(0xFFF7F4FF);

//   @override
//   void initState() {
//     super.initState();
//     _scrollCtrl.addListener(() {
//       if (!_scrollCtrl.hasClients) return;
//       if (tab != 1) return;
//       final off = _scrollCtrl.offset;
//       if (off != _scrollY) {
//         setState(() => _scrollY = off);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _loginEmailCtrl.dispose();
//     _loginPassCtrl.dispose();
//     _signupNameCtrl.dispose();
//     _signupEmailCtrl.dispose();
//     _signupPhoneCtrl.dispose();
//     _signupPassCtrl.dispose();
//     _signupConfirmCtrl.dispose();
//     _scrollCtrl.dispose();
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
    

//     // final form = _loginFormKey.currentState;
//     // if (form == null) return;
//     // FocusScope.of(context).unfocus();
//     // if (!form.validate()) return;

//     // setState(() => _loginLoading = true);
//     // await Future.delayed(const Duration(seconds: 1)); // TODO: hook API
//     // setState(() => _loginLoading = false);

//     // if (!mounted) return;
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
//     final size = MediaQuery.of(context).size;

//     final double baseTop = tab == 0 ? 26.0 : 4.0;
//     final double logoTop = tab == 1 ? (baseTop - _scrollY) : baseTop;

//     return Scaffold(
//       backgroundColor: _bgLight,
//       body: Stack(
//         children: [
//           // very soft purple / reddish gradient background
//           Positioned.fill(
//             child: Container(
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Color(0xFFFFFFFF),
//                     Color(0xFFFDE8F0),
//                     _bgLight,
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//             ),
//           ),

//           // glass card
//           SafeArea(
//             child: Center(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: size.width < 380 ? 16 : 22,
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(26),
//                   child: BackdropFilter(
//                     filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
//                     child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.85),
//                         borderRadius: BorderRadius.circular(26),
//                         border: Border.all(
//                           color: _purple.withOpacity(0.10),
//                           width: 1,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: _purple.withOpacity(0.12),
//                             blurRadius: 24,
//                             offset: const Offset(0, 12),
//                           ),
//                         ],
//                       ),
//                       child: SingleChildScrollView(
//                         controller: _scrollCtrl,
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const SizedBox(height: 130),
//                             _AuthToggle(
//                               activeIndex: tab,
//                               onChanged: (i) {
//                                 FocusScope.of(context).unfocus();
//                                 _loginFormKey.currentState?.reset();
//                                 _signupFormKey.currentState?.reset();
//                                 if (_scrollCtrl.hasClients) {
//                                   _scrollCtrl.jumpTo(0);
//                                 }
//                                 setState(() {
//                                   tab = i;
//                                   _scrollY = 0;
//                                 });
//                               },
//                             ),
//                             const SizedBox(height: 22),
//                             if (tab == 0) _buildLoginForm(),
//                             if (tab == 1) _buildSignupForm(),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // logo + title
//           Positioned(
//             top: 160,
//             left: 0,
//             right: 0,
//             child: IgnorePointer(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: const [
//                   // CircleAvatar(
//                   //   radius: 34,
//                   //   backgroundColor: Colors.white,
//                   //   child: Icon(
//                   //     Icons.qr_code_scanner_rounded,
//                   //     size: 34,
//                   //     color: _purple,
//                   //   ),
//                   // ),
//                   // SizedBox(height: 10),
//                   Text(
//                     'Loyality App',
//                     style: TextStyle(
//                       fontFamily: 'Poppins',
//                       fontSize: 22,
//                       fontWeight: FontWeight.w700,
//                       color: _purple,
//                       letterSpacing: 0.4,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     'Order,Scan & Earn points. Share with friends.',
//                     style: TextStyle(
//                       fontFamily: 'Poppins',
//                       fontSize: 12.5,
//                       color: Color(0xFF7C7890),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
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
//                   fontFamily: 'Poppins',
//                   fontSize: 13.5,
//                   fontWeight: FontWeight.w600,
//                   color: _purple,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 6),
//           SizedBox(
//             width: 180,
//             height: 46,
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
//             height: 46,
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


// class _AuthToggle extends StatelessWidget {
//   const _AuthToggle({required this.activeIndex, required this.onChanged});
//   final int activeIndex;
//   final ValueChanged<int> onChanged;

//   static const _grad = LinearGradient(
//     colors: [Color(0xFF5C2E91), Color(0xFFE85B7F)],
//     begin: Alignment.centerLeft,
//     end: Alignment.centerRight,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 44,
//       decoration: BoxDecoration(
//         color: const Color(0xFFF5EEFF),
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(
//           color: const Color(0xFFDDC9FF),
//           width: 1,
//         ),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: AnimatedContainer(
//               height: 44,
//               duration: const Duration(milliseconds: 220),
//               decoration: BoxDecoration(
//                 gradient: activeIndex == 0 ? _grad : null,
//                 borderRadius: BorderRadius.circular(22),
//               ),
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(22),
//                 onTap: () => onChanged(0),
//                 child: Center(
//                   child: Text(
//                     'Login',
//                     style: TextStyle(
//                       fontFamily: 'Poppins',
//                       fontSize: 16,
//                       fontWeight: FontWeight.w700,
//                       color: activeIndex == 0
//                           ? Colors.white
//                           : const Color(0xFF5C2E91),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: AnimatedContainer(
//               height: 44,
//               duration: const Duration(milliseconds: 220),
//               decoration: BoxDecoration(
//                 gradient: activeIndex == 1 ? _grad : null,
//                 borderRadius: BorderRadius.circular(22),
//               ),
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(22),
//                 onTap: () => onChanged(1),
//                 child: Center(
//                   child: Text(
//                     'Sign up',
//                     style: TextStyle(
//                       fontFamily: 'Poppins',
//                       fontSize: 16,
//                       fontWeight: FontWeight.w700,
//                       color: activeIndex == 1
//                           ? Colors.white
//                           : const Color(0xFF5C2E91),
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

//   static const _purple = Color(0xFF5C2E91);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 56,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(
//           color: _purple.withOpacity(0.10),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 16,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 14),
//       child: Row(
//         children: [
//           Icon(icon, size: 20, color: _purple),
//           const SizedBox(width: 10),
//           Expanded(
//             child: TextFormField(
//               controller: controller,
//               keyboardType: keyboardType,
//               validator: validator,
//               obscureText: obscureText,
//               style: const TextStyle(
//                 fontFamily: 'Poppins',
//                 color: Color(0xFF1F1235),
//                 fontSize: 14.5,
//                 fontWeight: FontWeight.w600,
//               ),
//               decoration: InputDecoration(
//                 hintText: hint,
//                 border: InputBorder.none,
//                 isCollapsed: true,
//                 contentPadding: const EdgeInsets.symmetric(vertical: 10),
//                 hintStyle: const TextStyle(
//                   fontFamily: 'Poppins',
//                   color: Color(0xFF9A8EB5),
//                   fontSize: 14,
//                 ),
//               ),
//             ),
//           ),
//           if (onToggleObscure != null)
//             IconButton(
//               onPressed: onToggleObscure,
//               icon: Icon(
//                 obscureText
//                     ? Icons.visibility_off_outlined
//                     : Icons.visibility_outlined,
//                 size: 20,
//                 color: const Color(0xFFB1A4CC),
//               ),
//             ),
//         ],
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
//             fontFamily: 'Poppins',
//             fontSize: 13.5,
//             color: Color(0xFF7C7890),
//           ),
//         ),
//         GestureDetector(
//           onTap: onTap,
//           child: Text(
//             action,
//             style: const TextStyle(
//               fontFamily: 'Poppins',
//               fontSize: 13.5,
//               color: Color(0xFFE85B7F),
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

//   static const _grad = LinearGradient(
//     colors: [Color(0xFF5C2E91), Color(0xFFE85B7F)],
//     begin: Alignment.centerLeft,
//     end: Alignment.centerRight,
//   );

//   @override
//   Widget build(BuildContext context) {
//     final disabled = loading || onPressed == null;

//     return Opacity(
//       opacity: disabled ? 0.7 : 1,
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(28),
//           gradient: _grad,
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFF5C2E91).withOpacity(0.30),
//               blurRadius: 20,
//               offset: const Offset(0, 9),
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
//                     const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
//                           fontFamily: 'Poppins',
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
