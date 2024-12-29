import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remind/providers/task_provider.dart';
import 'package:remind/widgets/task_card.dart';
import 'package:remind/models/task_model.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  List<Task> _searchResults = [];

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    final allTasks = ref.read(taskListProvider);
    final results = allTasks.where((task) {
      final titleMatch = task.title.toLowerCase().contains(query.toLowerCase());
      final descMatch = task.description.toLowerCase().contains(query.toLowerCase());
      return titleMatch || descMatch;
    }).toList();

    setState(() => _searchResults = results);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search tasks...',
            border: InputBorder.none,
          ),
          onChanged: _performSearch,
        ),
      ),
      body: _searchResults.isEmpty
          ? Center(
              child: _searchController.text.isEmpty
                  ? const Text('Start typing to search')
                  : const Text('No results found'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return TaskCard(task: _searchResults[index]);
              },
            ),
    );
  }
} 