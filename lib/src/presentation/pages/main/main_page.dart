import 'package:flutter/material.dart';
import '../../../config/theme/app_theme.dart';
import '../../widgets/widgets.dart';
import '../home/home_page.dart';
import '../favorites/favorites_page.dart';
import '../home/widgets/holocron_app_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onOptionSelected(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.spaceBlack,
      extendBodyBehindAppBar: true,
      appBar: HolocronAppBar(
        selectedIndex: _selectedIndex,
        onOptionSelected: _onOptionSelected,
      ),
      body: Stack(
        children: [
          const StarfieldBackground(),
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: const BouncingScrollPhysics(),
            children: const [HomePage(), FavoritesPage()],
          ),
        ],
      ),
    );
  }
}

