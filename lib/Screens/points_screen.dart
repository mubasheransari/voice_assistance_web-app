import 'package:flutter/material.dart';
import 'package:voice_assistant_project/Theme/theme.dart';
import '../main.dart';
import 'package:mobile_scanner/mobile_scanner.dart';


class PointsScreenArguments {
  final bool openTransferTab;
  const PointsScreenArguments({this.openTransferTab = false});
}

class PointsScreen extends StatefulWidget {
  static const String routeName = '/points';

  final bool openTransferTab;

  const PointsScreen({super.key, this.openTransferTab = false});

  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final MobileScannerController _scannerController = MobileScannerController();

  bool _processingScan = false;
  String? _lastScanMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.openTransferTab ? 1 : 0,
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_processingScan) return;

    final barcode = capture.barcodes.firstOrNull;
    final raw = barcode?.rawValue;

    if (raw == null || raw.isEmpty) return;

    setState(() => _processingScan = true);

    // 👉 Simple convention: QR contains just a number = points
    // e.g. "50" → 50 pts. If parsing fails, fallback to 10 pts.
    int pts = int.tryParse(raw) ?? 10;

    rewardPoints.value += pts;

    setState(() {
      _lastScanMessage = 'You earned $pts pts from this scan.';
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          content: Text('Scan successful! +$pts pts added.'),
          backgroundColor: AppTheme.green,
        ),
      );
    }

    // Small delay to avoid multiple triggers from same QR
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _processingScan = false);
    }
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
          'Rewards',
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
        child: Column(
          children: [
            const SizedBox(height: 8),
            // current points summary (same style as home)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildPointsHeader(),
            ),
            const SizedBox(height: 12),
            // Tabs: Scan & earn / Send points
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppTheme.primary.withOpacity(.08),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: AppTheme.primary,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: AppTheme.primary,
                labelStyle: const TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(text: 'Scan & earn'),
                  Tab(text: 'Send points'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildScanTab(),
                  _buildSendTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, AppTheme.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.12),
            blurRadius: 18,
            offset: const Offset(0, 10),
          )
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.stars_rounded, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: ValueListenableBuilder<int>(
              valueListenable: rewardPoints,
              builder: (context, value, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rewards balance',
                      style: TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 12.5,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$value pts',
                      style: const TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
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

  // ---------- TAB 1: SCAN & EARN ----------
  Widget _buildScanTab() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: Column(
        children: [
          Expanded(
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      MobileScanner(
                        controller: _scannerController,
                        onDetect: _onDetect,
                      ),
                      // simple overlay
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withOpacity(.9),
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                      if (_processingScan)
                        Container(
                          color: Colors.black.withOpacity(0.4),
                          child: const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Align the QR code within the frame to earn points.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 13,
              color: Color(0xFF75748A),
            ),
          ),
          if (_lastScanMessage != null) ...[
            const SizedBox(height: 10),
            Text(
              _lastScanMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.green,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ---------- TAB 2: SEND POINTS (simple UI, hook your API) ----------
  Widget _buildSendTab() {
    final _keyCtrl = TextEditingController();
    final _pointsCtrl = TextEditingController();

    void send() {
      final pts = int.tryParse(_pointsCtrl.text.trim());
      if (pts == null || pts <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enter a valid points amount')),
        );
        return;
      }
      if (_keyCtrl.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enter recipient key')),
        );
        return;
      }

      if (rewardPoints.value < pts) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Not enough points to send')),
        );
        return;
      }

      rewardPoints.value -= pts;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sent $pts pts to ${_keyCtrl.text.trim()}'),
        ),
      );
      _keyCtrl.clear();
      _pointsCtrl.clear();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Send points',
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
          const SizedBox(height: 16),
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
          const SizedBox(height: 20),
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
              onPressed: send,
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
    );
  }
}

// small input field used in send tab
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

extension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : this[0];
}


// class PointsScreenArguments {
//   final bool openTransferTab;
//   const PointsScreenArguments({this.openTransferTab = false});
// }

// class PointsScreen extends StatefulWidget {
//   static const String routeName = '/points';

//   const PointsScreen({super.key});

//   @override
//   State<PointsScreen> createState() => _PointsScreenState();
// }

