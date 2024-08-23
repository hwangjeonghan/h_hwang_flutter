import 'package:flutter/material.dart';
import 'coffee.dart';
import 'coffee_item.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Future<List<Coffee>> _futureCoffeeList;

  @override
  void initState() {
    super.initState();
    _loadCoffees();  // 커피 목록 로드
  }

  void _loadCoffees() {
    setState(() {
      _futureCoffeeList = Coffee.fetchCoffees();  // 상태 업데이트
    });
  }

  void _toggleFavorite(Coffee coffee) async {
    setState(() {
      coffee.toggleFavorite();  // 좋아요 상태 토글
    });
    try {
      await Coffee.updateCoffee(coffee);  // 서버에 상태 업데이트
      _loadCoffees();  // 상태 업데이트 후 목록 다시 로드
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update favorite status: $e')),
      );
    }
  }

  void _removeCoffee(Coffee coffee) async {
    try {
      await Coffee.deleteCoffee(coffee.id);  // 커피 삭제
      _loadCoffees();  // 삭제 후 목록 다시 로드
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete coffee: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Coffee>>(
      future: _futureCoffeeList,  // 서버에서 커피 목록을 가져옵니다.
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No favorite coffees found.'));
        } else {
          final favoriteCoffees = snapshot.data!.where((coffee) => coffee.isFavorite).toList();
          return ListView.builder(
            itemCount: favoriteCoffees.length,
            itemBuilder: (context, index) {
              return CoffeeItem(
                coffee: favoriteCoffees[index],
                onDelete: () => _removeCoffee(favoriteCoffees[index]),  // 커피 삭제
                onFavoriteToggle: () => _toggleFavorite(favoriteCoffees[index]),  // 좋아요 상태 토글
                index: index,
              );
            },
          );
        }
      },
    );
  }
}
