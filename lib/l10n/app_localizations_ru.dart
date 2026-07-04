import 'app_localizations.dart';

final class AppLocalizationsRu extends AppLocalizations {
  const AppLocalizationsRu();

  @override String get appName => 'Ship Hours';
  @override String get calendar => 'Календарь';
  @override String get day => 'День';
  @override String get statistics => 'Статистика';
  @override String get settings => 'Настройки';
  @override String get regularHours => 'Обычные часы';
  @override String get overtimeHours => 'Сверхурочные часы';
  @override String get holidayHours => 'Праздничные часы';
  @override String get totalHours => 'Всего часов';
  @override String get regularRate => 'Обычная ставка';
  @override String get overtimeRate => 'Ставка сверхурочных';
  @override String get regularPay => 'Обычная оплата';
  @override String get overtimePay => 'Сверхурочная оплата';
  @override String get holidayPay => 'Праздничная оплата';
  @override String get totalPay => 'Общая оплата';
  @override String get currency => 'Валюта';
  @override String get theme => 'Тема';
  @override String get systemTheme => 'Системная';
  @override String get lightTheme => 'Светлая';
  @override String get darkTheme => 'Тёмная';
  @override String get language => 'Язык';
  @override String get clearDay => 'Очистить день';
  @override String get companyRules => 'Правила компании';
  @override String get weekendOvertime => 'Все часы в выходные — сверхурочные';
  @override String get moveWeekendHoliday => 'Переносить праздник с выходного на следующий рабочий день';
  @override String get companyHolidays => 'Праздники компании';
  @override String get addHoliday => 'Добавить праздник';
  @override String get noHolidays => 'Праздники компании не добавлены';
  @override String get contract => 'Контракт';
  @override String get company => 'Компания';
  @override String get vessel => 'Судно';
  @override String get rank => 'Должность';
  @override String get contractStart => 'Начало контракта';
  @override String get contractEnd => 'Конец контракта';
  @override String get notSet => 'Не указано';
  @override String get observedHoliday => 'Перенесённый праздник';
}
