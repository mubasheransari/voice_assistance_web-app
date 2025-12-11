import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:voice_assistant_project/Bloc/global_bloc.dart';
import 'package:voice_assistant_project/Bloc/global_event.dart';
import 'package:voice_assistant_project/Screens/home_screen.dart';
import 'package:voice_assistant_project/Screens/login_screen.dart';
import 'package:voice_assistant_project/Screens/sales_survery_screen.dart';
import 'package:voice_assistant_project/services/prayer_times_service.dart';




final ValueNotifier<int> rewardPoints = ValueNotifier<int>(120);

// features implemented so far is scanning a QR and adding points to total reward points.
// sending points to other users of the app (family & friends) through unique key that every user have.
// namaz timings according to cities changes dynamically.
// islamic calender.
// need locations that our tea is selling throughout the counttry with name and exact location (lat,lng)
// where how can we these points to use these reward points.
// in app ecommerce store & tie up with marts is the solution of reedming points from the app. 



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HijriCalendar.setLocal("en");
  await GetStorage.init();

  runApp(const RewardApp());
}

class RewardApp extends StatelessWidget {
  const RewardApp({super.key});

  @override
  Widget build(BuildContext context) {
    var storage = GetStorage();
    var user = storage.read("user");
    var supervisor = storage.read("supervisor");
    return MultiBlocProvider(
      providers: [
        BlocProvider<GlobalBloc>(
          create: (_) => GlobalBloc(PrayerTimesService())
            ..add(const LoadPrayerTimes()), // initial load
        ),
      ],
      child: MaterialApp(
        title: 'Reward Scanner',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'ClashGrotesk',
          colorScheme:
              ColorScheme.fromSeed(seedColor: const Color(0xFF7F53FD)),
          useMaterial3: true,
        ),
        home:user != null ? HomeScreen(): supervisor != null ?SurveyScreenView():  AuthScreen() //HomeScreen(),
      ),
    );
  }
}

// class RewardApp extends StatelessWidget {
//   const RewardApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Reward Scanner',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         fontFamily: 'Poppins',
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7F53FD)),
//         useMaterial3: true,
//       ),
//       home: const HomeScreen(),
//     );
//   }
// }


// void main() {
//   runApp(const VoiceRewardsApp());
// }

// class VoiceRewardsApp extends StatelessWidget {
//   const VoiceRewardsApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Rewards Scanner',
//       debugShowCheckedModeBanner: false,
//       theme: AppTheme.lightTheme,
//       initialRoute: LoginScreen.routeName,
//       routes: {
//         LoginScreen.routeName: (_) => const LoginScreen(),
//         SignupScreen.routeName: (_) => const SignupScreen(),
//         HomeScreen.routeName: (_) => const HomeScreen(),
//         PointsScreen.routeName: (_) => const PointsScreen(),
//         SurveyScreen.routeName: (_) => const SurveyScreen(),
//         PrayerTimesScreen.routeName: (_) => const PrayerTimesScreen(),
//       },
//     );
//   }
// }


// void main() {
//   runApp(const LoyaltyApp//MyApp
//   ());
// }





// class LoyaltyApp extends StatelessWidget {
//   const LoyaltyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: ' Loyalty',
//       theme: AppTheme.lightTheme,
//       debugShowCheckedModeBanner: false,

//       // 🔴 Start from login
//       initialRoute: '/login',

//       routes: {
//         '/login': (_) => const LoginScreen(),
//         '/signup': (_) => const SignupScreen(),

//         '/': (_) => const HomeScreen(),
//         '/survey': (_) => const SurveyScreen(),
//         '/points': (_) => const PointsScreen(),
//         '/prayers': (_) => const PrayerTimesScreen(),
//       },
//     );
//   }
// }



// const List<String> kSurveyQuestions = [
//   'What is your phone number?',
//   'What is your name?',
//   'Which city do you live in?',
//   'How old are you?',
//   'What is your profession?',
//   'Please share your review about Mezan Chai.',
// ];

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
// //want a create a loyality app in which this including this form of survery this is only one functionality and want to add functionality to add loyality points in the same house or in friends. want namaz time , end time and start time with the city change in pakistan then this time chages. i want all this in  and white beauitful designed modern look app and functionality. and want every screen code seprately. 

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Mezan Chai Assistant',

