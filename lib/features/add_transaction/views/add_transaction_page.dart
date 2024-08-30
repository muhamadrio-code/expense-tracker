import 'package:expense_tracker/features/add_transaction/repositories/add_transaction_repository.dart';
import 'package:expense_tracker/features/add_transaction/bloc/category_bloc.dart';
import 'package:expense_tracker/features/add_transaction/categories.dart';
import '../models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_transaction_appbar.dart';
part 'add_transaction_numpad.dart';
part 'add_transaction_categories.dart';

class AddTransactionPage extends StatefulWidget {
  final AddTransactionRepository repository;

  const AddTransactionPage({
    required this.repository,
    super.key,
  });

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryBloc(
        addTransactionRepository: widget.repository,
      ),
      child: const Scaffold(
        appBar: _AddTransactionAppBar(),
        body: _AddTransactionTabItem(),
      ),
    );
  }
}

class _AddTransactionNoteTextField extends StatelessWidget {
  const _AddTransactionNoteTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const IntrinsicHeight(
        child: TextField(
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            isDense: true,
          ),
          keyboardType: TextInputType.multiline,
          maxLines: null,
          maxLength: 144,
          autocorrect: false,
          showCursor: false,
        ),
      ),
    );
  }
}
