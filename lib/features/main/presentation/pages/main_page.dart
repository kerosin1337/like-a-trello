import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boardview/board_item.dart';
import 'package:flutter_boardview/board_list.dart';
import 'package:flutter_boardview/boardview.dart';
import 'package:flutter_boardview/boardview_controller.dart';

import '/core/bloc/common.dart';
import '/core/extension/context_ext.dart';
import '/features/indicator/bloc/indicator_bloc.dart';
import '/features/indicator/data/models/indicator_model.dart';
import '/features/main/data/models/board_model.dart';
import '/shared/components/search_field.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  BoardViewController boardViewController = BoardViewController();

  late final IndicatorBloc indicatorBloc;

  String? get search => indicatorBloc.state.search;

  List<BoardModel<IndicatorModel>> get allBoard => indicatorBloc.state.items
      .map(
        (ind) => ind.copyWith(
          items: ind.items
              .where(
                (item) => search != null
                    ? item.name.toLowerCase().contains(search!.toLowerCase())
                    : true,
              )
              .toList(),
        ),
      )
      .toList();

  bool get isInit => indicatorBloc.state.status == BlocStatus.success;

  @override
  void initState() {
    super.initState();
    indicatorBloc = context.read<IndicatorBloc>();
    indicatorBloc.add(IndicatorGetMoEvent());
  }

  void handleSearchChanged(String value) {
    indicatorBloc.add(IndicatorSearchMoEvent(value.isNotEmpty ? value : null));
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
                  child: SearchField(
                    enabled: isInit,
                    onChanged: handleSearchChanged,
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
                child: isInit
                    ? BoardView(
                        boardViewController: boardViewController,
                        lists: state.items
                            .map((board) => _createBoard(board, state.search))
                            .toList(),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
        );
      },
    );
  }

  BoardList _createBoard(BoardModel<IndicatorModel> board, String? search) {
    final filteredItems = board.items
        .where(
          (item) => search != null
              ? item.name.toLowerCase().contains(search.toLowerCase())
              : true,
        )
        .toList();

    return BoardList(
      key: ValueKey(board.id),
      draggable: false,
      backgroundColor: context.colors.surface,
      header: [
        Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            board.id.toString(),
            style: TextStyle(fontSize: 20, color: context.colors.primary),
          ),
        ),
      ],

      items: filteredItems
          .map(
            (indicator) => BoardItem(
              key: ValueKey(indicator.indicatorToMoId),
              onDropItem:
                  (listIndex, itemIndex, oldListIndex, oldItemIndex, state) {
                    if (listIndex != null &&
                        oldListIndex != null &&
                        itemIndex != null) {
                      final parentId = listIndex == oldListIndex
                          ? indicator.parentId
                          : allBoard[listIndex].id;
                      final order =
                          allBoard[listIndex].items
                              .firstWhereIndexedOrNull(
                                (index, _) => index == itemIndex,
                              )
                              ?.order ??
                          (itemIndex + 1);

                      indicatorBloc.add(
                        IndicatorUpdateMoEvent(
                          indicatorId: indicator.indicatorToMoId,
                          parentId: parentId,
                          order: order,
                        ),
                      );
                    }
                  },
              item: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('${indicator.order} - ${indicator.name}'),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
