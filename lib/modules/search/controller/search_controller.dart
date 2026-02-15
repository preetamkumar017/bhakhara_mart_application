import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../product/repo/product_repo.dart';

class SearchVm extends GetxController {
  final ProductRepo _productRepo = ProductRepo();
  
  final query = ''.obs;
  final suggestions = <Map<String, dynamic>>[].obs;
  final searchResults = <ProductModel>[].obs;
  
  final isLoading = false.obs;
  final isSearching = false.obs;
  
  final errorMessage = ''.obs;
  
  // Track if user explicitly triggered search
  bool _explicitSearch = false;

  // Method called when user types in search field
  void onSearchChanged(String value) {
    query.value = value;
    _explicitSearch = false;
    
    if (value.isEmpty) {
      _clearResults();
      return;
    }
    
    // For 1-2 characters, always show suggestions (not search results)
    if (value.length <= 2) {
      _fetchSuggestions(value);
    }
    // For 3+ characters, if user explicitly searched, show results
    // Otherwise continue showing suggestions
    else if (_explicitSearch) {
      _searchProducts(value);
    } else {
      // Still show suggestions for 3+ chars until user explicitly searches
      _fetchSuggestions(value);
    }
  }

  // Explicit search - triggered by user
  void performSearch(String value) {
    if (value.isEmpty) return;
    _explicitSearch = true;
    query.value = value;
    _searchProducts(value);
  }

  void _clearResults() {
    suggestions.clear();
    searchResults.clear();
    errorMessage.value = '';
    _explicitSearch = false;
  }

  Future<void> _fetchSuggestions(String value) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final results = await _productRepo.getProductSuggestions(value);
      suggestions.value = results;
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
    // When selecting a suggestion, perform search
    performSearch(term);
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

