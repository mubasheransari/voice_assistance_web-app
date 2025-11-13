import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math' show Random, sin, pi;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'dart:math' show Random, sin, pi;
import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const MyApp());
}
//phone number, name, gender, city, age, profession , review
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mezan Chai Assistant',
      theme: ThemeData(
        fontFamily: 'Poppins',
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFEC4899),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const VoiceAssistantChatScreen(),
    );
  }
}

/* ---------- MODELS ---------- */

enum ChatRole { user, bot }

class ChatMessage {
  final String id;
  final ChatRole role;
  final String text;
  final DateTime ts;

  ChatMessage({
    required this.id,
    required this.role,
    required this.text,
    required this.ts,
  });
}

class QaItem {
  final String question;
  final String answer;

  const QaItem({
    required this.question,
    required this.answer,
  });
}

/* ---------- SAMPLE Q&A (Mezan Chai – 5 items) ---------- */

const kQaData = <QaItem>[
  QaItem(
    question: 'Why was Mezan Chai manufactured?',
    answer:
        'Mezan Chai was manufactured with one core purpose: to bring families together so they can enjoy a warm cup of tea that reflects the same warmth found in a family’s love.',
  ),
  QaItem(
    question: 'How does Mezan Chai help bring families together?',
    answer:
        'Mezan Chai helps bring families together by creating a shared moment around a warm cup of tea. It is made to be enjoyed with your loved ones, turning simple tea time into quality family time.',
  ),
  QaItem(
    question: 'What kind of warmth does Mezan Chai aim to create for families?',
    answer:
        'Mezan Chai aims to create the same comforting warmth that radiates from a family’s love — a feeling of closeness, care, and togetherness around every cup.',
  ),
  QaItem(
    question: 'What strict precautions are taken while producing Mezan Chai products?',
    answer:
        'Mezan Chai is produced with strict precautions at every stage, from selecting tea leaves to processing and packing, so that each product maintains high quality, great taste, and supports your well-being.',
  ),
  QaItem(
    question:
        'How does Mezan Chai ensure every cup is both rich in taste and good for your health?',
    answer:
        'By following careful production standards and strict quality controls, Mezan Chai ensures that every cup is rich in taste while also invigorating your health, so you enjoy flavour and reassurance in every sip.',
  ),
];

/* ---------- THEME CONSTANTS ---------- */

const _kText = Color(0xFFE5E7EB);
const _kMuted = Color(0xFF9CA3AF);
const _kAccent = Color(0xFFEC4899); // pink accent
const _kAccent2 = Color(0xFF8B5CF6); // purple accent

/* ---------- GLASS WIDGET HELPER ---------- */

class Glass extends StatelessWidget {
  const Glass({
    super.key,
    required this.child,
    this.radius = 24,
    this.padding,
  });

  final Widget child;
  final double radius;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: Colors.white.withOpacity(0.08),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
              width: 1.0,
            ),
          ),
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}

/* ---------- SCREEN ---------- */

class VoiceAssistantChatScreen extends StatefulWidget {
  const VoiceAssistantChatScreen({super.key});

  @override
  State<VoiceAssistantChatScreen> createState() =>
      _VoiceAssistantChatScreenState();
}

class _VoiceAssistantChatScreenState extends State<VoiceAssistantChatScreen> {
  final FlutterTts _tts = FlutterTts();
  final ScrollController _scroll = ScrollController();
  final TextEditingController _textCtl = TextEditingController();

  final List<ChatMessage> _messages = [];
  bool _typing = false;
  String? _speakingId;

  @override
  void initState() {
    super.initState();
    _initTts();
    _seedWelcome();
  }

  void _initTts() {
    _tts.setLanguage('en-US');
    _tts.setSpeechRate(0.5);
    _tts.setPitch(1.0);

    _tts.setStartHandler(() {
      setState(() {});
    });

    _tts.setCompletionHandler(() {
      setState(() {
        _speakingId = null;
      });
    });

    _tts.setErrorHandler((msg) {
      setState(() {
        _speakingId = null;
      });
    });
  }

