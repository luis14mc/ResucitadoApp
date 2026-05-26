class StringUtils {
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }

  static String removeAccents(String text) {
    const accents = {
      'á': 'a',
      'à': 'a',
      'ä': 'a',
      'â': 'a',
      'ā': 'a',
      'ã': 'a',
      'é': 'e',
      'è': 'e',
      'ë': 'e',
      'ê': 'e',
      'ē': 'e',
      'í': 'i',
      'ì': 'i',
      'ï': 'i',
      'î': 'i',
      'ī': 'i',
      'ó': 'o',
      'ò': 'o',
      'ö': 'o',
      'ô': 'o',
      'ō': 'o',
      'õ': 'o',
      'ú': 'u',
      'ù': 'u',
      'ü': 'u',
      'û': 'u',
      'ū': 'u',
      'ñ': 'n',
      'ç': 'c',
    };

    String result = text.toLowerCase();
    accents.forEach((accent, replacement) {
      result = result.replaceAll(accent, replacement);
    });

    return result;
  }

  static bool containsIgnoreCase(String text, String query) {
    return removeAccents(text.toLowerCase())
        .contains(removeAccents(query.toLowerCase()));
  }

  static String truncate(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength - suffix.length) + suffix;
  }

  static String formatPhone(String phone) {
    // Remover todos los caracteres no numéricos
    String digits = phone.replaceAll(RegExp(r'[^\d]'), '');

    // Formato colombiano: +57 XXX XXX XXXX
    if (digits.length == 10) {
      return '+57 ${digits.substring(0, 3)} ${digits.substring(3, 6)} ${digits.substring(6)}';
    }

    return phone;
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    String digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    return digits.length >= 10;
  }
}
