String getMonthName(DateTime dateTime) {
  const months = [
    "Января",
    "Февраля",
    "Марта",
    "Апреля",
    "Майя",
    "Июня",
    "Июля",
    "Августа",
    "Сентября",
    "Октября",
    "Ноября",
    "Декабря",
  ];

  return months[dateTime.month - 1];
}

int getLastDayOfMonth(DateTime date) {
  final lastDay = DateTime(date.year, date.month + 1, 0);
  return lastDay.day;
}
