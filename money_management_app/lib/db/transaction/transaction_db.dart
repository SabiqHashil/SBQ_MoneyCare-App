import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_management_app/models/transaction/transaction_model.dart';

const TRANSACTION_DB_NAME = 'transaction-db';

abstract class TransactionDbFunctions {
  Future<void> addTransaction(TransactionModel obj);
  Future<List<TransactionModel>> getAllTransactions();
  Future<void> deleteTransaction(String id);
}

class TransactionDB implements TransactionDbFunctions {
  TransactionDB._internal();

  static TransactionDB instance = TransactionDB._internal();

  factory TransactionDB() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactionListNotifier =
      ValueNotifier([]);

  @override
  Future<void> addTransaction(TransactionModel obj) async {
    try {
      print('Opening box for adding transaction...');
      final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
      print('Putting transaction into the box...');
      await _db.put(obj.id, obj);
      print('Refreshing transactions after adding...');
      await refresh();
    } catch (e) {
      // Handle the exception (e.g., log it or show an error message)
      print('Error adding transaction: $e');
    }
  }

  Future<void> refresh() async {
    try {
      print('Refreshing transactions...');
      final _list = await getAllTransactions();
      _list.sort(
        (first, second) => second.date.compareTo(first.date),
      );
      transactionListNotifier.value = _list;
    } catch (e) {
      // Handle the exception (e.g., log it or show an error message)
      print('Error refreshing transactions: $e');
    } finally {
      print('Closing box after refreshing transactions...');
      await Hive.close();
      print('Notifying listeners after refreshing transactions...');
      transactionListNotifier.notifyListeners();
    }
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    try {
      print('Opening box for getting all transactions...');
      final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
      print('Getting all transactions from the box...');
      final transactions = _db.values.toList();
      return transactions;
    } catch (e) {
      // Handle the exception (e.g., log it or show an error message)
      print('Error getting all transactions: $e');
      return [];
    } finally {
      await Hive.close();
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _db.delete(id);
    refresh();
  }
}
