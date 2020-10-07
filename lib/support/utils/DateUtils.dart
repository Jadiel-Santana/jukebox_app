import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateUtils {
  DateUtils._();

  static DateUtils _instance;

  static DateUtils get instance {
    return _instance ??= DateUtils._();
  }

  /// Formata a data do empréstimo
  /// em pt-BR para exibição.
  /// @param DateTime date
  /// @returns String
  String dateToString(DateTime date) => DateFormat('dd/MM/yyyy', 'pt_Br').format(date);

  /// Formata a data do empréstimo
  /// em pt-BR para en-US.
  /// @param String date
  /// @returns DateTime
  DateTime stringToDate(String date) => DateFormat("dd/MM/yyyy").parse(date);

  /// Responsável por comparar
  /// duas datas em en-US.
  /// @param String date
  /// @returns DateTime
  int compareDates(String loan, String returnD) {
    DateTime loanDate = DateUtils.instance.stringToDate(loan);
    DateTime returnDate = DateUtils.instance.stringToDate(returnD);
    return loanDate.compareTo(returnDate);
  }
}