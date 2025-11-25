import 'package:flutter/material.dart';
import 'package:voice_assistant_project/Theme/theme.dart';

class SurveyScreen extends StatelessWidget {
  static const String routeName = '/survey';

  const SurveyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: const Text(
          'Voice Survey',
          style: TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontWeight: FontWeight.w600,
            color: AppTheme.primary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Earn bonus points',
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3E1E69),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Record short voice answers to a few questions and collect '
              'extra reward points. This is just a placeholder screen – '
              'connect your real survey or voice assistant later.',
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 12.5,
                color: Color(0xFF75748A),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: 3,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final questions = [
                    'How often do you scan codes each week?',
                    'What motivates you to share points with friends?',
                    'What rewards would you like to see next?',
                  ];
                  return Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      leading: CircleAvatar(
                        backgroundColor:
                            AppTheme.primary.withOpacity(.08),
                        child: Text(
                          '${i + 1}',
                          style: const TextStyle(
                            fontFamily: AppTheme.fontFamily,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                      title: Text(
                        questions[i],
                        style: const TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: 13,
                        ),
                      ),
                      trailing:  Icon(Icons.mic_none_rounded,
                          color: AppTheme.primary),
                      onTap: () {
                        // ScaffoldMessenger.of(ctx)
                        //     .showSnackBar(const SnackBar(
                        //   content: Text('Voice capture not implemented.'),
                        // ));
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

