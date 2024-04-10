import 'package:flutter/material.dart';
import 'package:pm2_5_term_project/home/widgets/notifications.dart';
import 'package:pm2_5_term_project/home/widgets/details_show.dart';
import 'package:pm2_5_term_project/home/widgets/search_page.dart';

var kBottomBarBackgroundColor = Colors.green[600];
var kBottomBarForegroundActiveColor = Colors.white;
var kBottomBarForegroundInactiveColor = Colors.white60;
var kAppBarBackgroundColor = Colors.green[200];
var kSplashColor = Colors.green[400];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _handleClickButton(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildPageBody() {
      switch (_selectedIndex) {
        case 0:
          return const AppNotifications();
        case 1:
          return const DetailsShow();
        case 2:
          return const SearchPage();
        default:
          return const DetailsShow();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Real-time Air Quality Index (AQI)')),
        backgroundColor: kAppBarBackgroundColor,
      ),
      floatingActionButton: SizedBox(
        width: 80.0,
        height: 80.0,
        child: FloatingActionButton(
          backgroundColor: kBottomBarBackgroundColor,
          shape: CircleBorder(),
          onPressed: () {},
          child: AppBottomMenuItem(
            iconData: _selectedIndex == 1 ? Icons.refresh : Icons.today,
            text: _selectedIndex == 1 ? 'Refresh' : 'TODAY',
            isSelected: _selectedIndex == 1,
            onClick: () => _handleClickButton(1),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 64.0,
        padding: EdgeInsets.zero,
        color: kBottomBarBackgroundColor,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: AppBottomMenuItem(
                iconData: Icons.schedule,
                text: 'ข้อมูลย้อนหลัง',
                isSelected: _selectedIndex == 0,
                onClick: () => _handleClickButton(0),
              ),
            ),
            SizedBox(width: 100.0),
            Expanded(
              child: AppBottomMenuItem(
                iconData: Icons.search,
                text: 'ค้นหาด้วยชื่อเมือง',
                isSelected: _selectedIndex == 2,
                onClick: () => _handleClickButton(2),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: _buildPageBody(),
      ),
    );
  }
}

class AppBottomMenuItem extends StatelessWidget {
  AppBottomMenuItem({
    super.key,
    required this.iconData,
    required this.text,
    required this.isSelected,
    required this.onClick,
  });

  final IconData iconData;
  final String text;
  final bool isSelected;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var color = isSelected
        ? kBottomBarForegroundActiveColor
        : kBottomBarForegroundInactiveColor;

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onClick,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(iconData, color: color),
              SizedBox(height: 4.0),
              Text(
                text,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelMedium!.copyWith(
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
