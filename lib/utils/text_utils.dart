import 'package:intl/intl.dart';

String formatCurrency(num number, {int precision = 2}) {
  return NumberFormat.simpleCurrency(decimalDigits: precision, name: "")
      .format(number);
}
