import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final bool enabled;
  final ValueChanged<String> onChanged;

  const SearchField({
    super.key,
    required this.enabled,
    required this.onChanged,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController searchController = TextEditingController(
    text: '',
  );

  bool get enabled => widget.enabled;

  ValueChanged<String> get onChanged => widget.onChanged;

  void searchDebouncingListener() {
    onChanged(searchController.text);
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(searchDebouncingListener);
  }

  @override
  void dispose() {
    searchController
      ..removeListener(searchDebouncingListener)
      ..dispose();
    super.dispose();
  }

  VoidCallback? get onPressedSuffix =>
      searchController.text.isNotEmpty ? searchController.clear : null;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: searchController,
      builder: (context, search, child) {
        return TextField(
          enabled: enabled,
          controller: searchController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Поиск...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              onPressed: onPressedSuffix,
              icon: const Icon(Icons.close),
            ),
          ),
        );
      },
    );
  }
}
