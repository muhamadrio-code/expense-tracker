part of '../add_transaction_page.dart';

void showImagesModalBottomSheet(BuildContext context) {
  Widget header = const SliverPersistentHeader(
    pinned: true,
    delegate: SliverBottomSheetHeaderDelegate(title: "Foto"),
  );

  Widget contentBuilder(BuildContext c) => const _SliverImagesGrid();

  return sliverBlocBottomSheet(
    context,
    header: header,
    bloc: BlocProvider.of<TransactionFormBloc>(context),
    builder: contentBuilder,
  );
}

class _SliverImagesGrid extends StatelessWidget {
  const _SliverImagesGrid();

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

    void viewImage(List<String> images, int startIndex) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ImagePreview(images: images, startIndex: startIndex);
      }));
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
              childAspectRatio: 1 / 1.1),
          itemBuilder: (context, index) => index == 0
              ? addImageBox
              : _ImageTile(
                  path: images[index - 1],
                  onDelete: () => deleteImage(index - 1),
                  onPressed: () => viewImage(images, index - 1),
                ),
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
    final child = Image.file(
      File(path),
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
          // *Container width & height must be defined to make FittedBox work
          Hero(
            tag: "hero image",
            child: Container(
              clipBehavior: Clip.hardEdge,
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey,
              ),
              child: FittedBox(
                fit: BoxFit.cover,
                child: child,
              ),
            ),
          ),
          deleteIcon
        ],
      ),
    );
  }
}
