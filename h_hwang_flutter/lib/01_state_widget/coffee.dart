import 'dart:convert';  // JSON 디코딩을 위한 라이브러리
import 'package:http/http.dart' as http;  // HTTP 요청을 위한 라이브러리

class Coffee {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  bool isFavorite;

  Coffee({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.isFavorite = false,
  });

  // JSON 데이터를 Coffee 객체로 변환하는 팩토리 생성자
  factory Coffee.fromJson(Map<String, dynamic> json) {
    return Coffee(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  // Coffee 객체를 JSON 형식으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
    };
  }

  // 서버에서 커피 목록을 가져오는 비동기 메서드
  static Future<List<Coffee>> fetchCoffees() async {
    final response = await http.get(
      Uri.parse('http://localhost:9000/coffees'),
      headers: {'Accept': 'application/json; charset=utf-8'},  // UTF-8 헤더 추가
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));  // UTF-8로 디코딩
      return data.map((json) => Coffee.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load coffees');
    }
  }

  // 서버에 새로운 커피를 추가하는 메서드
  static Future<void> addCoffee(Coffee coffee) async {
    final response = await http.post(
      Uri.parse('http://localhost:9000/coffees'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',  // UTF-8 헤더 추가
      },
      body: utf8.encode(jsonEncode(coffee.toJson())),  // UTF-8로 인코딩
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add coffee');
    }
  }

  // 서버에서 커피를 삭제하는 메서드
  static Future<void> deleteCoffee(int id) async {
    final response = await http.delete(
      Uri.parse('http://localhost:9000/coffees/$id'),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      final responseBody = utf8.decode(response.bodyBytes);
      throw Exception('Failed to delete coffee. Status code: ${response.statusCode}, Response body: $responseBody');
    }
  }

  // 서버에서 커피를 업데이트하는 메서드
  static Future<void> updateCoffee(Coffee coffee) async {
    final response = await http.put(
      Uri.parse('http://localhost:9000/coffees/${coffee.id}'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',  // UTF-8 헤더 추가
      },
      body: utf8.encode(jsonEncode(coffee.toJson())),  // UTF-8로 인코딩
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update coffee');
    }
  }

  // 좋아요 상태를 토글하는 메서드
  void toggleFavorite() {
    isFavorite = !isFavorite;
  }

  // 임의의 ID를 생성하는 메서드 (데모용, 실제로는 서버에서 관리)
  static int generateId() {
    return DateTime.now().millisecondsSinceEpoch;
  }
}
