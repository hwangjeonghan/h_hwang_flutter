import 'package:flutter/material.dart';
import 'coffee.dart';

class SingleChildScrollViewWidget extends StatelessWidget {
  final Function(Coffee coffee) onAddCoffee;

  const SingleChildScrollViewWidget({required this.onAddCoffee, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Coffee"),
      ),
      body: SingleChildScrollView(
        child: FormWidget(
          onAddCoffee: (coffee) {
            onAddCoffee(coffee);  // 새로운 커피를 추가하는 콜백
            Navigator.of(context).pop();  // 이전 화면으로 돌아가기
          },
        ),
      ),
    );
  }
}
class FormWidget extends StatefulWidget {
  final Function(Coffee coffee) onAddCoffee;

  const FormWidget({required this.onAddCoffee, super.key});

  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String description;
  late String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '이름을 입력해주세요';
              }
              return null;
            },
            onSaved: (value) {
              name = value!;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Description'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '설명을 입력해주세요';
              }
              return null;
            },
            onSaved: (value) {
              description = value!;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Image URL'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '이미지 URL을 입력해주세요';
              }
              return null;
            },
            onSaved: (value) {
              imageUrl = value!;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                widget.onAddCoffee(
                  Coffee(
                    id: Coffee.generateId(),  // 커피 ID 생성
                    name: name,
                    description: description,
                    imageUrl: imageUrl,
                  ),
                );
              }
            },
            child: const Text("등록하기"),
          ),
        ],
      ),
    );
  }
}