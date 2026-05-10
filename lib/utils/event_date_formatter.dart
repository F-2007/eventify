class EventDateFormatter {
  static const List<String> _months = [
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
    'Dec',
  ];

  static String formatDate(DateTime dateTime) {
    final month = _months[dateTime.month - 1];
    return '${dateTime.day} $month ${dateTime.year}';
  }

  static String formatTime(DateTime dateTime) {
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final hour = dateTime.hour == 0
        ? 12
        : dateTime.hour > 12
        ? dateTime.hour - 12
        : dateTime.hour;

    return '$hour:$minute $period';
  }
}
