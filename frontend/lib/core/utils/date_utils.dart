import 'package:intl/intl.dart';

class DateUtils {
  static String formatDate(DateTime date, {String pattern = 'dd/MM/yyyy'}) {
    return DateFormat(pattern).format(date);
  }

  static String formatTime(DateTime time, {String pattern = 'HH:mm'}) {
    return DateFormat(pattern).format(time);
  }

  static DateTime parseDate(String dateString,
      {String pattern = 'yyyy-MM-dd'}) {
    return DateFormat(pattern).parse(dateString);
  }

  static String getRelativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hoy';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays == -1) {
      return 'Mañana';
    } else if (difference.inDays < 7 && difference.inDays > 0) {
      return '${difference.inDays} días atrás';
    } else if (difference.inDays > -7 && difference.inDays < 0) {
      return 'En ${difference.inDays.abs()} días';
    } else {
      return formatDate(date);
    }
  }

  static String getMonthName(int month) {
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];
    return months[month - 1];
  }

  static String getDayName(int weekday) {
    const days = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo'
    ];
    return days[weekday - 1];
  }
}
