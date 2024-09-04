import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void sliverBlocBottomSheet<T extends StateStreamableSource<Object?>>(
  BuildContext context, {
  required T bloc,
  Widget? header,
  required Widget Function(BuildContext) builder,
}) =>
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const ContinuousRectangleBorder(),
        constraints: const BoxConstraints(maxHeight: 500),
        clipBehavior: Clip.hardEdge,
        builder: (_) {
          return BlocProvider<T>.value(
            value: bloc,
            child: CustomScrollView(
              slivers: [
                if (header != null) header,
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: builder(context),
                )
              ],
            ),
          );
        });
