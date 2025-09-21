import 'package:flutter/material.dart';
import 'package:gain_quest/data/models/navigation_item_mode.dart';
import 'package:gain_quest/presentation/screens/home/home_screen.dart';
import 'package:gain_quest/presentation/screens/live/live_stream_screen.dart';
import 'package:gain_quest/presentation/screens/profile/profile_screen.dart';
import 'package:gain_quest/presentation/screens/team/team_screen.dart';
import 'package:gain_quest/presentation/widgets/bet_sheet.dart';
import 'package:get/get.dart';


class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  final List<Widget> _screens = [
    HomeScreen(),
    TeamsScreen(),
    LiveStreamsScreen(),
    ProfileScreen(),
  ];

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
    ),
    NavigationItem(
      icon: Icons.groups_outlined,
      activeIcon: Icons.groups,
      label: 'Teams',
    ),
    NavigationItem(
      icon: Icons.live_tv_outlined,
      activeIcon: Icons.live_tv,
      label: 'Live',
    ),
    NavigationItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fabAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Get.theme.bottomNavigationBarTheme.backgroundColor,
          selectedItemColor: Get.theme.primaryColor,
          unselectedItemColor: Get.theme.colorScheme.onSurface.withOpacity(0.5),
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
          items: _navigationItems.map((item) {
            int index = _navigationItems.indexOf(item);
            bool isSelected = _currentIndex == index;
            
            return BottomNavigationBarItem(
              icon: AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                child: Container(
                  key: ValueKey(isSelected),
                  padding: EdgeInsets.all(8),
                  decoration: isSelected
                      ? BoxDecoration(
                          color: Get.theme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        )
                      : null,
                  child: Icon(
                    isSelected ? item.activeIcon : item.icon,
                    size: 24,
                  ),
                ),
              ),
              label: item.label,
            );
          }).toList(),
        ),
      ),
      floatingActionButton: _currentIndex == 0
          ? ScaleTransition(
              scale: _fabAnimation,
              child: FloatingActionButton(
                onPressed: () {
                  // Navigate to place bet screen or show bet dialog
                  _showQuickBetDialog();
                },
                backgroundColor: Get.theme.colorScheme.secondary,
                foregroundColor: Colors.white,
                child: Icon(Icons.add),
                tooltip: 'Quick Bet',
              ),
            )
          : null,
    );
  }

  void _showQuickBetDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuickBetSheet(),
    );
  }
}



