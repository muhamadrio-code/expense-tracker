import 'package:equatable/equatable.dart';
import 'package:expense_tracker/features/add_transaction/models/models.dart';

class Category extends Equatable {
  final CategoryType type;
  final String name;
  final int index;

  const Category({
    required this.type,
    required this.name,
    required this.index,
  });

  @override
  List<Object?> get props => [type, name, index];
}
