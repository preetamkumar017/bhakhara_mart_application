import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/search_controller.dart';
import '../../product/view/product_card.dart';

class SearchView extends StatefulWidget {
  SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final SearchVm controller = Get.put(SearchVm());
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial focus
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Products'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Search Input
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: textController,
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search for products...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Obx(() {
                  if (controller.query.value.isNotEmpty) {
                    return IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        textController.clear();
                        controller.clearSearch();
                      },
                    );
                  }
                  return const SizedBox.shrink();
                }),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),

          // Error Message
          Obx(() {
            if (controller.errorMessage.value.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          controller.errorMessage.value,
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // Content Area
          Expanded(
            child: Obx(() {
              // Loading state
              if (controller.isLoading.value || controller.isSearching.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // Empty query - show recent searches
              if (controller.query.value.isEmpty) {
                return _buildRecentSearches();
              }

              // Show suggestions for short queries (1 character)
              if (controller.query.value.length == 1) {
                if (controller.suggestions.isEmpty) {
                  return const Center(
                    child: Text('No suggestions found'),
                  );
                }
                return _buildSuggestionsList();
              }

              // Show search results for longer queries (2+ characters)
              if (controller.searchResults.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      const Text('No products found'),
                      const SizedBox(height: 8),
                      Text(
                        'Try different keywords',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              return _buildSearchResults();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Searches',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.recent
                .map((term) => ActionChip(
                      label: Text(term),
                      onPressed: () {
                        textController.text = term;
                        controller.useRecent(term);
                      },
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsList() {
    return ListView.builder(
      itemCount: controller.suggestions.length,
      itemBuilder: (context, index) {
        final item = controller.suggestions[index];
        return ListTile(
          leading: const Icon(Icons.search),
          title: Text(item['product_name'] ?? ''),
          onTap: () {
            textController.text = item['product_name'] ?? '';
            controller.useSuggestion(item['product_name'] ?? '');
          },
        );
      },
    );
  }

  Widget _buildSearchResults() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemCount: controller.searchResults.length,
      itemBuilder: (_, index) {
        return ProductCard(product: controller.searchResults[index]);
      },
    );
  }
}

