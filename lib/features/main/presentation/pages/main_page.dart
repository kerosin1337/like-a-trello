import 'package:flutter/material.dart';
import 'package:flutter_boardview/board_item.dart';
import 'package:flutter_boardview/board_list.dart';
import 'package:flutter_boardview/boardview.dart';
import 'package:flutter_boardview/boardview_controller.dart';

import '/core/extension/context_ext.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  BoardViewController boardViewController = BoardViewController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text("Like A Trello"),
            const Spacer(),
            Container(
              width: 300,
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (value) {},
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ClipRSuperellipse(
          borderRadius: BorderRadius.circular(16),
          child: ColoredBox(
            color: context.colors.surface,
            child: BoardView(
              boardViewController: boardViewController,
              lists: [
                _createBoard("To Do", Colors.red),
                _createBoard("In Progress", Colors.blue),
                _createBoard("Done", Colors.green),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoardList _createBoard(String title, Color color) {
    final colorScheme = ColorScheme.fromSeed(seedColor: color);
    return BoardList(
      backgroundColor: colorScheme.primary,
      onStartDragList: (listIndex) {
        debugPrint("Start dragging list: $listIndex");
      },
      onDropList: (listIndex, oldListIndex) {
        debugPrint("Dropped list: $listIndex, old: $oldListIndex");
      },
      header: [
        Container(
          padding: const EdgeInsets.all(8),
          child: Text(title, style: TextStyle(fontSize: 20, color: color)),
        ),
      ],

      items: List.generate(3, (index) {
        return BoardItem(
          onStartDragItem: (listIndex, itemIndex, state) {
            debugPrint("Start dragging: $itemIndex from list $listIndex");
          },
          onDropItem:
              (listIndex, itemIndex, oldListIndex, oldItemIndex, state) {
                debugPrint("Dropped item $itemIndex in list $listIndex");
              },
          item: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text("Task $index"),
            ),
          ),
        );
      }),
    );
  }
}
