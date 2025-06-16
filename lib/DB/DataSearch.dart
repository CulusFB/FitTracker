DateTime findNearestMonday(DateTime date) {
  int daysBeforeMonday =
      ((date.weekday - 1) % 7); // Разница дней до понедельника
  return date.subtract(Duration(days: daysBeforeMonday));
}

DateTime findNearestSunday(DateTime date) {
  int daysUntilSunday =
      (-date.weekday) % 7; // Разница дней до следующего воскресенья
  if (daysUntilSunday < 0) daysUntilSunday += 7;
  return date.add(Duration(days: daysUntilSunday));
}
