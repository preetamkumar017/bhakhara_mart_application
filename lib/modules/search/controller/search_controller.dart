import 'package:get/get.dart';
import '../../../core/utils/debouncer.dart';

class SearchVm extends GetxController {
  final query = ''.obs;
  final results = <Map<String, dynamic>>[].obs;
  final recent = <String>['Milk', 'Bread', 'Rice', 'Eggs'].obs;

  final _debouncer = Debouncer();

  void onQueryChanged(String value) {
    query.value = value;
    _debouncer(() {
      _search(value);
    });
  }

  void _search(String value) {
    if (value.isEmpty) {
      results.clear();
      return;
    }
    results.value = List.generate(
      4,
      (i) => {
        'name': '$value result ${i + 1}',
        'price': 50 + i * 10,
      },
    );
  }

  void useRecent(String term) {
    onQueryChanged(term);
  }

  @override
  void onClose() {
    _debouncer.dispose();
    super.onClose();
  }
}