// class _PointsScreenState extends State<PointsScreen>
//     with SingleTickerProviderStateMixin {
//   late final TabController _tabController;
//   late String _shareKey;

//   final _amountCtrl = TextEditingController();
//   final _recipientKeyCtrl = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     final args = ModalRoute.of(context)?.settings.arguments;
//     final openTransfer =
//         args is PointsScreenArguments && args.openTransferTab;

//     _tabController = TabController(
//       length: 2,
//       vsync: this,
//       initialIndex: openTransfer ? 1 : 0,
//     );
//     _generateNewShareKey();
//   }

//   void _generateNewShareKey() {
//     final random = Random.secure();
//     final code = 100000 + random.nextInt(900000);
//     _shareKey = 'R$code';
//     setState(() {});
//   }

//   Future<void> _simulateScan() async {
//     // In future you will integrate a real QR/camera scanner here.
//     // For now we just simulate adding random points.
//     final added = 5 + Random().nextInt(20);
//     rewardPoints.value += added;

//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Scan successful! +$added pts added.'),
//       ),
//     );
//   }

//   void _sendPoints() {
//     final raw = _amountCtrl.text.trim();
//     final recipientKey = _recipientKeyCtrl.text.trim();
//     if (raw.isEmpty || recipientKey.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Enter amount and recipient key.')),
//       );
//       return;
//     }

//     final amount = int.tryParse(raw);
//     if (amount == null || amount <= 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Enter a valid amount.')),
//       );
//       return;
//     }

//     if (amount > rewardPoints.value) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Not enough points.')),
//       );
//       return;
//     }

//     rewardPoints.value -= amount;

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//             'Sent $amount pts to key $recipientKey. (Demo only, no backend)'),
//       ),
//     );

