import 'package:flutter/material.dart';
import 'package:voice_assistant_project/Theme/theme.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  final _formKey = GlobalKey<FormState>();
  int _rating = 0;
  String? _selectedFrequency;
  final _feedbackCtrl = TextEditingController();

  final List<String> _frequencies = [
    'First time',
    'Weekly',
    'Monthly',
    'Rarely',
  ];

  @override
  void dispose() {
    _feedbackCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate() || _rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all requi fields.'),
          backgroundColor: AppTheme.primary,
        ),
      );
      return;
    }

    // Example: Give 20 points for completing survey
    Navigator.pop<int>(context, 20);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback Survey'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tell us about your experience',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '1. How satisfied are you with our service?',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (i) {
                      final index = i + 1;
                      final selected = index <= _rating;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _rating = index;
                          });
                        },
                        child: Icon(
                          Icons.favorite_rounded,
                          size: 30,
                          color: selected
                              ? AppTheme.primary
                              : Colors.grey.shade300,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '2. How often do you use our service?',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedFrequency,
                    decoration: const InputDecoration(
                      labelText: 'Select frequency',
                    ),
                    items: _frequencies
                        .map((f) => DropdownMenuItem(
                              value: f,
                              child: Text(f),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() {
                      _selectedFrequency = value;
                    }),
                    validator: (value) =>
                        value == null ? 'Please select one option' : null,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '3. Any suggestion to improve?',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _feedbackCtrl,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Write your feedback here...',
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Please write something'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.stars_rounded),
                      label: const Text('Submit & Earn 20 Points'),
                      onPressed: _submit,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
