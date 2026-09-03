import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/product_model.dart';
import '../../../data/network/api_endpoints.dart';
import '../../../data/network/network_api_services.dart';
import '../../product/repo/product_repo.dart';

class SearchVm extends GetxController {
  final ProductRepo _productRepo = ProductRepo();
  final NetworkApiServices _api = NetworkApiServices();

  final query = ''.obs;
  final suggestions = <Map<String, dynamic>>[].obs;
  final searchResults = <ProductModel>[].obs;
  final recentSearches = <String>[].obs;
  final trendingSearches = <String>[].obs;

  final isLoading = false.obs;
  final isSearching = false.obs;
  final errorMessage = ''.obs;

  bool _explicitSearch = false;

  @override
  void onInit() {
    super.onInit();
    _loadRecentSearches();
    _loadTrendingSearches();
  }

  Future<void> _loadRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('recent_grocery_searches') ?? [
        'Aashirvaad Atta',
        'Amul Butter',
        'Fortune Oil',
        'Sugar',
      ];
      recentSearches.assignAll(list);
    } catch (_) {}
  }

  Future<void> _saveRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('recent_grocery_searches', recentSearches.toList());
    } catch (_) {}
  }

  Future<void> _loadTrendingSearches() async {
    try {
      final res = await _api.getApi(ApiEndpoints.trendingSearches);
      if (res['status'] == true && res['data'] != null && res['data'] is List) {
        trendingSearches.assignAll((res['data'] as List).map((e) => e.toString()));
      } else {
        _setFallbackTrending();
      }
    } catch (_) {
      _setFallbackTrending();
    }
  }

  void _setFallbackTrending() {
    trendingSearches.assignAll([
      'Aashirvaad Atta',
      'Fortune Sunflower Oil',
      'Amul Butter',
      'Tata Salt',
      'Madhur Sugar',
      'Red Label Tea',
      'Basmati Rice',
      'Maggi',
    ]);
  }

  void onSearchChanged(String value) {
    query.value = value;
    _explicitSearch = false;

    if (value.isEmpty) {
      _clearResults();
      return;
    }

    if (value.length <= 2) {
      _fetchSuggestions(value);
    } else if (_explicitSearch) {
      _searchProducts(value);
    } else {
      _fetchSuggestions(value);
    }
  }

  void performSearch(String value) {
    if (value.trim().isEmpty) return;
    final term = value.trim();
    _explicitSearch = true;
    query.value = term;

    // Add to recent searches
    if (!recentSearches.contains(term)) {
      recentSearches.insert(0, term);
      if (recentSearches.length > 10) {
        recentSearches.removeLast();
      }
      _saveRecentSearches();
    }

    _searchProducts(term);
  }

  void removeRecentSearch(String term) {
    recentSearches.remove(term);
    _saveRecentSearches();
  }

  void clearRecentSearches() {
    recentSearches.clear();
    _saveRecentSearches();
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
    performSearch(term);
  }

  void clearSearch() {
    query.value = '';
    _clearResults();
  }
}