//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         fontFamily: 'Poppins',
//         brightness: Brightness.dark,
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color(0xFFEC4899),
//           brightness: Brightness.dark,
//         ),
//         useMaterial3: true,
//       ),
//       home: const VoiceAssistantChatScreen(),
//     );
//   }
// }

// enum ChatRole { user, bot }

// class ChatMessage {
//   final String id;
//   final ChatRole role;
//   final String text;
//   final DateTime ts;

//   ChatMessage({
//     requi this.id,
//     requi this.role,
//     requi this.text,
//     requi this.ts,
//   });
// }

// const _kText = Color(0xFFE5E7EB);
// const _kMuted = Color(0xFF9CA3AF);
// const _kAccent = Color(0xFFEC4899); // pink
// const _kAccent2 = Color(0xFF8B5CF6); // purple

// class Glass extends StatelessWidget {
//   const Glass({super.key, requi this.child, this.radius = 24, this.padding});

//   final Widget child;
//   final double radius;
//   final EdgeInsetsGeometry? padding;

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(radius),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(radius),
//             color: Colors.white.withOpacity(0.08),
//             border: Border.all(
//               color: Colors.white.withOpacity(0.25),
//               width: 1.0,
//             ),
//           ),
//           padding: padding ?? const EdgeInsets.all(16),
//           child: child,
//         ),
//       ),
//     );
//   }
// }

// class PermissionScreen extends StatelessWidget {
//   const PermissionScreen({super.key});

//   Future<void> _openSettings() async {
//     await openAppSettings();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF020617),
//       appBar: AppBar(
//         title: const Text('Microphone Permission'),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Center(
//         child: Glass(
//           radius: 20,
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Icon(Icons.mic_off_rounded, size: 48, color: _kAccent),
//               const SizedBox(height: 16),
//               const Text(
//                 'Microphone access is requi',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontFamily: 'ClashGrotesk',
//                   color: _kText,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 'Please allow microphone permission in app settings so we can listen to your answers.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontFamily: 'ClashGrotesk',
//                   color: _kMuted,
//                   fontSize: 13,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton.icon(
//                 onPressed: _openSettings,
//                 icon: const Icon(Icons.settings_rounded),
//                 label: const Text('Open App Settings'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: _kAccent,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 18,
//                     vertical: 10,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(999),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class VoiceAssistantChatScreen extends StatefulWidget {
//   const VoiceAssistantChatScreen({super.key});

//   @override
//   State<VoiceAssistantChatScreen> createState() =>
//       _VoiceAssistantChatScreenState();
// }

// class _VoiceAssistantChatScreenState extends State<VoiceAssistantChatScreen> {
//   final FlutterTts _tts = FlutterTts();
//   final stt.SpeechToText _speech = stt.SpeechToText();

//   final ScrollController _scroll = ScrollController();

//   final List<ChatMessage> _messages = [];

//   bool _speechAvailable = false;
//   bool _surveyRunning = false;
//   bool _listening = false;
//   String _liveTranscript = '';

//   String? _speakingId;

//   int _currentQuestionIndex = 0;
//   final Map<int, String> _answers = {};

//   @override
//   void initState() {
//     super.initState();
//     _initTts();
//     _initSpeech();
//     _seedWelcome();
//   }

//   void _seedWelcome() {
//     _messages.add(
//       ChatMessage(
//         id: 'welcome',
//         role: ChatRole.bot,
//         text:
//             'Welcome to Mezan Chai voice survey.\nTap "Start Survey" and I will ask you a few questions one by one. Answer with your voice.',
//         ts: DateTime.now(),
//       ),
//     );
//   }

//   void _initTts() {
//     _tts.setLanguage('en-US');
//     _tts.setSpeechRate(0.5);
//     _tts.setPitch(1.0);

//     _tts.setStartHandler(() {
//       setState(() {});
//     });

