import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../res/components/custom_textfield.dart';
import '../../../res/components/custom_button.dart';
import '../controller/search_controller.dart';

class SearchView extends StatelessWidget {
  SearchView({super.key});

  final SearchVm controller = Get.put(SearchVm());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              hintText: 'Search products',
              onChanged: controller.onQueryChanged,
            ),
            const SizedBox(height: 12),
            Obx(() {
              if (controller.query.isEmpty) {
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.recent
                      .map((term) => ActionChip(
                            label: Text(term),
                            onPressed: () => controller.useRecent(term),
                          ))
                      .toList(),
                );
              }
              if (controller.results.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Text('No results'),
                );
              }
              return Expanded(
                child: ListView.separated(
                  itemCount: controller.results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = controller.results[index];
                    return ListTile(
                      tileColor: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      title: Text('${item['name']}'),
                      subtitle: Text('₹${item['price']}'),
                      trailing: CustomButton(label: 'Add', fullWidth: false, onPressed: () {}),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

