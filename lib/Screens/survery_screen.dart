import 'package:flutter/material.dart';
import 'package:voice_assistant_project/Theme/theme.dart';

class SurveyScreenView extends StatefulWidget {
  const SurveyScreenView({super.key});

  @override
  State<SurveyScreenView> createState() => _SurveyScreenViewState();
}

class _SurveyScreenViewState extends State<SurveyScreenView> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _cnicCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _salesAmountCtrl = TextEditingController();
  final _commentCtrl = TextEditingController();

  bool _submitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _cnicCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _salesAmountCtrl.dispose();
    _commentCtrl.dispose();
    super.dispose();
  }

  // ---------- validators ----------

  String? _validateRequired(String? v, String field) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return '$field is required';
    return null;
  }

  String? _validatePhone(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Phone number is required';
    if (s.length < 8) return 'Enter a valid phone number';
    return null;
  }

  String? _validateCnic(String? v) {
    final s = (v ?? '').replaceAll(RegExp(r'\D'), '');
    if (s.isEmpty) return 'CNIC number is required';
    if (s.length != 13) return 'Enter 13-digit CNIC number';
    return null;
  }

  String? _validateAmount(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Sales amount is required';
    final value = double.tryParse(s);
    if (value == null || value <= 0) {
      return 'Enter a valid amount';
    }
    return null;
  }

  Future<void> _submitSurvey() async {
    final form = _formKey.currentState;
    if (form == null) return;

    FocusScope.of(context).unfocus();
    if (!form.validate()) return;

    setState(() => _submitting = true);

    // TODO: send to API
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _submitting = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Survey submitted successfully!')),
    );

    // Clear form after submit
    _formKey.currentState?.reset();
    _nameCtrl.clear();
    _phoneCtrl.clear();
    _cnicCtrl.clear();
    _addressCtrl.clear();
    _cityCtrl.clear();
    _salesAmountCtrl.clear();
    _commentCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Daily Sales Survey',
          style: TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.primary,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fill today’s sales details',
                  style: TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 13,
                    color: Color(0xFF75748A),
                  ),
                ),
                const SizedBox(height: 18),

                // Name
                _InputCard(
                  hint: 'Name',
                  icon: Icons.person_outline_rounded,
                  controller: _nameCtrl,
                  validator: (v) => _validateRequired(v, 'Name'),
                ),
                const SizedBox(height: 12),

                // Phone
                _InputCard(
                  hint: 'Phone Number',
                  icon: Icons.phone_rounded,
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  validator: _validatePhone,
                ),
                const SizedBox(height: 12),

                // CNIC
                _InputCard(
                  hint: 'CNIC Number (13 digits)',
                  icon: Icons.badge_outlined,
                  controller: _cnicCtrl,
                  keyboardType: TextInputType.number,
                  validator: _validateCnic,
                ),
                const SizedBox(height: 12),

                // Address
                _InputCard(
                  hint: 'Address',
                  icon: Icons.home_outlined,
                  controller: _addressCtrl,
                  validator: (v) => _validateRequired(v, 'Address'),
                ),
                const SizedBox(height: 12),

                // City
                _InputCard(
                  hint: 'City',
                  icon: Icons.location_city_outlined,
                  controller: _cityCtrl,
                  validator: (v) => _validateRequired(v, 'City'),
                ),
                const SizedBox(height: 12),

                // Sales Amount
                _InputCard(
                  hint: 'Sales Amount',
                  icon: Icons.attach_money_rounded,
                  controller: _salesAmountCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: _validateAmount,
                ),
                const SizedBox(height: 12),

                // Comment (multiline)
                _MultilineInputCard(
                  hint: 'Comment (3 lines max)',
                  icon: Icons.notes_rounded,
                  controller: _commentCtrl,
                  maxLines: 3,
                  validator: (v) => _validateRequired(v, 'Comment'),
                ),

                const SizedBox(height: 22),

                Center(
                  child: SizedBox(
                    width: 180,
                    height: 44,
                    child: _PrimaryGradientButton(
                      text: _submitting ? 'PLEASE WAIT...' : 'SUBMIT',
                      loading: _submitting,
                      onPressed: _submitting ? null : _submitSurvey,
                    ),
                  ),
                ),
              ],
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

class _MultilineInputCard extends StatelessWidget {
  const _MultilineInputCard({
    required this.hint,
    required this.icon,
    this.controller,
    this.validator,
    this.maxLines = 3,
  });

  final String hint;
  final IconData icon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: Container(
        // taller for multi-line
        constraints: const BoxConstraints(minHeight: 80),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.primary.withOpacity(.08),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Icon(icon, size: 20, color: AppTheme.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: controller,
                validator: validator,
                maxLines: maxLines,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  color: Color(0xFF1F1235),
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                  isCollapsed: false,
                  hintStyle: const TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    color: Color(0xFF9A8EB5),
                    fontSize: 13.5,
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
