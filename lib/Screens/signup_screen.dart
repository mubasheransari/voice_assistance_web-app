import 'package:flutter/material.dart';
import 'package:voice_assistant_project/Theme/theme.dart';


import 'package:flutter/material.dart';
import '../Theme/theme.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup';

  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _loading = false);

  //  Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primary, AppTheme.green],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(26)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Create your account ✨',
                    style: TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Start scanning and earn shareable rewards.',
                    style: TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Full name',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Enter your name' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Enter your email';
                          }
                          if (!v.contains('@')) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                        ),
                        validator: (v) =>
                            (v == null || v.length < 6)
                                ? 'Password must be 6+ chars'
                                : null,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _onSignup,
                          child: _loading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.3,
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  ),
                                )
                              : const Text('Sign up'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account?',
                            style: TextStyle(
                              fontFamily: AppTheme.fontFamily,
                              fontSize: 13,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigator.pushReplacementNamed(
                              //     context, LoginScreen.routeName);
                            },
                            child: const Text('Sign in'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});

//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameCtrl = TextEditingController();
//   final _emailCtrl = TextEditingController();
//   final _passwordCtrl = TextEditingController();
//   final _confirmCtrl = TextEditingController();
//   final _referralCtrl = TextEditingController();

//   bool _obscurePass = true;
//   bool _obscureConfirm = true;
//   bool _loading = false;

//   @override
//   void dispose() {
//     _nameCtrl.dispose();
//     _emailCtrl.dispose();
//     _passwordCtrl.dispose();
//     _confirmCtrl.dispose();
//     _referralCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _signup() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _loading = true);

//     // 🔹 TODO: call your signup API here, sending referral code also.
//     await Future.delayed(const Duration(seconds: 1));

//     setState(() => _loading = false);

//     if (!mounted) return;

//     if (_referralCtrl.text.trim().isNotEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//               'Referral code "${_referralCtrl.text.trim()}" applied successfully!'),
//           backgroundColor: AppTheme.primary,
//         ),
//       );
//     }

//     // On success → go to home & clear previous stack
//     Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               SizedBox(height: size.height * 0.05),
//               const Icon(
//                 Icons.card_membership_rounded,
//                 color: AppTheme.primary,
//                 size: 72,
//               ),
//               const SizedBox(height: 12),
//               const Text(
//                 'Join  Loyalty',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w800,
//                   color: AppTheme.primary,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 'Create account & start earning points',
//                 style: TextStyle(
//                   color: Colors.grey.shade700,
//                   fontSize: 13,
//                 ),
//               ),
//               SizedBox(height: size.height * 0.04),
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(18),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Sign up',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w700,
//                             color: AppTheme.primary,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         TextFormField(
//                           controller: _nameCtrl,
//                           decoration: const InputDecoration(
//                             labelText: 'Full Name',
//                             prefixIcon: Icon(Icons.person_outline_rounded),
//                           ),
//                           validator: (v) {
//                             if (v == null || v.trim().isEmpty) {
//                               return 'Name is requi';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 12),
//                         TextFormField(
//                           controller: _emailCtrl,
//                           keyboardType: TextInputType.emailAddress,
//                           decoration: const InputDecoration(
//                             labelText: 'Email',
//                             prefixIcon: Icon(Icons.email_outlined),
//                           ),
//                           validator: (v) {
//                             if (v == null || v.trim().isEmpty) {
//                               return 'Email is requi';
//                             }
//                             if (!v.contains('@')) {
//                               return 'Enter a valid email';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 12),
//                         TextFormField(
//                           controller: _passwordCtrl,
//                           obscureText: _obscurePass,
//                           decoration: InputDecoration(
//                             labelText: 'Password',
//                             prefixIcon: const Icon(Icons.lock_outline),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _obscurePass
//                                     ? Icons.visibility_off_rounded
//                                     : Icons.visibility_rounded,
//                               ),
//                               onPressed: () {
//                                 setState(() => _obscurePass = !_obscurePass);
//                               },
//                             ),
//                           ),
//                           validator: (v) {
//                             if (v == null || v.isEmpty) {
//                               return 'Password is requi';
//                             }
//                             if (v.length < 6) {
//                               return 'Minimum 6 characters';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 12),
//                         TextFormField(
//                           controller: _confirmCtrl,
//                           obscureText: _obscureConfirm,
//                           decoration: InputDecoration(
//                             labelText: 'Confirm Password',
//                             prefixIcon: const Icon(Icons.lock_reset_rounded),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _obscureConfirm
//                                     ? Icons.visibility_off_rounded
//                                     : Icons.visibility_rounded,
//                               ),
//                               onPressed: () {
//                                 setState(
//                                     () => _obscureConfirm = !_obscureConfirm);
//                               },
//                             ),
//                           ),
//                           validator: (v) {
//                             if (v == null || v.isEmpty) {
//                               return 'Please confirm password';
//                             }
//                             if (v != _passwordCtrl.text) {
//                               return 'Passwords do not match';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 12),
//                         TextFormField(
//                           controller: _referralCtrl,
//                           decoration: const InputDecoration(
//                             labelText: 'Referral Code (optional)',
//                             prefixIcon: Icon(Icons.card_giftcard_rounded),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             onPressed: _loading ? null : _signup,
//                             child: _loading
//                                 ? const SizedBox(
//                                     height: 18,
//                                     width: 18,
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       valueColor:
//                                           AlwaysStoppedAnimation(Colors.white),
//                                     ),
//                                   )
//                                 : const Text('Create Account'),
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         Center(
//                           child: TextButton(
//                             onPressed: () {
//                               Navigator.pushReplacementNamed(
//                                   context, '/login');
//                             },
//                             child: const Text(
//                               'Already have an account? Login',
//                               style: TextStyle(color: AppTheme.primary),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
