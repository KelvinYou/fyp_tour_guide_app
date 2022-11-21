import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/widget/app_theme.dart';

class CardList extends StatefulWidget {
  const CardList({super.key});

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
      ? const Center(
      child: CircularProgressIndicator(),
    ) : Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Bank Card List'),
      ),
      body: ListView(
        children: [
          Text("CardList"),
        ],
      ),
    );
  }

}