//     _tts.setCompletionHandler(() {
//       setState(() {
//         _speakingId = null;
//       });
//     });

//     _tts.setErrorHandler((msg) {
//       setState(() {
//         _speakingId = null;
//       });
//     });
//   }

//   Future<void> _initSpeech() async {
//     try {
//       final available = await _speech.initialize(
//         onStatus: (status) {
//           debugPrint('Speech status: $status');
//         },
//         onError: (error) {
//           debugPrint('Speech error: $error');
//         },
//       );
//       setState(() {
//         _speechAvailable = available;
//       });
//     } catch (e) {
//       debugPrint('Speech init error: $e');
//       setState(() {
//         _speechAvailable = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _scroll.dispose();
//     _tts.stop();
//     _speech.stop();
//     super.dispose();
//   }

//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!_scroll.hasClients) return;
//       _scroll.animateTo(
//         _scroll.position.maxScrollExtent + 120,
//         duration: const Duration(milliseconds: 250),
//         curve: Curves.easeOut,
//       );
//     });
//   }

//   /* ---------- PERMISSIONS ---------- */

//   Future<bool> _ensureMicPermission() async {
//     final status = await Permission.microphone.status;
//     if (status.isGranted) return true;

//     final result = await Permission.microphone.request();
//     if (result.isGranted) return true;

//     if (result.isPermanentlyDenied) {
//       if (mounted) {
//         Navigator.of(
//           context,
//         ).push(MaterialPageRoute(builder: (_) => const PermissionScreen()));
//       }
//     } else {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Microphone permission is requi for voice input.'),
//           ),
//         );
//       }
//     }
//     return false;
//   }

//   Future<void> _startSurvey() async {
//     if (!_speechAvailable) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Speech recognition is not available on this device.'),
//         ),
//       );
//       return;
//     }

//     final ok = await _ensureMicPermission();
//     if (!ok) return;

//     setState(() {
//       _surveyRunning = true;
//       _currentQuestionIndex = 0;
//       _answers.clear();
//       _messages.clear();
//     });

//     // intro message
//     final intro = ChatMessage(
//       id: 'intro_${DateTime.now().millisecondsSinceEpoch}',
//       role: ChatRole.bot,
//       text:
//           'Great! I will ask you some questions about you and your Mezan Chai experience. Please answer with your voice after each question.',
//       ts: DateTime.now(),
//     );
//     setState(() {
//       _messages.add(intro);
//     });
//     _scrollToBottom();

//     await _tts.speak(
//       'Great! I will ask you some questions about you and your Mezan Chai experience. Please answer with your voice after each question.',
//     );
//     await Future.delayed(const Duration(milliseconds: 700));

//     await _askCurrentQuestion();
//   }

//   Future<void> _askCurrentQuestion() async {
//     if (_currentQuestionIndex < 0 ||
//         _currentQuestionIndex >= kSurveyQuestions.length) {
//       return;
//     }

//     final q = kSurveyQuestions[_currentQuestionIndex];

//     final botQuestion = ChatMessage(
//       id:
//           'q_$_currentQuestionIndex'
//           '_${DateTime.now().millisecondsSinceEpoch}',
//       role: ChatRole.bot,
//       text: q,
//       ts: DateTime.now(),
//     );

//     setState(() {
//       _messages.add(botQuestion);
//       _speakingId = botQuestion.id;
//     });
//     _scrollToBottom();

//     await _tts.stop();
//     await _tts.speak(q);

//     // When TTS finishes, start listening
//     await _startListeningForAnswer();
//   }

//   Future<void> _startListeningForAnswer() async {
//     if (!_speechAvailable) return;

//     final ok = await _ensureMicPermission();
//     if (!ok) return;

//     _liveTranscript = '';
//     setState(() {
//       _listening = true;
//     });

//     await _speech.listen(
//       onResult: (result) {
//         if (!mounted) return;
//         setState(() {
//           _liveTranscript = result.recognizedWords;
//         });

