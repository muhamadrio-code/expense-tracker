part of '../add_transaction_page.dart';

void showAccountsModalBottomSheet(BuildContext context) {
  Widget header = SliverPersistentHeader(
    pinned: true,
    delegate: SliverBottomSheetHeaderDelegate(
        title: "Rekening",
        centerTItle: true,
        leadingIcon: const Icon(Icons.close_rounded),
        trailingIcon: IconButton(
            onPressed: () {
              //Todo: go to ManageAccount page
            },
            icon: const Icon(Icons.add_box))),
  );

  Widget contentBuilder(BuildContext c) => const _SliverAccountList();

  return sliverBlocBottomSheet(
    context,
    header: header,
    bloc: BlocProvider.of<AccountsBloc>(context),
    builder: contentBuilder,
  );
}

class _SliverAccountList extends StatelessWidget {
  const _SliverAccountList();

  @override
  Widget build(BuildContext context) {
    const TextStyle leadingStyle = TextStyle(fontSize: 18);
    final formatter = NumberFormat.decimalPattern();

    return BlocBuilder<AccountsBloc, AccountsState>(
      buildWhen: (previous, current) => !current.isError,
      builder: (context, state) {
        return SliverList.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemCount: state.accounts.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(state.accounts[index].name),
                subtitle: Text(state.accounts[index].accountType.name),
                leading: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.amber),
                  padding: const EdgeInsets.all(12),
                  child: const Icon(Icons.credit_card),
                ),
                trailing: Text(
                  formatter.format(int.parse(state.accounts[index].amount)),
                  style: leadingStyle,
                ),
              );
            });
      },
    );
  }
}
