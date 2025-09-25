import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boardview/board_item.dart';
import 'package:flutter_boardview/board_list.dart';
import 'package:flutter_boardview/boardview.dart';
import 'package:flutter_boardview/boardview_controller.dart';

import '/core/extension/context_ext.dart';
import '../../../../core/bloc/common.dart';
import '../../../indicator/bloc/indicator_bloc.dart';
import '../../../indicator/data/models/indicator_model.dart';
import '../../data/models/board_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  BoardViewController boardViewController = BoardViewController();
  ValueNotifier<Map<int, int>> sortNotifier = ValueNotifier({});

  late final IndicatorBloc indicatorBloc;

  @override
  void initState() {
    super.initState();
    indicatorBloc = context.read<IndicatorBloc>();
    indicatorBloc.add(IndicatorGetMoEvent());
  }

  @override
  void dispose() {
    sortNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IndicatorBloc, IndicatorState>(
      builder: (context, state) {
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
                    enabled: state.status == BlocStatus.success,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Поиск...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      indicatorBloc.add(
                        IndicatorSearchMoEvent(value.isNotEmpty ? value : null),
                      );
                    },
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
                color: context.colors.scrim,
                child: state.status == BlocStatus.success
                    ? ValueListenableBuilder(
                        valueListenable: sortNotifier,
                        builder: (context, value, child) {
                          return BoardView(
                            boardViewController: boardViewController,
                            lists: state.items
                                .map(
                                  (board) => _createBoard(
                                    board,
                                    value[board.id] ?? 1,
                                    state.search,
                                  ),
                                )
                                .toList(),
                          );
                        },
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
        );
      },
    );
  }

  // if (state is IndicatorLoaded) {
  // return ValueListenableBuilder(
  // valueListenable: sortNotifier,
  // builder: (context, value, child) {
  // return BoardView(
  // boardViewController: boardViewController,
  // lists: state.boards
  //     .map(
  // (board) =>
  // _createBoard(board, value[board.id] ?? 1),
  // )
  //     .toList(),
  // );
  // },
  // );
  // }
  // return const Center(child: CircularProgressIndicator());
  BoardList _createBoard(
    BoardModel<IndicatorModel> board,
    int sort,
    String? search,
  ) {
    final sortedItems = board.items
        .sorted((a, b) {
          return sort * (a.order > b.order ? 1 : -1);
        })
        .where(
          (item) => search != null
              ? item.name.toLowerCase().contains(search.toLowerCase())
              : true,
        );

    void onChangeSort() {
      sortNotifier.value = {...sortNotifier.value, board.id: sort * -1};
    }

    return BoardList(
      key: ValueKey(sort),
      draggable: false,
      backgroundColor: context.colors.surface,
      // onStartDragList: (listIndex) {
      //   debugPrint("Start dragging list: $listIndex");
      // },
      // onDropList: (listIndex, oldListIndex) {
      //   debugPrint("Dropped list: $listIndex, old: $oldListIndex");
      // },
      header: [
        Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            board.id.toString(),
            style: TextStyle(fontSize: 20, color: context.colors.primary),
          ),
        ),
        IconButton(
          onPressed: onChangeSort,
          icon: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..scale(1.0, sort * -1.0),
            child: const Icon(Icons.sort),
          ),
        ),
      ],

      items: sortedItems
          .map(
            (item) => BoardItem(
              // onStartDragItem: (listIndex, itemIndex, state) {
              //   debugPrint("Start dragging: $itemIndex from list $listIndex");
              // },
              // onDropItem:
              //     (listIndex, itemIndex, oldListIndex, oldItemIndex, state) {
              //       debugPrint("Dropped item $itemIndex in list $listIndex");
              //     },
              item: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(item.name),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
