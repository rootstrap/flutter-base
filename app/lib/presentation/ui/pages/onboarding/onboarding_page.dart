import 'package:app/presentation/navigation/routers.dart';
import 'package:app/presentation/resources/locale/generated/l10n.dart';
import 'package:app/presentation/resources/resources.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.bounceInOut,
      );
    } else {
      // On the last page, handle start action
      _onStart();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onStart() {
    Routes.auth.go(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Page Indicator
            Padding(
              padding: const EdgeInsets.all(Dimen.spacingM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _totalPages,
                  (index) => Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: Dimen.spacingXs),
                    width:
                        _currentPage == index ? Dimen.spacingL : Dimen.spacingS,
                    height: Dimen.spacingS,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                      borderRadius: BorderRadius.circular(Dimen.spacingXs),
                    ),
                  ),
                ),
              ),
            ),

            // PageView
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  _buildPage(
                    title: S.of(context).onboardingPage1Title,
                    description: S.of(context).onboardingPage1Description,
                    icon: Icons.waving_hand,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  _buildPage(
                    title: S.of(context).onboardingPage2Title,
                    description: S.of(context).onboardingPage2Description,
                    icon: Icons.explore,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  _buildPage(
                    title: S.of(context).onboardingPage3Title,
                    description: S.of(context).onboardingPage3Description,
                    icon: Icons.people,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  _buildPage(
                    title: S.of(context).onboardingPage4Title,
                    description: S.of(context).onboardingPage4Description,
                    icon: Icons.rocket_launch,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ],
              ),
            ),

            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.all(Dimen.spacingL),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button (hidden on first page)
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: _previousPage,
                      child: Text(S.of(context).onboardingBack),
                    )
                  else
                    const SizedBox(width: 80), // Placeholder for alignment

                  // Next/Start Button
                  ElevatedButton(
                    onPressed: _nextPage,
                    child: Text(
                      _currentPage == _totalPages - 1
                          ? S.of(context).onboardingStart
                          : S.of(context).onboardingNext,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(Dimen.spacingXl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 120,
            color: color,
          ),
          const SizedBox(height: Dimen.spacingXl),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Dimen.spacingM),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
