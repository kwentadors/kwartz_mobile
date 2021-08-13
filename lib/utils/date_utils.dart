import 'package:intl/intl.dart';

class DateUtils {
  static String toMonthName(int index) {
    return [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec,'
    ][index];
  }
}
