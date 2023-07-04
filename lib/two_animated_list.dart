import 'package:flutter/material.dart';

class TwoAnimatedListDemo extends StatefulWidget {
  const TwoAnimatedListDemo({Key? key}) : super(key: key);

  @override
  _TwoAnimatedListDemoState createState() => _TwoAnimatedListDemoState();
}

class _TwoAnimatedListDemoState extends State<TwoAnimatedListDemo> {
  final List<String> _unselected = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
  final List<String> _selected = [];

  final _unselectedListKey = GlobalKey<AnimatedListState>();
  final _selectedListKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Two Animated List Demo'),
      ),
      body: Row(
        children: [
          SizedBox(
            width: 56,
            child: AnimatedList(
              key: _unselectedListKey,
              initialItemCount: _unselected.length,
              itemBuilder: (context, index, animation) {
                return InkWell(
                  onTap: () => _moveItem(
                    fromIndex: index,
                    fromList: _unselected,
                    fromKey: _unselectedListKey,
                    toList: _selected,
                    toKey: _selectedListKey,
                  ),
                  child: Item(text: _unselected[index]),
                );
              },
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 56,
            child: AnimatedList(
              key: _selectedListKey,
              initialItemCount: _selected.length,
              itemBuilder: (context, index, animation) {
                return InkWell(
                  onTap: () => _moveItem(
                    fromIndex: index,
                    fromList: _selected,
                    fromKey: _selectedListKey,
                    toList: _unselected,
                    toKey: _unselectedListKey,
                  ),
                  child: Item(text: _selected[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  int _flyingCount = 0;

  _moveItem({
    required int fromIndex,
    required List fromList,
    required GlobalKey<AnimatedListState> fromKey,
    required List toList,
    required GlobalKey<AnimatedListState> toKey,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    final globalKey = GlobalKey();
    final item = fromList.removeAt(fromIndex);
    fromKey.currentState!.removeItem(
      fromIndex,
          (context, animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: Opacity(
            key: globalKey,
            opacity: 0.0,
            child: Item(text: item),
          ),
        );
      },
      duration: duration,
    );
    _flyingCount++;

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      // Find the starting position of the moving item, which is exactly the
      // gap its leaving behind, in the original list.
      final box1 = globalKey.currentContext!.findRenderObject() as RenderBox;
      final pos1 = box1.localToGlobal(Offset.zero);
      // Find the destination position of the moving item, which is at the
      // end of the destination list.
      final box2 = toKey.currentContext!.findRenderObject() as RenderBox;
      final box2height = box1.size.height * (toList.length + _flyingCount - 1);
      final pos2 = box2.localToGlobal(Offset(0, box2height));
      // Insert an overlay to "fly over" the item between two lists.
      final entry = OverlayEntry(builder: (BuildContext context) {
        return TweenAnimationBuilder(
          tween: Tween<Offset>(begin: pos1, end: pos2),
          duration: duration,
          builder: (_, Offset value, child) {
            return Positioned(
              left: value.dx,
              top: value.dy,
              child: Item(text: item),
            );
          },
        );
      });

      Overlay.of(context)!.insert(entry);
      await Future.delayed(duration);
      entry.remove();
      toList.add(item);
      toKey.currentState!.insertItem(toList.length - 1);
      _flyingCount--;
    });
  }
}

class Item extends StatelessWidget {
  final String text;

  const Item({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: CircleAvatar(
        child: Text(text),
        radius: 24,
      ),
    );
  }
}