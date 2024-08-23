import 'package:flutter/material.dart';
import 'coffee.dart';  // 커피 모델 임포트
import 'coffee_item.dart';  // 커피 항목 UI 임포트
import 'SingleChildScrollViewWidget.dart';  // 스크롤 가능 화면 위젯 임포트

class CoffeeList extends StatefulWidget {
  const CoffeeList({super.key});

  @override
  _CoffeeListState createState() => _CoffeeListState();
}

class _CoffeeListState extends State<CoffeeList> {
  late Future<List<Coffee>> _futureCoffeeList;

  @override
  void initState() {
    super.initState();
    _futureCoffeeList = Coffee.fetchCoffees();  // 서버에서 커피 목록을 가져옵니다.
  }

  Future<void> _removeCoffee(Coffee coffee) async {
    try {
      await Coffee.deleteCoffee(coffee.id);  // 서버에서 커피 삭제
      setState(() {
        _futureCoffeeList = Coffee.fetchCoffees();  // 목록을 새로 고침
      });
    } catch (e) {
      // 오류 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete coffee: $e')),
      );
    }
  }

  Future<void> _addCoffee(Coffee coffee) async {
    try {
      await Coffee.addCoffee(coffee);  // 서버에 커피 추가
      setState(() {
        _futureCoffeeList = Coffee.fetchCoffees();  // 목록을 새로 고침
      });
    } catch (e) {
      // 오류 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add coffee: $e')),
      );
    }
  }

  void _toggleFavorite(Coffee coffee) async {
    setState(() {
      coffee.toggleFavorite();  // 커피의 좋아요 상태를 토글합니다.
    });
    try {
      await Coffee.updateCoffee(coffee);  // 서버에 상태 업데이트
    } catch (e) {
      // 오류 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update coffee: $e')),
      );
    }
    setState(() {
      _futureCoffeeList = Coffee.fetchCoffees();  // 목록을 새로 고침
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Coffee>>(
        future: _futureCoffeeList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No coffees found.'));
          } else {
            final coffeeList = snapshot.data!;
            return ListView.builder(
              itemCount: coffeeList.length,
              itemBuilder: (context, index) {
                return CoffeeItem(
                  coffee: coffeeList[index],
                  onDelete: () => _removeCoffee(coffeeList[index]),
                  onFavoriteToggle: () => _toggleFavorite(coffeeList[index]),
                  index: index,
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Coffee? newCoffee = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SingleChildScrollViewWidget(
                onAddCoffee: (coffee) {
                  _addCoffee(coffee);  // 새로운 커피를 추가합니다.
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
