import 'package:flutter/material.dart';
import 'coffee.dart';

class CoffeeItem extends StatelessWidget {
  final Coffee coffee;
  final VoidCallback onDelete;
  final VoidCallback onFavoriteToggle;
  final int? index;

  const CoffeeItem({
    required this.coffee,
    required this.onDelete,
    required this.onFavoriteToggle,
    this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // 1. 번호
            if (index != null)
              Container(
                width: 30,
                alignment: Alignment.center,
                child: Text(
                  '${index! + 1}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )
            else
              Container(
                width: 30,
                alignment: Alignment.center,
                child: const Text(
                  'N/A',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(width: 8),

            // 2. 이미지
            Container(
              constraints: BoxConstraints(
                maxWidth: 100,
                maxHeight: 100,
              ),
              child: Image.network(
                "${coffee.imageUrl}?${DateTime.now().millisecondsSinceEpoch}",
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) {
                    return child;
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(child: Icon(Icons.error, color: Colors.red));
                },
              ),
            ),
            const SizedBox(width: 8),

            // 3. 제목과 내용
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coffee.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(coffee.description),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // 4. 좋아요 버튼
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(
                  coffee.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: coffee.isFavorite ? Colors.red : null,
                ),
                onPressed: onFavoriteToggle,
              ),
            ),
            const SizedBox(width: 8),

            // 5. 삭제 버튼
            Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: onDelete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
