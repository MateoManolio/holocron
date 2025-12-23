import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/theme/app_theme.dart';
import '../../widgets/widgets.dart';
import '../home/home_page.dart';
import '../favorites/favorites_page.dart';
import '../home/widgets/holocron_app_bar.dart';
import '../../bloc/main/main_bloc.dart';
import '../../bloc/main/main_event.dart';
import '../../bloc/main/main_state.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onOptionSelected(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        if (_pageController.hasClients &&
            _pageController.page?.round() != state.selectedIndex) {
          _onOptionSelected(state.selectedIndex);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppTheme.spaceBlack,
          extendBodyBehindAppBar: true,
          appBar: HolocronAppBar(
            selectedIndex: state.selectedIndex,
            onOptionSelected: (index) {
              context.read<MainBloc>().add(MainTabChanged(index));
            },
          ),
          body: Stack(
            children: [
              const StarfieldBackground(),
              PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  context.read<MainBloc>().add(MainTabChanged(index));
                },
                physics: const BouncingScrollPhysics(),
                children: const [HomePage(), FavoritesPage()],
              ),
            ],
          ),
        );
      },
    );
  }
}
