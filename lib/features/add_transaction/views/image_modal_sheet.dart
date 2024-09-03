part of 'add_transaction_page.dart';

void openImagesSheet(BuildContext context) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const ContinuousRectangleBorder(),
    constraints: const BoxConstraints(maxHeight: 500),
    clipBehavior: Clip.hardEdge,
    builder: (_) {
      return BlocProvider.value(
        value: BlocProvider.of<TransactionFormBloc>(context),
        child: const CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverHeaderDelegateComponent(),
            ),
            SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: _SliverImageTiles(),
            )
          ],
        ),
      );
    });

class _SliverHeaderDelegateComponent extends SliverPersistentHeaderDelegate {
  const _SliverHeaderDelegateComponent();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return const _SheetImagesHeader();
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;

  @override
  double get maxExtent => kToolbarHeight + 16;

  @override
  double get minExtent => kToolbarHeight + 16;
}

class _SliverImageTiles extends StatelessWidget {
  const _SliverImageTiles();

  @override
  Widget build(BuildContext context) {
    void saveImage(List<XFile> files) {
      List<String> pathsString = files.map((e) => e.path).toList();
      context
          .read<TransactionFormBloc>()
          .add(AddImageEvent.success(pathsString));
    }

    void onError(Exception e) {
      context.read<TransactionFormBloc>().add(AddImageEvent.error(e));
    }

    void deleteImage(int index) {
      context.read<TransactionFormBloc>().add(DeleteImageEvent(index: index));
    }

    void viewImage(int index) {
      //TODO: buat screen untuk view image;
    }

    void showImagePicker() =>
        showImagePickerDialog(context, onSuccess: saveImage, onError: onError);

    Widget addImageBox = GestureDetector(
      onTap: showImagePicker,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerHighest,
          border: Border.all(color: context.colors.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.add_rounded,
              size: 44,
              color: context.colors.outline,
            )
          ],
        ),
      ),
    );

    return BlocSelector<TransactionFormBloc, TransactionFormState,
        List<String>>(
      selector: (state) => state.data.images,
      builder: (context, images) {
        return SliverGrid.builder(
          itemCount: images.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            Widget widget;
            if (index == 0) {
              widget = addImageBox;
            } else {
              widget = _ImageTile(
                path: images[index - 1],
                onDelete: () => deleteImage(index - 1),
                onPressed: () => viewImage(index - 1),
              );
            }

            return widget;
          },
        );
      },
    );
  }
}

class _ImageTile extends StatelessWidget {
  const _ImageTile({
    required this.path,
    required this.onDelete,
    required this.onPressed,
  });

  final VoidCallback onDelete;
  final VoidCallback onPressed;
  final String path;

  @override
  Widget build(BuildContext context) {
    final File file = File(path);
    final child = Image.file(
      file,
      fit: BoxFit.cover,
    );

    final Widget deleteIcon = Align(
      alignment: const Alignment(.9, -.9),
      child: GestureDetector(
        onTap: onDelete,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red[400],
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(4),
          child: const Icon(
            Icons.close,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
    );

    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey,
            ),
            child: child,
          ),
          deleteIcon
        ],
      ),
    );
  }
}

class _SheetImagesHeader extends StatelessWidget {
  const _SheetImagesHeader();

  @override
  Widget build(BuildContext context) {
    void closeSheet() => Navigator.pop(context);

    final TextStyle titleStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: context.colors.onSurface,
      fontSize: 20,
    );
    final Widget title = Text(
      "Foto",
      style: titleStyle,
    );

    const Widget actionIcon = Icon(Icons.check_rounded);
    final Widget action = IconButton(
      onPressed: closeSheet,
      icon: actionIcon,
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Expanded(child: title), Flexible(child: action)],
      ),
    );
  }
}
