import 'package:intl/intl.dart';

convertConstantsToMessage({String? con, String from = "", String to = ""}) {
  DateFormat monthYear = DateFormat('MMMM, yyyy');
  DateFormat dateMonthYear = DateFormat('d MMM yy');
  if (con == "this_year") {
    return DateTime.now().year.toString();
  }

  if (con == "previous_year") {
    return (DateTime.now().year - 1).toString();
  }

  if (con == "this_month") {
    return monthYear.format(DateTime.now());
  }
  if (con == "previous_month") {
    return monthYear.format(DateTime.now().subtract(Duration(days: 30)));
  }

  if (con == "custom") {
    return dateMonthYear.format(DateTime.parse(from)) +
        " to " +
        dateMonthYear.format(DateTime.parse(to));
  }

  return con;
}
