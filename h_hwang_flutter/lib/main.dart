import 'package:flutter/material.dart';
import '01_state_widget/coffee_list.dart';  // 커피 목록 화면 임포트
import '01_state_widget/favorite_screen.dart';  // 즐겨찾기 화면 임포트

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Card',
      theme: ThemeData(
        primarySwatch: Colors.brown,  // 앱의 기본 색상
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;  // 현재 선택된 탭의 인덱스

  final List<Widget> _screens = [
    const CoffeeList(),  // 커피 목록 화면
    const FavoriteScreen(),  // 즐겨찾기 화면
  ];

  // BottomNavigationBar에서 탭이 선택되었을 때 호출되는 메서드
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;  // 선택된 탭 인덱스 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Coffee Card',
          style: TextStyle(color: Colors.white),  // AppBar 텍스트 색상
        ),
        backgroundColor: Colors.blue,  // AppBar 배경색
      ),
      body: _screens[_selectedIndex],  // 선택된 화면 표시
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.coffee),  // 커피 아이콘
            label: 'Menu',  // 메뉴 탭 레이블
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),  // 즐겨찾기 아이콘
            label: 'Favorites',  // 즐겨찾기 탭 레이블
          ),
        ],
        currentIndex: _selectedIndex,  // 현재 선택된 탭 인덱스
        onTap: _onItemTapped,  // 탭 선택 시 호출되는 메서드
      ),
    );
  }
}