  void _seedWelcome() {
    _messages.add(
      ChatMessage(
        id: 'm0',
        role: ChatRole.bot,
        text:
            'Welcome to the Mezan Chai assistant.\nAsk anything about our tea, or tap a question chip below to hear about our warmth, taste, and care for your health.',
        ts: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _textCtl.dispose();
    _scroll.dispose();
    _tts.stop();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent + 120,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  QaItem _pickAnswer(String q) {
    final norm = q.toLowerCase().trim();
    for (final item in kQaData) {
      if (item.question.toLowerCase() == norm) return item;
    }
    // fallback: random answer if user types something else
    final rnd = Random();
    return kQaData[rnd.nextInt(kQaData.length)];
  }

  Future<void> _onSend(String raw) async {
    final text = raw.trim();
    if (text.isEmpty) return;

    final user = ChatMessage(
      id: 'u${DateTime.now().microsecondsSinceEpoch}',
      role: ChatRole.user,
      text: text,
      ts: DateTime.now(),
    );

    setState(() {
      _messages.add(user);
      _typing = true;
    });
    _textCtl.clear();
    _scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 400));

    final qa = _pickAnswer(text);
    final bot = ChatMessage(
      id: 'b${DateTime.now().microsecondsSinceEpoch}',
      role: ChatRole.bot,
      text: qa.answer,
      ts: DateTime.now(),
    );

    setState(() {
      _messages.add(bot);
      _typing = false;
    });
    _scrollToBottom();

    await _speak(bot);
  }

  Future<void> _speak(ChatMessage msg) async {
    if (msg.role != ChatRole.bot) return;

    if (_speakingId == msg.id) {
      await _tts.stop();
      setState(() {
        _speakingId = null;
      });
      return;
    }

    await _tts.stop();
    setState(() {
      _speakingId = msg.id;
    });
    await _tts.speak(msg.text);
  }

  Future<void> _onTapSuggestion(String q) async {
    await _onSend(q);
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
      _typing = false;
      _speakingId = null;
      _seedWelcome();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Gradient background for glassmorphism
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF020617),
              Color(0xFF111827),
              Color(0xFF1F2937),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Soft blurred blobs behind
            Positioned(
              top: -80,
              left: -40,
              child: _Blob(
                color: const Color(0xFFEC4899).withOpacity(0.35),
                size: 220,
              ),
            ),
            Positioned(
              bottom: -60,
              right: -30,
              child: _Blob(
                color: const Color(0xFF8B5CF6).withOpacity(0.4),
                size: 260,
              ),
            ),
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // HEADER
                        Glass(
                          radius: 20,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [_kAccent, _kAccent2],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _kAccent.withOpacity(0.5),
                                      blurRadius: 18,
                                      offset: const Offset(0, 6),
                                    )
                                  ],
                                ),
                                child: const Icon(
                                  Icons.local_cafe_rounded,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mezan Chai Assistant',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: _kText,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Warmth, taste & health — in every answer.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _kMuted,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              IconButton(
                                tooltip: 'Clear chat',
                                onPressed: _clearChat,
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: _kMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // MAIN GLASS CHAT CARD
                        Expanded(
                          child: Glass(
                            radius: 26,
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                            child: Column(
                              children: [
                                // Suggestion chips
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Suggested questions',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  height: 40,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: kQaData.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(width: 8),
                                    itemBuilder: (_, i) {
                                      final q = kQaData[i].question;
                                      return _GlassChip(
                                        label: q,
                                        onTap: () => _onTapSuggestion(q),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Divider(
                                  color: Colors.white.withOpacity(0.15),
                                  height: 1,
                                ),
                                const SizedBox(height: 12),

                                // Chat list
                                Expanded(
                                  child: ListView.builder(
                                    controller: _scroll,
                                    padding: const EdgeInsets.only(bottom: 8),
                                    itemCount:
                                        _messages.length + (_typing ? 1 : 0),
                                    itemBuilder: (context, index) {
                                      if (_typing &&
                                          index == _messages.length) {
                                        return const _TypingBubble();
                                      }

                                      final m = _messages[index];
                                      final isUser =
                                          m.role == ChatRole.user;

                                      return Column(
                                        crossAxisAlignment: isUser
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: isUser
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                            child: _ChatBubble(
                                              message: m,
                                              isSpeaking:
                                                  _speakingId == m.id,
                                              onCopy: () =>
                                                  Clipboard.setData(
                                                ClipboardData(
                                                  text: m.text,
                                                ),
                                              ),
                                              onSpeak: m.role ==
                                                      ChatRole.bot
                                                  ? () => _speak(m)
                                                  : null,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      );
                                    },
                                  ),
                                ),

                                // Input row
                                Glass(
                                  radius: 18,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _textCtl,
                                          textInputAction:
                                              TextInputAction.send,
                                          onSubmitted: _onSend,
                                          style: const TextStyle(
                                            color: _kText,
                                            fontSize: 14,
                                          ),
                                          decoration:
                                              const InputDecoration(
                                            hintText:
                                                'Ask something about Mezan Chai…',
                                            hintStyle: TextStyle(
                                              color: _kMuted,
                                            ),
                                            border: InputBorder.none,
                                            isDense: true,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [_kAccent, _kAccent2],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(999),
                                          boxShadow: [
                                            BoxShadow(
                                              color: _kAccent
                                                  .withOpacity(0.6),
                                              blurRadius: 14,
                                              offset:
                                                  const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: IconButton(
                                          onPressed: () =>
                                              _onSend(_textCtl.text),
                                          icon: const Icon(
                                            Icons.send_rounded,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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

/* ---------- GLASS CHIP ---------- */

class _GlassChip extends StatelessWidget {
  const _GlassChip({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: 999,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 14,
              color: _kMuted,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: _kText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------- BUBBLES & TYPING INDICATOR ---------- */

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    required this.message,
    required this.isSpeaking,
    this.onCopy,
    this.onSpeak,
  });

  final ChatMessage message;
  final bool isSpeaking;
  final VoidCallback? onCopy;
  final VoidCallback? onSpeak;

  bool get isUser => message.role == ChatRole.user;

  @override
  Widget build(BuildContext context) {
    if (isUser) {
      // User bubble: gradient pill
      return Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.fromLTRB(14, 10, 12, 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_kAccent, _kAccent2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(4),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: _kAccent.withOpacity(0.6),
              blurRadius: 18,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              message.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14.5,
                height: 1.35,
              ),
            ),
          ],
        ),
      );
    }

    // Bot bubble: glass card
    return Glass(
      radius: 18,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            message.text,
            style: const TextStyle(
              color: _kText,
              fontSize: 14.5,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onCopy != null)
                _MiniIconButton(
                  icon: Icons.copy_rounded,
                  label: 'Copy',
                  onTap: onCopy!,
                ),
              if (onSpeak != null) const SizedBox(width: 4),
              if (onSpeak != null)
                _MiniIconButton(
                  icon: isSpeaking
                      ? Icons.stop_rounded
                      : Icons.volume_up_rounded,
                  label: isSpeaking ? 'Stop' : 'Listen',
                  onTap: onSpeak!,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniIconButton extends StatelessWidget {
  const _MiniIconButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: _kMuted),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: _kMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Glass(
        radius: 16,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: const _Dots(),
      ),
    );
  }
}

class _Dots extends StatefulWidget {
  const _Dots();

  @override
  State<_Dots> createState() => _DotsState();
}

class _DotsState extends State<_Dots> with SingleTickerProviderStateMixin {
  late final AnimationController _ctl;

  @override
  void initState() {
    super.initState();
    _ctl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctl,
      builder: (_, __) {
        final v = (sin(_ctl.value * 2 * pi) + 1) / 2;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final size = 6.0 +
                (i == 0
                    ? v
                    : i == 1
                        ? (1 - v)
                        : v) *
                    3;
            return Container(
              width: size,
              height: size,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}

/* ---------- BACKGROUND BLOB ---------- */

class _Blob extends StatelessWidget {
  const _Blob({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.7),
            blurRadius: 60,
            spreadRadius: 10,
          ),
        ],
      ),
    );
  }
}



/*

void main() {
  runApp(const MyApp());
}




class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Voice Assistant',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5C2D91)),
        useMaterial3: true,
      ),
      home: const VoiceAssistantChatScreen(),
    );
  }
}

/* ---------- MODELS ---------- */

enum ChatRole { user, bot }

class ChatMessage {
  final String id;
  final ChatRole role;
  final String text;
  final DateTime ts;

  ChatMessage({
    required this.id,
    required this.role,
    required this.text,
    required this.ts,
  });
}

class QaItem {
  final String question;
  final String answer;

  const QaItem({
    required this.question,
    required this.answer,
  });
}

/* ---------- SAMPLE Q&A (5 items) ---------- */

const kQaData = <QaItem>[
  QaItem(
    question: 'What services do you provide?',
    answer:
        'I can help you with cleaning, plumbing, electrical work, moving, and more on-demand home services.',
  ),
  QaItem(
    question: 'How do I book a service?',
    answer:
        'Just pick a service, choose your time slot, add your address, and confirm your booking. You will get a confirmation instantly.',
  ),
  QaItem(
    question: 'Can I cancel or reschedule?',
    answer:
        'Yes, you can cancel or reschedule your booking from the app before the service start time, subject to policy.',
  ),
  QaItem(
    question: 'Do you offer same-day service?',
    answer:
        'Same-day service is available in many areas, depending on tasker availability. Try choosing today’s date when you book.',
  ),
  QaItem(
    question: 'How do I contact support?',
    answer:
        'You can reach support from the Help section in the app. Chat and email support are available during working hours.',
  ),
];

/* ---------- THEME ---------- */

const _kBg = Color(0xFFF5F3FF);
const _kCard = Colors.white;
const _kText = Color(0xFF1E1E1E);
const _kMuted = Color(0xFF707883);
const _kAccent = Color(0xFF5C2D91);

/* ---------- SCREEN ---------- */

class VoiceAssistantChatScreen extends StatefulWidget {
  const VoiceAssistantChatScreen({super.key});

  @override
  State<VoiceAssistantChatScreen> createState() =>
      _VoiceAssistantChatScreenState();
}

class _VoiceAssistantChatScreenState extends State<VoiceAssistantChatScreen>
    with TickerProviderStateMixin {
  final _tts = FlutterTts();
  final _scroll = ScrollController();
  final _textCtl = TextEditingController();

  final List<ChatMessage> _messages = [];
  bool _typing = false;
  String? _speakingId;

  @override
  void initState() {
    super.initState();
    _initTts();
    _seedWelcome();
  }

  void _initTts() {
    _tts.setLanguage('en-US');
    _tts.setSpeechRate(0.5);
    _tts.setPitch(1.0);

    _tts.setStartHandler(() {
      setState(() {});
    });

    _tts.setCompletionHandler(() {
      setState(() {
        _speakingId = null;
      });
    });

    _tts.setErrorHandler((msg) {
      setState(() {
        _speakingId = null;
      });
    });
  }

  void _seedWelcome() {
    _messages.add(
      ChatMessage(
        id: 'm0',
        role: ChatRole.bot,
        text:
            'Hi! I am your mini voice assistant. Tap a question below or type your own to hear my answer.',
        ts: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _textCtl.dispose();
    _scroll.dispose();
    _tts.stop();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent + 120,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  QaItem _pickAnswer(String q) {
    final norm = q.toLowerCase().trim();
    for (final item in kQaData) {
      if (item.question.toLowerCase() == norm) return item;
    }
    // fallback: random answer
    final rnd = Random();
    return kQaData[rnd.nextInt(kQaData.length)];
  }

  Future<void> _onSend(String raw) async {
    final text = raw.trim();
    if (text.isEmpty) return;

    // user message
    final user = ChatMessage(
      id: 'u${DateTime.now().microsecondsSinceEpoch}',
      role: ChatRole.user,
      text: text,
      ts: DateTime.now(),
    );

    setState(() {
      _messages.add(user);
      _typing = true;
    });
    _textCtl.clear();
    _scrollToBottom();

    // small delay for "typing" feel
    await Future.delayed(const Duration(milliseconds: 400));

    final qa = _pickAnswer(text);
    final bot = ChatMessage(
      id: 'b${DateTime.now().microsecondsSinceEpoch}',
      role: ChatRole.bot,
      text: qa.answer,
      ts: DateTime.now(),
    );

    setState(() {
      _messages.add(bot);
      _typing = false;
    });
    _scrollToBottom();

    await _speak(bot);
  }

  Future<void> _speak(ChatMessage msg) async {
    if (msg.role != ChatRole.bot) return;

    // toggle stop if same message
    if (_speakingId == msg.id) {
      await _tts.stop();
      setState(() {
        _speakingId = null;
      });
      return;
    }

    await _tts.stop();
    setState(() {
      _speakingId = msg.id;
    });
    await _tts.speak(msg.text);
  }

  Future<void> _onTapSuggestion(String q) async {
    await _onSend(q);
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
      _seedWelcome();
      _typing = false;
      _speakingId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            // header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Icon(Icons.smart_toy_rounded, color: _kAccent),
                  const SizedBox(width: 8),
                  const Text(
                    'Voice Assistant',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: _kText,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Clear chat',
                    onPressed: _clearChat,
                    icon: const Icon(Icons.delete_outline, color: _kMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // suggestions row (like Smart FAQ chips)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
              color: _kCard,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Try asking:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _kMuted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: kQaData.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        final q = kQaData[i].question;
                        return ActionChip(
                          label: Text(
                            q,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onPressed: () => _onTapSuggestion(q),
                          backgroundColor: Colors.white,
                          side:
                              const BorderSide(color: Color(0xFFEDEFF2)),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // chat list
            Expanded(
              child: ListView.builder(
                controller: _scroll,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                itemCount: _messages.length + (_typing ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_typing && index == _messages.length) {
                    return const _TypingBubble();
                  }

                  final m = _messages[index];
                  final isUser = m.role == ChatRole.user;
                  return Column(
                    crossAxisAlignment: isUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: _ChatBubble(
                          message: m,
                          isSpeaking: _speakingId == m.id,
                          onCopy: () => Clipboard.setData(
                              ClipboardData(text: m.text)),
                          onSpeak: m.role == ChatRole.bot
                              ? () => _speak(m)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ),

            // composer (input + send button)
            Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
              decoration: const BoxDecoration(
                color: _kCard,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x11000000),
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xFFEDEFF2)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _textCtl,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (value) => _onSend(value),
                        decoration: const InputDecoration(
                          hintText: 'Type a question…',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                    ),
                    onPressed: () => _onSend(_textCtl.text),
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: const Text('Ask'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------- BUBBLES & TYPING INDICATOR ---------- */

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    required this.message,
    required this.isSpeaking,
    this.onCopy,
    this.onSpeak,
  });

  final ChatMessage message;
  final bool isSpeaking;
  final VoidCallback? onCopy;
  final VoidCallback? onSpeak;

  bool get isUser => message.role == ChatRole.user;

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isUser ? _kAccent : _kCard;
    final textColor = isUser ? Colors.white : _kText;

    return Container(
      constraints: const BoxConstraints(maxWidth: 640),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: BorderRadius.circular(16),
        border:
            isUser ? null : Border.all(color: const Color(0xFFEDEFF2)),
        boxShadow: isUser
            ? const []
            : const [
                BoxShadow(
                    color: Color(0x11000000),
                    blurRadius: 8,
                    offset: Offset(0, 2)),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            message.text,
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              height: 1.28,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onCopy != null)
                _MiniIconButton(
                  icon: Icons.copy_rounded,
                  label: 'Copy',
                  onTap: onCopy!,
                ),
              if (onSpeak != null) const SizedBox(width: 4),
              if (onSpeak != null)
                _MiniIconButton(
                  icon: isSpeaking
                      ? Icons.stop_rounded
                      : Icons.volume_up_rounded,
                  label: isSpeaking ? 'Stop' : 'Listen',
                  onTap: onSpeak!,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniIconButton extends StatelessWidget {
  const _MiniIconButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style =
        Theme.of(context).textTheme.bodySmall?.copyWith(color: _kMuted);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: _kMuted),
            const SizedBox(width: 4),
            Text(label, style: style),
          ],
        ),
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFEDEFF2)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const _Dots(),
      ),
    );
  }
}

class _Dots extends StatefulWidget {
  const _Dots();

  @override
  State<_Dots> createState() => _DotsState();
}

class _DotsState extends State<_Dots> with SingleTickerProviderStateMixin {
  late final AnimationController _ctl;

  @override
  void initState() {
    super.initState();
    _ctl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctl,
      builder: (_, __) {
        final v = (sin(_ctl.value * 2 * pi) + 1) / 2;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final size = 6.0 +
                (i == 0
                    ? v
                    : i == 1
                        ? (1 - v)
                        : v) *
                    3;
            return Container(
              width: size,
              height: size,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: const BoxDecoration(
                color: _kMuted,
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
*/

// /// Simple one-screen web app
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Voice Assistant Demo',
//       theme: ThemeData(
//         fontFamily: 'Poppins',
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5C2D91)),
//         useMaterial3: true,
//       ),
//       home: const VoiceAssistantScreen(),
//     );
//   }
// }

// /// Model for hard-coded Q&A
// class QaItem {
//   final String question;
//   final String answer;

//   const QaItem({
//     required this.question,
//     required this.answer,
//   });
// }

// const List<QaItem> kSampleQa = [
//   QaItem(
//     question: 'What services do you provide?',
//     answer:
//         'I can help you with cleaning, plumbing, electrical work, and moving services.',
//   ),
//   QaItem(
//     question: 'How can I book a service?',
//     answer:
//         'You can book a service by selecting the category, choosing a time slot, and confirming your booking.',
//   ),
//   QaItem(
//     question: 'Can I reschedule my booking?',
//     answer:
//         'Yes, you can reschedule your booking up to two hours before the service time.',
//   ),
//   QaItem(
//     question: 'Do you offer same-day service?',
//     answer:
//         'Yes, we offer same-day service in most areas, depending on tasker availability.',
//   ),
//   QaItem(
//     question: 'How can I contact support?',
//     answer:
//         'You can contact support through in-app chat or by sending us an email anytime.',
//   ),
// ];

// class VoiceAssistantScreen extends StatefulWidget {
//   const VoiceAssistantScreen({super.key});

//   @override
//   State<VoiceAssistantScreen> createState() => _VoiceAssistantScreenState();
// }

// class _VoiceAssistantScreenState extends State<VoiceAssistantScreen> {
//   final FlutterTts _tts = FlutterTts();
//   int? _speakingIndex;
//   bool _isSpeaking = false;

//   @override
//   void initState() {
//     super.initState();
//     _initTts();
//   }

//   Future<void> _initTts() async {
//     await _tts.setLanguage('en-US');
//     await _tts.setSpeechRate(0.5); // slower for clarity
//     await _tts.setPitch(1.0);

//     _tts.setStartHandler(() {
//       setState(() {
//         _isSpeaking = true;
//       });
//     });

//     _tts.setCompletionHandler(() {
//       setState(() {
//         _isSpeaking = false;
//         _speakingIndex = null;
//       });
//     });

//     _tts.setErrorHandler((msg) {
//       setState(() {
//         _isSpeaking = false;
//         _speakingIndex = null;
//       });
//     });
//   }

//   Future<void> _speakItem(int index) async {
//     final qa = kSampleQa[index];

//     // If it is already speaking, stop first
//     if (_isSpeaking && _speakingIndex == index) {
//       await _tts.stop();
//       setState(() {
//         _speakingIndex = null;
//         _isSpeaking = false;
//       });
//       return;
//     }

//     // Stop any current speech and start new one
//     await _tts.stop();
//     setState(() {
//       _speakingIndex = index;
//       _isSpeaking = true;
//     });

//     final text = 'Question: ${qa.question}. Answer: ${qa.answer}';
//     await _tts.speak(text);
//   }

//   @override
//   void dispose() {
//     _tts.stop();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F3FF),
//       appBar: AppBar(
//         title: const Text(
//           'Voice Assistant',
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: Center(
//         child: ConstrainedBox(
//           constraints: const BoxConstraints(maxWidth: 600),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 const Text(
//                   'Tap the speaker icon to hear the assistant read the question and answer.',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Color(0xFF55556A),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Expanded(
//                   child: ListView.separated(
//                     itemCount: kSampleQa.length,
//                     separatorBuilder: (_, __) => const SizedBox(height: 12),
//                     itemBuilder: (context, index) {
//                       final qa = kSampleQa[index];
//                       final isActive = index == _speakingIndex && _isSpeaking;

//                       return AnimatedContainer(
//                         duration: const Duration(milliseconds: 200),
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: isActive
//                               ? const Color(0xFF5C2D91).withOpacity(0.08)
//                               : Colors.white,
//                           borderRadius: BorderRadius.circular(18),
//                           boxShadow: [
//                             BoxShadow(
//                               blurRadius: 12,
//                               offset: const Offset(0, 4),
//                               color: Colors.black.withOpacity(0.06),
//                             ),
//                           ],
//                           border: Border.all(
//                             color: isActive
//                                 ? const Color(0xFF5C2D91)
//                                 : Colors.transparent,
//                           ),
//                         ),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: const Color(0xFF5C2D91).withOpacity(0.1),
//                               ),
//                               child: const Icon(
//                                 Icons.smart_toy_rounded,
//                                 size: 22,
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     qa.question,
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 6),
//                                   Text(
//                                     qa.answer,
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       color: Color(0xFF55556A),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             IconButton(
//                               onPressed: () => _speakItem(index),
//                               icon: Icon(
//                                 isActive
//                                     ? Icons.stop_rounded
//                                     : Icons.volume_up_rounded,
//                               ),
//                               tooltip:
//                                   isActive ? 'Stop speaking' : 'Play answer',
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
