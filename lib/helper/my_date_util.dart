import 'package:flutter/material.dart';

class MyDateUtil {
  // for getting formatted time from milliSecondsSinceEpochs String
  static String getEventDetailDate(DateTime dateTime) {
    String date =
        "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    String time =
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";
    DateTime newdate = DateTime.parse(date);
    String day = getDayFromDate(newdate);
    String month = getMonthFromDate(newdate);
    String dd = newdate.day.toString();
    return "${dd} ${month}, ${dateTime.year}";
  }

  static String getEventDetailTime(String mdate) {
    DateTime dateTime = DateTime.parse(mdate);
    String date =
        "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    String time =
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";
    DateTime newdate = DateTime.parse(date);
    DateTime dateeTime = DateTime.parse(mdate);
    String day = getDayFromDate(newdate);
    String month = getMonthFromDate(newdate);
    String dd = newdate.day.toString();
    return "${day}, ${get12HrFormat(dateeTime)}";
  }

  static String get12HrFormat(DateTime time) {
    int hour = time.hour;
    int minute = time.minute;
    String period = (hour < 12) ? 'AM' : 'PM';
    if (hour == 0) {
      hour = 12;
    } else if (hour > 12) {
      hour -= 12;
    }
    String formattedTime = '$hour:${minute.toString().padLeft(2, '0')} $period';
    return formattedTime;
  }

  static String getMonthFromDate(DateTime date) {
    String month = '';

    switch (date.month) {
      case 1:
        month = 'January';
        break;
      case 2:
        month = 'February';
        break;
      case 3:
        month = 'March';
        break;
      case 4:
        month = 'April';
        break;
      case 5:
        month = 'May';
        break;
      case 6:
        month = 'June';
        break;
      case 7:
        month = 'July';
        break;
      case 8:
        month = 'August';
        break;
      case 9:
        month = 'September';
        break;
      case 10:
        month = 'October';
        break;
      case 11:
        month = 'November';
        break;
      case 12:
        month = 'December';
        break;
    }

    return month;
  }

  static String getDayFromDate(DateTime date) {
    String day = '';

    switch (date.weekday) {
      case DateTime.monday:
        day = 'Mon';
        break;
      case DateTime.tuesday:
        day = 'Tue';
        break;
      case DateTime.wednesday:
        day = 'Wed';
        break;
      case DateTime.thursday:
        day = 'Thu';
        break;
      case DateTime.friday:
        day = 'Fri';
        break;
      case DateTime.saturday:
        day = 'Sat';
        break;
      case DateTime.sunday:
        day = 'Sun';
        break;
    }

    return day;
  }
}
