import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auty_conductor/feature/home/presentation/pages/home_page.dart';
import 'package:auty_conductor/feature/profile/presentation/pages/profile_page.dart';

class MainLayout extends StatefulWidget {
  final int initialIndex;
  const MainLayout({super.key, this.initialIndex = 0});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [HomePage(), ProfilePage()];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    const Color activeColor = Color(0xFF235EE8);
    const Color inactiveColor = Color(0xFFCDCCD4);

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages, // ✅ mantiene el estado de cada página
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            selectedItemColor: activeColor,
            unselectedItemColor: inactiveColor,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.network(
                  'https://raw.githubusercontent.com/AngelTG1/imagenes-web/refs/heads/main/SolarHome.svg',
                  colorFilter: ColorFilter.mode(inactiveColor, BlendMode.srcIn),
                  height: 25,
                ),
                activeIcon: SvgPicture.network(
                  'https://raw.githubusercontent.com/AngelTG1/imagenes-web/refs/heads/main/SolarHome.svg',
                  colorFilter: ColorFilter.mode(activeColor, BlendMode.srcIn),
                  height: 25,
                ),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.network(
                  'https://raw.githubusercontent.com/AngelTG1/imagenes-web/refs/heads/main/User.svg',
                  colorFilter: ColorFilter.mode(inactiveColor, BlendMode.srcIn),
                  height: 25,
                ),
                activeIcon: SvgPicture.network(
                  'https://raw.githubusercontent.com/AngelTG1/imagenes-web/refs/heads/main/User.svg',
                  colorFilter: ColorFilter.mode(activeColor, BlendMode.srcIn),
                  height: 25,
                ),
                label: 'Mi perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
