import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_management_app/db/category/category_db.dart';
import 'package:money_management_app/db/transaction/transaction_db.dart';
import 'package:money_management_app/models/categories/category_model.dart';
import 'package:money_management_app/models/transaction/transaction_model.dart';

class ScreenTransaction extends StatelessWidget {
  const ScreenTransaction({Key? key});

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refresh();
    CategoryDB.instance.refreshUI();
    return ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactionListNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
        return ListView.separated(
          padding: const EdgeInsets.all(10),
          // values
          itemBuilder: (ctx, index) {
            final _values = newList[index];
            return Card(
              elevation: 0,
              child: ListTile(
                leading: CircleAvatar(
                  radius: 50,
                  child: Text(
                    parseDate(_values.date),
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: _values.type == CategoryType.income
                      ? Colors.green
                      : Colors.red,
                ),
                title: Text(
                    'RS ${_values.amount.toString()}'), // Corrected from _value to _values
                subtitle: Text(
                    _values.category.name), // Corrected from _value to _values
              ),
            );
          },
          separatorBuilder: ((ctx, index) {
            return const SizedBox(height: 10);
          }),
          itemCount: newList.length,
        );
      },
    );
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _splitedDate = _date.split(' ');
    return '${_splitedDate.last}\n${_splitedDate.first}';
    // return '${date.day}\n${date.month}';
  }
}
