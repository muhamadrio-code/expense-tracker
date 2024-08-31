import 'package:expense_tracker/features/add_transaction/bloc/expense_form/transaction_form_bloc.dart';
import 'package:expense_tracker/features/add_transaction/repositories/add_transaction_repository.dart';
import 'package:expense_tracker/features/add_transaction/bloc/category_bloc.dart';
import 'package:expense_tracker/features/add_transaction/categories.dart';
import 'package:expense_tracker/shared/extensions.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_transaction_appbar.dart';
part 'transaction_form_view.dart';
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
  final NumberFormat _numberFormat = NumberFormat.decimalPatternDigits(
      locale: Intl.defaultLocale, decimalDigits: 2);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => CategoryBloc(
                  addTransactionRepository: widget.repository,
                )),
        BlocProvider(
            create: (context) => TransactionFormBloc(
                  formatter: _numberFormat,
                )),
      ],
      child: const Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _AddTransactionAppBar(),
        body: Column(
          children: [
            Expanded(child: _TransactionCategories()),
            Align(
              alignment: Alignment.bottomCenter,
              child: _TransactionFormView(),
            )
          ],
        ),
      ),
    );
  }
}