//     _amountCtrl.clear();
//     _recipientKeyCtrl.clear();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _amountCtrl.dispose();
//     _recipientKeyCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Fix for using ModalRoute in initState: ensure it’s initialised here too.
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           titleSpacing: 16,
//           leadingWidth: 48,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back_rounded,
//                 color: AppTheme.primary),
//             onPressed: () => Navigator.pop(context),
//           ),
//           title: const Text(
//             'Rewards',
//             style: TextStyle(
//               fontFamily: AppTheme.fontFamily,
//               fontWeight: FontWeight.w600,
//               color: AppTheme.primary,
//             ),
//           ),
//           bottom: const TabBar(
//             indicatorColor: AppTheme.primary,
//             labelColor: AppTheme.primary,
//             unselectedLabelColor: Color(0xFF75748A),
//             labelStyle: TextStyle(
//               fontFamily: AppTheme.fontFamily,
//               fontWeight: FontWeight.w600,
//             ),
//             tabs: [
//               Tab(text: 'Scan & earn'),
//               Tab(text: 'Send points'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           controller: _tabController,
//           children: [
//             _buildScanTab(),
//             _buildSendTab(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildScanTab() {
//     return Padding(
//       padding: const EdgeInsets.all(18),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           ValueListenableBuilder<int>(
//             valueListenable: rewardPoints,
//             builder: (context, value, _) {
//               return Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(18),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(.04),
//                       blurRadius: 18,
//                       offset: const Offset(0, 10),
//                     )
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       height: 40,
//                       width: 40,
//                       decoration: BoxDecoration(
//                         color: AppTheme.primary.withOpacity(.12),
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                       child: const Icon(Icons.stars_rounded,
//                           color: AppTheme.primary),
//                     ),
//                     const SizedBox(width: 14),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Current balance',
//                           style: TextStyle(
//                             fontFamily: AppTheme.fontFamily,
//                             fontSize: 12.5,
//                             color: Color(0xFF75748A),
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           '$value pts',
//                           style: const TextStyle(
//                             fontFamily: AppTheme.fontFamily,
//                             fontSize: 20,
//                             color: Color(0xFF3E1E69),
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//           const SizedBox(height: 24),
//           Expanded(
//             child: Column(
//               children: [
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(18),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(22),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(.04),
//                         blurRadius: 20,
//                         offset: const Offset(0, 12),
//                       )
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       Container(
//                         height: 180,
//                         width: 180,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(24),
//                           border: Border.all(
//                             color: AppTheme.primary.withOpacity(.3),
//                             width: 1.6,
//                           ),
//                         ),
//                         child: const Center(
//                           child: Icon(
//                             Icons.qr_code_2_rounded,
//                             size: 120,
//                             color: AppTheme.primary,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 18),
//                       const Text(
//                         'Point scanner',
//                         style: TextStyle(
//                           fontFamily: AppTheme.fontFamily,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF3E1E69),
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       const Text(
//                         'Align the QR code inside the frame.\n'
//                         'Every successful scan adds points to your balance.',
//                         style: TextStyle(
//                           fontFamily: AppTheme.fontFamily,
//                           fontSize: 12.5,
//                           color: Color(0xFF75748A),
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 18),
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton.icon(
//                           onPressed: _simulateScan,
//                           icon: const Icon(Icons.qr_code_scanner_rounded),
//                           label: const Text('Start scan (demo)'),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSendTab() {
//     return Padding(
//       padding: const EdgeInsets.all(18),
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Your share key card
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(18),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(.04),
//                     blurRadius: 18,
//                     offset: const Offset(0, 10),
//                   )
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     height: 40,
//                     width: 40,
//                     decoration: BoxDecoration(
//                       color: AppTheme.green.withOpacity(.12),
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                     child: const Icon(Icons.key_rounded,
//                         color: AppTheme.green),
//                   ),
//                   const SizedBox(width: 14),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Your share key',
//                           style: TextStyle(
//                             fontFamily: AppTheme.fontFamily,
//                             fontSize: 12.5,
//                             color: Color(0xFF75748A),
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           _shareKey,
//                           style: const TextStyle(
//                             fontFamily: AppTheme.fontFamily,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w700,
//                             color: Color(0xFF3E1E69),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: _generateNewShareKey,
//                     icon: const Icon(Icons.refresh_rounded,
//                         color: AppTheme.green),
//                     tooltip: 'Refresh key',
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 'Send points',
//                 style: TextStyle(
//                   fontFamily: AppTheme.fontFamily,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.grey.shade900,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: _amountCtrl,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 labelText: 'Amount (pts)',
//                 prefixIcon: Icon(Icons.numbers_rounded),
//               ),
//             ),
//             const SizedBox(height: 14),
//             TextField(
//               controller: _recipientKeyCtrl,
//               decoration: const InputDecoration(
//                 labelText: 'Recipient share key',
//                 prefixIcon: Icon(Icons.person_search_rounded),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ValueListenableBuilder<int>(
//               valueListenable: rewardPoints,
//               builder: (context, value, _) {
//                 return Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     'Available: $value pts',
//                     style: const TextStyle(
//                       fontFamily: AppTheme.fontFamily,
//                       fontSize: 12.5,
//                       color: Color(0xFF75748A),
//                     ),
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 18),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: _sendPoints,
//                 icon: const Icon(Icons.send_rounded),
//                 label: const Text('Send points'),
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'The share key changes frequently to keep transfers secure.\n'
//               'This demo only updates local state – integrate your API later.',
//               style: TextStyle(
//                 fontFamily: AppTheme.fontFamily,
//                 fontSize: 11.5,
//                 color: Color(0xFF75748A),
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// // class PointsScreen extends StatefulWidget {
// //   const PointsScreen({super.key});

// //   @override
// //   State<PointsScreen> createState() => _PointsScreenState();
// // }

// // class _PointsScreenState extends State<PointsScreen> {
// //   late int myPoints;
// //   late int housePoints;
// //   late int friendsPoints;

// //   String _targetGroup = 'Same House';
// //   final _amountCtrl = TextEditingController();
// //   final _nameCtrl = TextEditingController();

// //   @override
// //   void didChangeDependencies() {
// //     super.didChangeDependencies();
// //     final args =
// //         (ModalRoute.of(context)?.settings.arguments as Map<String, int>?) ?? {};
// //     myPoints = args['myPoints'] ?? 0;
// //     housePoints = args['housePoints'] ?? 0;
// //     friendsPoints = args['friendsPoints'] ?? 0;
// //   }

// //   @override
// //   void dispose() {
// //     _amountCtrl.dispose();
// //     _nameCtrl.dispose();
// //     super.dispose();
// //   }

// //   void _transfer() {
// //     final amount = int.tryParse(_amountCtrl.text) ?? 0;
// //     if (amount <= 0) {
// //       _showSnack('Enter a valid amount');
// //       return;
// //     }
// //     if (amount > myPoints) {
// //       _showSnack('Not enough points');
// //       return;
// //     }

// //     setState(() {
// //       myPoints -= amount;
// //       if (_targetGroup == 'Same House') {
// //         housePoints += amount;
// //       } else {
// //         friendsPoints += amount;
// //       }
// //     });

// //     _showSnack('Points transfer successfully!');
// //   }

// //   void _showSnack(String msg) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text(msg),
// //         backgroundColor: AppTheme.primary,
// //       ),
// //     );
// //   }

// //   void _saveAndReturn() {
// //     Navigator.pop<Map<String, int>>(context, {
// //       'myPoints': myPoints,
// //       'housePoints': housePoints,
// //       'friendsPoints': friendsPoints,
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Share Loyalty Points'),
// //         actions: [
// //           IconButton(
// //             icon: const Icon(Icons.check_rounded),
// //             onPressed: _saveAndReturn,
// //           )
// //         ],
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           children: [
// //             Card(
// //               child: Padding(
// //                 padding: const EdgeInsets.all(16),
// //                 child: Row(
// //                   children: [
// //                     _walletColumn('My Points', myPoints),
// //                     _walletColumn('Same House', housePoints),
// //                     _walletColumn('Friends', friendsPoints),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 16),
// //             Card(
// //               child: Padding(
// //                 padding: const EdgeInsets.all(16),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     const Text(
// //                       'Transfer Points',
// //                       style: TextStyle(
// //                         fontWeight: FontWeight.w700,
// //                         color: AppTheme.primary,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 12),
// //                     ToggleButtons(
// //                       isSelected: [
// //                         _targetGroup == 'Same House',
// //                         _targetGroup == 'Friends'
// //                       ],
// //                       onPressed: (index) {
// //                         setState(() {
// //                           _targetGroup =
// //                               index == 0 ? 'Same House' : 'Friends';
// //                         });
// //                       },
// //                       borderRadius: BorderRadius.circular(14),
// //                       selectedColor: Colors.white,
// //                       fillColor: AppTheme.primary,
// //                       children: const [
// //                         Padding(
// //                           padding: EdgeInsets.symmetric(
// //                               horizontal: 16, vertical: 8),
// //                           child: Text('Same House'),
// //                         ),
// //                         Padding(
// //                           padding: EdgeInsets.symmetric(
// //                               horizontal: 16, vertical: 8),
// //                           child: Text('Friends'),
// //                         ),
// //                       ],
// //                     ),
// //                     const SizedBox(height: 16),
// //                     TextField(
// //                       controller: _nameCtrl,
// //                       decoration: InputDecoration(
// //                         labelText: _targetGroup == 'Same House'
// //                             ? 'House Member Name'
// //                             : 'Friend Name',
// //                       ),
// //                     ),
// //                     const SizedBox(height: 12),
// //                     TextField(
// //                       controller: _amountCtrl,
// //                       keyboardType: TextInputType.number,
// //                       decoration: const InputDecoration(
// //                         labelText: 'Points Amount',
// //                       ),
// //                     ),
// //                     const SizedBox(height: 16),
// //                     SizedBox(
// //                       width: double.infinity,
// //                       child: ElevatedButton.icon(
// //                         onPressed: _transfer,
// //                         icon: const Icon(Icons.send_rounded),
// //                         label: const Text('Transfer'),
// //                       ),
// //                     )
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _walletColumn(String label, int value) {
// //     return Expanded(
// //       child: Column(
// //         children: [
// //           Text(
// //             value.toString(),
// //             style: const TextStyle(
// //               fontSize: 18,
// //               fontWeight: FontWeight.w700,
// //               color: AppTheme.primary,
// //             ),
// //           ),
// //           const SizedBox(height: 4),
// //           Text(
// //             label,
// //             style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