//         if (result.finalResult) {
//           _handleFinalTranscript(result.recognizedWords.trim());
//         }
//       },
//       // ⬇️ longer listening
//       listenFor: const Duration(seconds: 40),
//       // ⬇️ wait in silence before stopping
//       pauseFor: const Duration(seconds: 6),
//       partialResults: true,
//       localeId: 'en_US',
//       cancelOnError: true,
//       listenMode: stt.ListenMode.dictation,
//     );
//   }

//   Future<void> _handleFinalTranscript(String text) async {
//     await _speech.stop();
//     if (!mounted) return;

//     setState(() {
//       _listening = false;
//     });

//     // --- NOISE FILTER: require at least 2 words ---
//     final cleaned = text.trim();
//     final wordCount = cleaned.isEmpty
//         ? 0
//         : cleaned.split(RegExp(r'\s+')).length;

//     if (wordCount < 2) {
//       // Treat as unclear / noisy answer
//       final warn = ChatMessage(
//         id: 'noise_${DateTime.now().millisecondsSinceEpoch}',
//         role: ChatRole.bot,
//         text:
//             'I could not hear you clearly. Please answer again in a quiet place and speak a full sentence.',
//         ts: DateTime.now(),
//       );
//       setState(() {
//         _messages.add(warn);
//       });
//       _scrollToBottom();
//       await Future.delayed(const Duration(milliseconds: 700));
//       await _askCurrentQuestion(); // re-ask same question
//       return;
//     }

//     // --- Accept answer ---
//     _answers[_currentQuestionIndex] = cleaned;

//     final userMessage = ChatMessage(
//       id: 'a_${_currentQuestionIndex}_${DateTime.now().millisecondsSinceEpoch}',
//       role: ChatRole.user,
//       text: cleaned,
//       ts: DateTime.now(),
//     );

//     setState(() {
//       _messages.add(userMessage);
//       _liveTranscript = '';
//     });
//     _scrollToBottom();

//     // Next question
//     _currentQuestionIndex++;
//     if (_currentQuestionIndex < kSurveyQuestions.length) {
//       await Future.delayed(const Duration(milliseconds: 700));
//       await _askCurrentQuestion();
//     } else {
//       // Survey finished
//       setState(() {
//         _surveyRunning = false;
//       });

//       final doneMsg = ChatMessage(
//         id: 'done_${DateTime.now().millisecondsSinceEpoch}',
//         role: ChatRole.bot,
//         text:
//             'Thank you for your time and feedback on Mezan Chai. Your responses are recorded.',
//         ts: DateTime.now(),
//       );
//       setState(() {
//         _messages.add(doneMsg);
//       });
//       _scrollToBottom();

//       await _tts.speak(
//         'Thank you for your time and feedback. Your responses are recorded.',
//       );
//     }
//   }

