class CostConverter {
  static String convertToIndianCurrencyFormat(int number) {
    String result = "";
    if (number >= 10000000) {
      double crores = number / 10000000;
      result += crores.toStringAsFixed(2) + " Cr";
    } else if (number >= 100000) {
      double lakhs = number / 100000;
      result += lakhs.toStringAsFixed(2) + " L";
    } else if (number >= 1000) {
      double thousands = number / 1000;
      result += thousands.toStringAsFixed(2) + " Th";
    } else {
      result += number.toString();
    }
    return result;
  }
}
