import 'package:flutter/material.dart';
import 'package:bhakharamart/core/themes/app_colors.dart';

class ProductFilterOptions {
  String sortBy;
  bool inStockOnly;
  double? minPrice;
  double? maxPrice;

  ProductFilterOptions({
    this.sortBy = 'newest',
    this.inStockOnly = false,
    this.minPrice,
    this.maxPrice,
  });

  bool get hasActiveFilters =>
      sortBy != 'newest' || inStockOnly || minPrice != null || maxPrice != null;

  void reset() {
    sortBy = 'newest';
    inStockOnly = false;
    minPrice = null;
    maxPrice = null;
  }
}

class ProductFilterBottomSheet extends StatefulWidget {
  final ProductFilterOptions initialOptions;
  final Function(ProductFilterOptions) onApply;

  const ProductFilterBottomSheet({
    super.key,
    required this.initialOptions,
    required this.onApply,
  });

  static Future<void> show({
    required BuildContext context,
    required ProductFilterOptions initialOptions,
    required Function(ProductFilterOptions) onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ProductFilterBottomSheet(
        initialOptions: initialOptions,
        onApply: onApply,
      ),
    );
  }

  @override
  State<ProductFilterBottomSheet> createState() => _ProductFilterBottomSheetState();
}

class _ProductFilterBottomSheetState extends State<ProductFilterBottomSheet> {
  late String _sortBy;
  late bool _inStockOnly;
  RangeValues _priceRange = const RangeValues(0, 2000);

  final List<Map<String, String>> _sortOptions = [
    {'key': 'newest', 'label': 'Newest Arrivals'},
    {'key': 'price_asc', 'label': 'Price: Low to High'},
    {'key': 'price_desc', 'label': 'Price: High to Low'},
    {'key': 'popular', 'label': 'Name: A to Z'},
  ];

  @override
  void initState() {
    super.initState();
    _sortBy = widget.initialOptions.sortBy;
    _inStockOnly = widget.initialOptions.inStockOnly;
    _priceRange = RangeValues(
      widget.initialOptions.minPrice ?? 0,
      widget.initialOptions.maxPrice ?? 2000,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.tune, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'Filter & Sort',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _sortBy = 'newest';
                    _inStockOnly = false;
                    _priceRange = const RangeValues(0, 2000);
                  });
                },
                child: const Text(
                  'Reset',
                  style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const Divider(),

          /// Sort Options
          const SizedBox(height: 8),
          const Text(
            'Sort By',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _sortOptions.map((opt) {
              final isSelected = _sortBy == opt['key'];
              return ChoiceChip(
                label: Text(opt['label']!),
                selected: isSelected,
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _sortBy = opt['key']!);
                  }
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          /// In-stock Toggle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 20, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text(
                      'Show In-Stock Only',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Switch(
                  value: _inStockOnly,
                  activeColor: AppColors.primary,
                  onChanged: (val) => setState(() => _inStockOnly = val),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// Price Range Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Price Range',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                '₹${_priceRange.start.toInt()} - ₹${_priceRange.end.toInt()}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 2000,
            divisions: 40,
            activeColor: AppColors.primary,
            labels: RangeLabels(
              '₹${_priceRange.start.toInt()}',
              '₹${_priceRange.end.toInt()}',
            ),
            onChanged: (values) {
              setState(() => _priceRange = values);
            },
          ),

          const SizedBox(height: 16),

          /// Apply Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                final applied = ProductFilterOptions(
                  sortBy: _sortBy,
                  inStockOnly: _inStockOnly,
                  minPrice: _priceRange.start > 0 ? _priceRange.start : null,
                  maxPrice: _priceRange.end < 2000 ? _priceRange.end : null,
                );
                widget.onApply(applied);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'Apply Filters',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
