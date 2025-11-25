import 'package:flutter/material.dart';
import 'package:voice_assistant_project/Theme/theme.dart';
import 'package:voice_assistant_project/main.dart';

class SendPointsScreen extends StatefulWidget {
  static const String routeName = '/send-points';

  const SendPointsScreen({super.key});

  @override
  State<SendPointsScreen> createState() => _SendPointsScreenState();
}

class _SendPointsScreenState extends State<SendPointsScreen> {
  final _keyCtrl = TextEditingController();
  final _pointsCtrl = TextEditingController();

  @override
  void dispose() {
    _keyCtrl.dispose();
    _pointsCtrl.dispose();
    super.dispose();
  }

  void _send() {
    final pts = int.tryParse(_pointsCtrl.text.trim());
    if (pts == null || pts <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid points amount')),
      );
      return;
    }

    final key = _keyCtrl.text.trim();
    if (key.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter recipient key')),
      );
      return;
    }

    // check balance
    if (rewardPoints.value < pts) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not enough points to send')),
      );
      return;
    }

    // TODO: 🔗 Call backend API to actually transfer points here

    // local demo change
    rewardPoints.value -= pts;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sent $pts pts to $key'),
      ),
    );

    _keyCtrl.clear();
    _pointsCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 16,
        title: const Text(
          'Send points',
          style: TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 18,
            color: AppTheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMiniPointsSummary(),
              const SizedBox(height: 20),
              const Text(
                'Transfer points',
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3E1E69),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Use your friend’s unique key to transfer points. '
                'The key can refresh frequently for security.',
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 12.5,
                  color: Color(0xFF75748A),
                ),
              ),
              const SizedBox(height: 18),
              _SimpleInput(
                controller: _keyCtrl,
                label: 'Recipient key',
                hint: 'e.g. USER-XYZ-123',
                icon: Icons.vpn_key_rounded,
              ),
              const SizedBox(height: 12),
              _SimpleInput(
                controller: _pointsCtrl,
                label: 'Points to send',
                hint: 'e.g. 50',
                icon: Icons.stars_rounded,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: _send,
                  child: const Text(
                    'Send points',
                    style: TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniPointsSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.02),
            blurRadius: 18,
            offset: const Offset(0, 12),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.stars_rounded,
              color: AppTheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ValueListenableBuilder<int>(
              valueListenable: rewardPoints,
              builder: (context, value, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Available points',
                      style: TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 12.5,
                        color: Color(0xFF75748A),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$value pts',
                      style: const TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3E1E69),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SimpleInput extends StatelessWidget {
  const _SimpleInput({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 14.5,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: label,
            labelStyle: const TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 13,
              color: Color(0xFF9A8EB5),
            ),
            hintText: hint,
            hintStyle: const TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 13,
              color: Color(0xFFB1A4CC),
            ),
            icon: Icon(icon, color: AppTheme.primary, size: 20),
          ),
        ),
      ),
    );
  }
}
