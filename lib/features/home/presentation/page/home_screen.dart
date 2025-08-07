import 'package:flutter/material.dart';
import 'package:my_enrich/core/constants/fancy_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  void _togglePanel() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        children: [
          GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.primaryDelta != null && details.primaryDelta! > 8) _togglePanel();
              if (details.primaryDelta != null && details.primaryDelta! < -8) _togglePanel();
            },
            child: AnimatedSize(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(w * 0.06, h * 0.06, w * 0.06, h * 0.03),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hello, Abhiuday!',
                          style: TextStyle(
                            fontSize: w * 0.065,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              radius: w * 0.065,
                              backgroundColor: theme.colorScheme.surface,
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Image.asset('assets/icon/icon.png'),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    if (_isExpanded) ...[
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: theme.colorScheme.surface,
                            child: Icon(Icons.person, size: 32, color: theme.colorScheme.onSurface),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Abhiuday Ojha', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.onPrimary)),
                              const SizedBox(height: 4),
                              Text('abhiuday@example.com', style: TextStyle(fontSize: 14, color: theme.colorScheme.onPrimary.withOpacity(0.85))),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.card_giftcard, color: theme.colorScheme.onPrimary),
                          const SizedBox(width: 6),
                          Text('5 Coupons', style: TextStyle(color: theme.colorScheme.onPrimary)),
                        ],
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(w * 0.06),
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: w * 0.05,
                  mainAxisSpacing: h * 0.03,
                ),
                children: const [
                  FancyButton(label: 'Scan Ticket', icon: Icons.qr_code_scanner),
                  FancyButton(label: 'All Events', icon: Icons.calendar_today),
                  FancyButton(label: 'My Tickets', icon: Icons.confirmation_number),
                  FancyButton(label: 'My Coupons', icon: Icons.card_giftcard),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 14,
              offset: const Offset(0, -2),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: theme.colorScheme.primary,
            unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.4),
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
              BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
            ],
            currentIndex: 0,
            onTap: (index) {},
          ),
        ),
      ),
    );
  }
}