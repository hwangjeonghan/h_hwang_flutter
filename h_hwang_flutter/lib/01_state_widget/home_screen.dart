import 'package:d_stateful_widget/01_state_widget/coffee_list.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Coffee Menu"),
      ),
      body: const CoffeeList(),
    );
  }
}
