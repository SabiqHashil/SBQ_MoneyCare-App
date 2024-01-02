import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_management_app/db/category/category_db.dart';
import 'package:money_management_app/db/transaction/transaction_db.dart';
import 'package:money_management_app/models/categories/category_model.dart';
import 'package:money_management_app/models/transaction/transaction_model.dart';

class ScreenTransaction extends StatelessWidget {
  const ScreenTransaction({Key? key});

  @override
  Widget build(BuildContext context) {
    // Create instances of CategoryDB and TransactionDB
    CategoryDB categoryDB = CategoryDB();
    TransactionDB transactionDB = TransactionDB();

    // Refresh data before building the UI
    transactionDB.refresh();
    categoryDB.refreshUI();

    return ValueListenableBuilder(
      valueListenable: transactionDB.transactionListNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
        return ListView.separated(
          padding: const EdgeInsets.all(10),
          // Build list items
          itemBuilder: (ctx, index) {
            final _values = newList[index];
            return Slidable(
              key: Key(_values.id!),
              startActionPane: ActionPane(motion: ScrollMotion(), children: [
                SlidableAction(
                  onPressed: (ctx) {
                    TransactionDB.instance.deleteTransaction(_values.id!);
                  },
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ]),
              child: Card(
                elevation: 0,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 50,
                    // Display formatted date
                    child: Text(
                      parseDate(_values.date),
                      textAlign: TextAlign.center,
                    ),
                    // Use different colors for income and expense
                    backgroundColor: _values.type == CategoryType.income
                        ? Colors.green
                        : Colors.red,
                  ),
                  title: Text('RS ${_values.amount.toString()}'),
                  subtitle: Text(_values.category.name),
                ),
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

  // Format date as 'day\nmonth'
  String parseDate(DateTime date) {
    final _formattedDate = DateFormat.MMMd().format(date);
    final _splitDate = _formattedDate.split(' ');
    return '${_splitDate.last}\n${_splitDate.first}';
  }
}
