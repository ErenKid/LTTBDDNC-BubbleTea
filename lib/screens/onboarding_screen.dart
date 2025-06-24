import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback? onFinish;
  const OnboardingScreen({super.key, this.onFinish});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPageData> _pages = [
    _OnboardingPageData(
      imageUrl: 'https://cdn.dribbble.com/users/2131993/screenshots/15687436/media/2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e.png',
      title: 'Welcome to ShareEat!',
      description: "Let's start reducing food waste and saving money on meals together.",
    ),
    _OnboardingPageData(
      imageUrl: 'https://cdn.dribbble.com/users/2131993/screenshots/15687436/media/1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e.png',
      title: 'How it works?',
      description: 'ShareEat connects you with local businesses who have surplus food inventory to sell at discounted prices.',
    ),
    _OnboardingPageData(
      imageUrl: 'https://cdn-icons-png.flaticon.com/512/3075/3075977.png',
      title: 'Track your impact',
      description: "See how much food waste you've helped reduce and money you've saved on meals. Share your impact with friends!",
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      widget.onFinish?.call();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryOrange,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final page = _pages[index];
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 48),
                      SizedBox(
                        height: 220,
                        child: Image.network(
                          page.imageUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          page.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (index == _pages.length - 1)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: widget.onFinish ?? () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppTheme.primaryOrange,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                textStyle: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              child: const Text("Let's ShareEat"),
                            ),
                          ),
                        ),
                      const SizedBox(height: 48),
                    ],
                  ),
                );
              },
            ),
            // Indicator
            Positioned(
              right: 10,
              top: MediaQuery.of(context).size.height * 0.43,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (i) => _buildIndicator(i)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      width: 8,
      height: 16,
      child: Center(
        child: Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? Colors.white : Colors.white.withOpacity(0.4),
          ),
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  final String imageUrl;
  final String title;
  final String description;
  const _OnboardingPageData({required this.imageUrl, required this.title, required this.description});
} 