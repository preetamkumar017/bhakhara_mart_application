class Formatters {
  static String currency(num value) => '₹${value.toStringAsFixed(0)}';

  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

