import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../product/repo/product_repo.dart';

class SearchVm extends GetxController {
  final ProductRepo _productRepo = ProductRepo();
  
  final query = ''.obs;
  final suggestions = <Map<String, dynamic>>[].obs;
  final searchResults = <ProductModel>[].obs;
  final recent = <String>['Milk', 'Bread', 'Rice', 'Eggs'].obs;
  
  final isLoading = false.obs;
  final isSearching = false.obs;
  
  final errorMessage = ''.obs;

  // Method called when user types in search field
  void onSearchChanged(String value) {
    query.value = value;
    
    if (value.isEmpty) {
      _clearResults();
      return;
    }
    
    // For 1 character, show suggestions
    if (value.length == 1) {
      _fetchSuggestions(value);
    } 
    // For 2+ characters, search products
    else if (value.length >= 2) {
      _searchProducts(value);
    }
  }

  void _clearResults() {
    suggestions.clear();
    searchResults.clear();
    errorMessage.value = '';
  }

  Future<void> _fetchSuggestions(String value) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final results = await _productRepo.getProductSuggestions(value);
      suggestions.value = results;
      searchResults.clear();
    } catch (e) {
      errorMessage.value = 'Failed to load suggestions';
      suggestions.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _searchProducts(String value) async {
    try {
      isSearching.value = true;
      errorMessage.value = '';
      
      final results = await _productRepo.searchProducts(value);
      searchResults.value = results;
      suggestions.clear();
    } catch (e) {
      errorMessage.value = 'Failed to search products';
      searchResults.clear();
    } finally {
      isSearching.value = false;
    }
  }

  void useSuggestion(String term) {
    onSearchChanged(term);
  }

  void useRecent(String term) {
    onSearchChanged(term);
  }

  void clearSearch() {
    query.value = '';
    _clearResults();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

