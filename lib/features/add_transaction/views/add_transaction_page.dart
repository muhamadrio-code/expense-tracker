import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:expense_tracker/features/account/bloc/accounts_bloc.dart';
import 'package:expense_tracker/features/add_transaction/bloc/expense_form/transaction_form_bloc.dart';
import 'package:expense_tracker/features/add_transaction/repositories/add_transaction_repository.dart';
import 'package:expense_tracker/features/add_transaction/bloc/category/category_bloc.dart';
import 'package:expense_tracker/features/add_transaction/categories.dart';
import 'package:expense_tracker/features/add_transaction/views/bottom_sheet/sliver_bottom_sheet.dart';
import 'package:expense_tracker/shared/date_picker.dart';
import 'package:expense_tracker/shared/extensions.dart';
import 'package:expense_tracker/shared/image_picker.dart';
import 'package:expense_tracker/shared/views/image_preview.dart';
import 'package:expense_tracker/shared/views/sliver_bottomsheetheader_delegate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_transaction_appbar.dart';
part 'transaction_form_view.dart';
part 'add_transaction_categories.dart';
part 'bottom_sheet/images_bottom_sheet.dart';
part 'bottom_sheet/accounts_bottom_sheet.dart';

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
        BlocProvider(create: (context) => AccountsBloc()),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const _AddTransactionAppBar(),
        body: BlocBuilder<CategoryBloc, CategoryBlocState>(
          builder: (context, state) {
            bool isCategorySelected = state.categoryName.isNotEmpty;
            Matrix4 matrix = Matrix4.identity();
            if (!isCategorySelected) matrix.translate(0.0, 500.0, 0.0);
            return Column(
              children: [
                const Expanded(child: _TransactionCategories()),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: matrix,
                  child: const _TransactionFormView(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
