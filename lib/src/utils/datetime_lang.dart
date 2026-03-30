String getMonthName(DateTime dateTime, {bool genitive = false}) {
  const nominative = [
    "Январь",
    "Февраль",
    "Март",
    "Апрель",
    "Май",
    "Июнь",
    "Июль",
    "Август",
    "Сентябрь",
    "Октябрь",
    "Ноябрь",
    "Декабрь"
  ];

  const genitiveMonths = [
    "Января",
    "Февраля",
    "Марта",
    "Апреля",
    "Мая",
    "Июня",
    "Июля",
    "Августа",
    "Сентября",
    "Октября",
    "Ноября",
    "Декабря"
  ];

  return genitive ? genitiveMonths[dateTime.month - 1] : nominative[dateTime.month - 1];
}

int dayOfYear(DateTime date) {
  final start = DateTime(date.year, 1, 1);
  return date.difference(start).inDays + 1;
}

int getLastDayOfMonth(DateTime date) {
  final lastDay = DateTime(date.year, date.month + 1, 0);
  return lastDay.day;
}
