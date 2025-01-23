import 'package:ir_datetime_picker/ir_datetime_picker.dart';

String formatCompactDate(DateTime dateTime) {
  Jalali date = Jalali.fromDateTime(dateTime);
  return "${date.formatter.yyyy}/${date.formatter.mm}/${date.formatter.dd}";
}
