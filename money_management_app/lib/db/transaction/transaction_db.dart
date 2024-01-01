import 'package:hive/hive.dart';
import 'package:money_management_app/models/transaction/transaction_model.dart';

const TRANSACTION_DB_NAME = 'transaction-db';

abstract class TransactionDbFunctions {
  Future<void> addTransactioin(TransactionModel obj);
}

class TransactionDB implements TransactionDbFunctions {
  @override
  Future<void> addTransactioin(TransactionModel obj) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _db.put(obj.id, obj);
  }
}
