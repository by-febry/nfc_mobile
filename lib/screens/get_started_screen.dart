import 'package:flutter/material.dart';

class GetStartedScreen extends StatefulWidget {
  final VoidCallback onContinue;
  const GetStartedScreen({super.key, required this.onContinue});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> with SingleTickerProviderStateMixin {
  double _logoOpacity = 0.0;
  double _arrowOffset = 0.0;
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _logoOpacity = 1.0;
      });
    });
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  void _onButtonPressed() async {
    setState(() => _arrowOffset = 16);
    await Future.delayed(const Duration(milliseconds: 180));
    setState(() => _arrowOffset = 0);
    await Future.delayed(const Duration(milliseconds: 80));
    widget.onContinue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7B61FF),
      body: AnimatedBuilder(
        animation: _bgController,
        builder: (context, child) {
          final angle = 0.0 + 0.15 * _bgController.value;
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF7B61FF), const Color(0xFF5A4FFF)],
                begin: Alignment.topLeft,
                end: Alignment(
                  0.8 * (1 - angle),
                  1.0 * angle,
                ),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 3),
                  // Glow + animated logo
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Glow
                        Container(
                          width: 320,
                          height: 320,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withOpacity(0.18),
                                Colors.transparent,
                              ],
                              radius: 0.7,
                            ),
                          ),
                        ),
                        // Animated logo
                        AnimatedOpacity(
                          opacity: _logoOpacity,
                          duration: const Duration(milliseconds: 900),
                          curve: Curves.easeOut,
                          child: Image.asset(
                            'assets/img/logo.png',
                            width: 220,
                            height: 220,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 5),
                  // Headline and subtext much lower
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        Text(
                          'Welcome to OneTapp',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Your digital business card, always ready. Share your info with a single tap.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 2),
                  // Get Started Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _onButtonPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF7B61FF),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Get started',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 12),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              curve: Curves.easeOut,
                              margin: EdgeInsets.only(left: _arrowOffset),
                              decoration: BoxDecoration(
                                color: const Color(0xFF7B61FF),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(Icons.arrow_forward, color: Colors.white, size: 22),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Tagline at the bottom
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Powered by OneTapp',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} 