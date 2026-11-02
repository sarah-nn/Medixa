import 'package:intl/intl.dart';

abstract final class DateFormatter {
  static String format(DateTime date, {String pattern = 'MMM d, yyyy'}) =>
      DateFormat(pattern).format(date.toLocal());
}
