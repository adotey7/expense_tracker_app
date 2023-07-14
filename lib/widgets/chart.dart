import 'package:expense_tracker/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  const Chart({super.key, required this.recentTransactions});

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(
          days: index,
        ),
      );
      var totalSum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    });
  }

  double get totalSPending {
    return groupedTransactions.fold(0.0, (sum, element) {
      return sum + (element['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Build() Chart');
    groupedTransactions;
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  (data['day'].toString()),
                  (data['amount'] as double),
                  totalSPending == 0
                      ? 0.0
                      : (data['amount'] as double) / totalSPending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
