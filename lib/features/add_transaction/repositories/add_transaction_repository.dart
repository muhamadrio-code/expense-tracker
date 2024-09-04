import 'package:expense_tracker/features/add_transaction/models/models.dart';

class AddTransactionRepository {
  Category? _category;

  void setCategory(Category category) {
    _category = category;
  }

  void printCategory() => print(_category);
}
