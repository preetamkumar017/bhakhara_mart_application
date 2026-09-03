import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/themes/app_colors.dart';
import '../controller/search_controller.dart';
import '../../product/view/product_card.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final SearchVm controller = Get.put(SearchVm());
  final TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void _doSearch(String query) {
    final q = query.trim();
    if (q.isNotEmpty) {
      textController.text = q;
      controller.performSearch(q);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Search Groceries & Staples'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Input with Button
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    onChanged: controller.onSearchChanged,
                    onSubmitted: (val) => _doSearch(val),
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: 'Search atta, dal, oil, milk, tea...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.primary),
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
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _doSearch(textController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Search', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // Error Message
          Obx(() {
            if (controller.errorMessage.value.isNotEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.red[50],
                child: Text(
                  controller.errorMessage.value,
                  style: TextStyle(color: Colors.red[700]),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // Content Area
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value || controller.isSearching.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // Show search discovery (trending & recent) when query is empty
              if (controller.query.value.isEmpty && controller.searchResults.isEmpty) {
                return _buildSearchDiscovery();
              }

              // Show suggestions while typing
              if (controller.suggestions.isNotEmpty && controller.searchResults.isEmpty) {
                return _buildSuggestionsList();
              }

              // No results
              if (controller.searchResults.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      const Text('No products found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        'Try searching for Atta, Milk, Dal, or Ghee',
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

  Widget _buildSearchDiscovery() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Trending Groceries
          if (controller.trendingSearches.isNotEmpty) ...[
            const Row(
              children: [
                Icon(Icons.local_fire_department, size: 18, color: Colors.orange),
                SizedBox(width: 6),
                Text(
                  'Trending Searches',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.trendingSearches.map((term) {
                return ActionChip(
                  avatar: const Icon(Icons.search, size: 14, color: AppColors.primary),
                  label: Text(term, style: const TextStyle(fontSize: 12)),
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.grey.shade300),
                  onPressed: () => _doSearch(term),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          /// Recent Searches
          if (controller.recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.history, size: 18, color: AppColors.textSecondary),
                    SizedBox(width: 6),
                    Text(
                      'Recent Searches',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => controller.clearRecentSearches(),
                  child: const Text('Clear All', style: TextStyle(fontSize: 12, color: AppColors.error)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.recentSearches.map((term) {
                return Chip(
                  label: Text(term, style: const TextStyle(fontSize: 12)),
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.grey.shade300),
                  deleteIcon: const Icon(Icons.close, size: 14, color: Colors.grey),
                  onDeleted: () => controller.removeRecentSearch(term),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuggestionsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Suggestions (${controller.suggestions.length})',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: controller.suggestions.length,
            itemBuilder: (context, index) {
              final item = controller.suggestions[index];
              return ListTile(
                leading: const Icon(Icons.search, color: AppColors.primary),
                title: Text(item['product_name'] ?? ''),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                onTap: () {
                  _doSearch(item['product_name'] ?? '');
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.68,
      ),
      itemCount: controller.searchResults.length,
      itemBuilder: (_, index) {
        return ProductCard(product: controller.searchResults[index]);
      },
    );
  }
}
