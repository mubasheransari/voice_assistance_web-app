import 'package:flutter/material.dart';
import 'package:voice_assistant_project/Theme/theme.dart';

class PointsScreen extends StatefulWidget {
  const PointsScreen({super.key});

  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  late int myPoints;
  late int housePoints;
  late int friendsPoints;

  String _targetGroup = 'Same House';
  final _amountCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        (ModalRoute.of(context)?.settings.arguments as Map<String, int>?) ?? {};
    myPoints = args['myPoints'] ?? 0;
    housePoints = args['housePoints'] ?? 0;
    friendsPoints = args['friendsPoints'] ?? 0;
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  void _transfer() {
    final amount = int.tryParse(_amountCtrl.text) ?? 0;
    if (amount <= 0) {
      _showSnack('Enter a valid amount');
      return;
    }
    if (amount > myPoints) {
      _showSnack('Not enough points');
      return;
    }

    setState(() {
      myPoints -= amount;
      if (_targetGroup == 'Same House') {
        housePoints += amount;
      } else {
        friendsPoints += amount;
      }
    });

    _showSnack('Points transfer successfully!');
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  void _saveAndReturn() {
    Navigator.pop<Map<String, int>>(context, {
      'myPoints': myPoints,
      'housePoints': housePoints,
      'friendsPoints': friendsPoints,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Loyalty Points'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded),
            onPressed: _saveAndReturn,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _walletColumn('My Points', myPoints),
                    _walletColumn('Same House', housePoints),
                    _walletColumn('Friends', friendsPoints),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Transfer Points',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ToggleButtons(
                      isSelected: [
                        _targetGroup == 'Same House',
                        _targetGroup == 'Friends'
                      ],
                      onPressed: (index) {
                        setState(() {
                          _targetGroup =
                              index == 0 ? 'Same House' : 'Friends';
                        });
                      },
                      borderRadius: BorderRadius.circular(14),
                      selectedColor: Colors.white,
                      fillColor: AppTheme.primary,
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text('Same House'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text('Friends'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nameCtrl,
                      decoration: InputDecoration(
                        labelText: _targetGroup == 'Same House'
                            ? 'House Member Name'
                            : 'Friend Name',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _amountCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Points Amount',
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _transfer,
                        icon: const Icon(Icons.send_rounded),
                        label: const Text('Transfer'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _walletColumn(String label, int value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
