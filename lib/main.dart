import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/api/dio_client.dart';
import 'features/indicator/bloc/indicator_bloc.dart';
import 'features/indicator/data/repository/indicator_repository.dart';
import 'features/main/presentation/pages/main_page.dart';
import 'shared/theme/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final DioClient dioClient = DioClient();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => IndicatorBloc(IndicatorRepository(dioClient)),
        ),
      ],
      child: MaterialApp(
        title: 'Like A Trello',
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: const MainPage(),
      ),
    );
  }
}