//   /* ---------- UI ---------- */

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF020617), Color(0xFF111827), Color(0xFF1F2937)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Stack(
//           children: [
//             Positioned(
//               top: -80,
//               left: -40,
//               child: _Blob(
//                 color: const Color(0xFFEC4899).withOpacity(0.35),
//                 size: 220,
//               ),
//             ),
//             Positioned(
//               bottom: -60,
//               right: -30,
//               child: _Blob(
//                 color: const Color(0xFF8B5CF6).withOpacity(0.4),
//                 size: 260,
//               ),
//             ),
//             SafeArea(
//               child: Center(
//                 child: ConstrainedBox(
//                   constraints: const BoxConstraints(maxWidth: 900),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       children: [
//                         // HEADER
//                         Glass(
//                           radius: 20,
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 18,
//                             vertical: 14,
//                           ),
//                           child: Row(
//                             children: [
//                               // Container(
//                               //   width: 38,
//                               //   height: 38,
//                               //   decoration: BoxDecoration(
//                               //     shape: BoxShape.circle,
//                               //     gradient: const LinearGradient(
//                               //       colors: [_kAccent, _kAccent2],
//                               //     ),
//                               //     boxShadow: [
//                               //       BoxShadow(
//                               //         color: _kAccent.withOpacity(0.5),
//                               //         blurRadius: 18,
//                               //         offset: const Offset(0, 6),
//                               //       )
//                               //     ],
//                               //   ),
//                               //   child: const Icon(
//                               //     Icons.local_cafe_rounded,
//                               //     size: 20,
//                               //     color: Colors.white,
//                               //   ),
//                               // ),
//                               const SizedBox(width: 10),
//                               const Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Mezan Chai Voice Survey',
//                                     style: TextStyle(
//                                       fontFamily: 'ClashGrotesk',
//                                       fontSize: 17,
//                                       fontWeight: FontWeight.w700,
//                                       color: _kText,
//                                     ),
//                                   ),
//                                   SizedBox(height: 2),
//                                   Text(
//                                     'Answer each question with your voice.',
//                                     style: TextStyle(
//                                       fontFamily: 'ClashGrotesk',
//                                       fontSize: 12,
//                                       color: _kMuted,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const Spacer(),
//                               IconButton(
//                                 tooltip: 'Clear chat',
//                                 onPressed: () {
//                                   setState(() {
//                                     _messages.clear();
//                                     _surveyRunning = false;
//                                     _currentQuestionIndex = 0;
//                                     _answers.clear();
//                                     _liveTranscript = '';
//                                     _seedWelcome();
//                                   });
//                                 },
//                                 icon: const Icon(
//                                   Icons.delete_outline,
//                                   color: _kMuted,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 14),

//                         // MAIN CARD
//                         Expanded(
//                           child: Glass(
//                             radius: 26,
//                             padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
//                             child: Column(
//                               children: [
//                                 // Chat list
//                                 Expanded(
//                                   child: ListView.builder(
//                                     controller: _scroll,
//                                     padding: const EdgeInsets.only(bottom: 8),
//                                     itemCount:
//                                         _messages.length +
//                                         (_listening &&
//                                                 _liveTranscript.isNotEmpty
//                                             ? 1
//                                             : 0),
//                                     itemBuilder: (context, index) {
//                                       // last item: live transcript bubble
//                                       if (_listening &&
//                                           _liveTranscript.isNotEmpty &&
//                                           index == _messages.length) {
//                                         return Align(
//                                           alignment: Alignment.centerRight,
//                                           child: _LiveTranscriptBubble(
//                                             text: _liveTranscript,
//                                           ),
//                                         );
//                                       }

//                                       final m = _messages[index];
//                                       final isUser = m.role == ChatRole.user;
//                                       return Column(
//                                         crossAxisAlignment: isUser
//                                             ? CrossAxisAlignment.end
//                                             : CrossAxisAlignment.start,
//                                         children: [
//                                           Align(
//                                             alignment: isUser
//                                                 ? Alignment.centerRight
//                                                 : Alignment.centerLeft,
//                                             child: _ChatBubble(
//                                               message: m,
//                                               isSpeaking: _speakingId == m.id,
//                                               onCopy: () => Clipboard.setData(
//                                                 ClipboardData(text: m.text),
//                                               ),
//                                             ),
//                                           ),
//                                           const SizedBox(height: 10),
//                                         ],
//                                       );
//                                     },
//                                   ),
//                                 ),

//                                 const SizedBox(height: 8),

//                                 // Status + Start / Restart button
//                                 Row(
//                                   children: [
//                                     if (_listening)
//                                       Row(
//                                         children: [
//                                           const Icon(
//                                             Icons.mic_rounded,
//                                             size: 18,
//                                             color: _kAccent,
//                                           ),
//                                           const SizedBox(width: 6),
//                                           Text(
//                                             'Listening… speak now',
//                                             style: TextStyle(
//                                               fontFamily: 'ClashGrotesk',
//                                               color: Colors..shade300,
//                                               fontSize: 12,
//                                             ),
//                                           ),
//                                         ],
//                                       )
//                                     else if (_surveyRunning)
//                                       const Text(
//                                         'Asking questions…',
//                                         style: TextStyle(
//                                           fontFamily: 'ClashGrotesk',
//                                           color: _kMuted,
//                                           fontSize: 12,
//                                         ),
//                                       )
//                                     else
//                                       const Text(
//                                         'Tap Start Survey.',
//                                         style: TextStyle(
//                                           fontFamily: 'ClashGrotesk',
//                                           color: _kMuted,
//                                           fontSize: 12,
//                                         ),
//                                       ),
//                                     const Spacer(),
//                                     ElevatedButton.icon(
//                                       onPressed: _surveyRunning
//                                           ? null
//                                           : () => _startSurvey(),
//                                       icon: const Icon(
//                                         Icons.play_arrow_rounded,
//                                       ),
//                                       label: Text(
//                                         _currentQuestionIndex == 0
//                                             ? 'Start Survey'
//                                             : 'Restart Survey',
//                                         style: TextStyle(
//                                           fontFamily: 'ClashGrotesk',
//                                           fontWeight: FontWeight.w800,
//                                         ),
//                                       ),
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: _surveyRunning
//                                             ? Colors.grey
//                                             : _kAccent,
//                                         foregroundColor: Colors.white,
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 18,
//                                           vertical: 10,
//                                         ),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             999,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /* ---------- CHAT BUBBLES ---------- */

// class _ChatBubble extends StatelessWidget {
//   const _ChatBubble({
//     requi this.message,
//     requi this.isSpeaking,
//     this.onCopy,
//   });

//   final ChatMessage message;
//   final bool isSpeaking;
//   final VoidCallback? onCopy;

//   bool get isUser => message.role == ChatRole.user;

//   @override
//   Widget build(BuildContext context) {
//     if (isUser) {
//       // User bubble
//       return Container(
//         constraints: const BoxConstraints(maxWidth: 600),
//         padding: const EdgeInsets.fromLTRB(14, 10, 12, 8),
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [_kAccent, _kAccent2],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(4),
//             bottomLeft: Radius.circular(20),
//             bottomRight: Radius.circular(20),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: _kAccent.withOpacity(0.6),
//               blurRadius: 18,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         child: SelectableText(
//           message.text,
//           style: const TextStyle(
//             fontFamily: 'ClashGrotesk',
//             color: Colors.white,
//             fontSize: 14.5,
//             height: 1.35,
//           ),
//         ),
//       );
//     }

//     // Bot bubble
//     return Glass(
//       radius: 18,
//       padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SelectableText(
//             message.text,
//             style: const TextStyle(
//               fontFamily: 'ClashGrotesk',
//               color: _kText,
//               fontSize: 14.5,
//               height: 1.35,
//             ),
//           ),
//           const SizedBox(height: 6),
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               if (onCopy != null)
//                 _MiniIconButton(
//                   icon: Icons.copy_rounded,
//                   label: 'Copy',
//                   onTap: onCopy!,
//                 ),
//               const SizedBox(width: 4),
//               Icon(
//                 isSpeaking
//                     ? Icons.volume_up_rounded
//                     : Icons.volume_mute_rounded,
//                 size: 14,
//                 color: _kMuted,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _MiniIconButton extends StatelessWidget {
//   const _MiniIconButton({
//     requi this.icon,
//     requi this.label,
//     requi this.onTap,
//   });

//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(999),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, size: 16, color: _kMuted),
//             const SizedBox(width: 4),
//             Text(
//               label,
//               style: const TextStyle(
//                 fontFamily: 'ClashGrotesk',
//                 fontSize: 11,
//                 color: _kMuted,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _LiveTranscriptBubble extends StatelessWidget {
//   const _LiveTranscriptBubble({requi this.text});

//   final String text;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       constraints: const BoxConstraints(maxWidth: 600),
//       padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(18),
//         color: Colors.white.withOpacity(0.08),
//         border: Border.all(color: Colors.white.withOpacity(0.25)),
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(
//           fontFamily: 'ClashGrotesk',
//           color: _kText,
//           fontSize: 13,
//         ),
//       ),
//     );
//   }
// }

// class _Blob extends StatelessWidget {
//   const _Blob({requi this.color, requi this.size});

//   final Color color;
//   final double size;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: color,
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(0.7),
//             blurRadius: 60,
//             spreadRadius: 10,
//           ),
//         ],
//       ),
//     );
//   }
// }
