import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task_app/bloc/app_bloc.dart';
import 'package:test_task_app/bloc/app_events.dart';
import 'package:test_task_app/bloc/app_states.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key});

  final List categories = [
    "Семена",
    'Растения',
    "Грунт для растения",
    "Для деревьев и саженцев",
    "Торф фасованный",
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc()..add(LoadCategoriesList()),
      child: Builder(
        builder: (context) {
          return BlocBuilder<AppBloc, AppStates>(
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  leading: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                  ),
                  title: Text("Категория"),
                ),
                body: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Color(0xFFE4F0E4)],
                    ),
                  ),
                  child: state is CategoriesListState
                      ? ListView.builder(
                          itemCount: state.categoriesList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.all(16),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushNamed('/catalogScreen', arguments: state.categoriesList[index].id);
                              },
                              child: Row(
                                children: [
                                  SizedBox(width: 12.0),
                                  Text(
                                    state.categoriesList[index]['name'],
                                    style: TextStyle(
                                      color: const Color(0xFF797474),
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : CircularProgressIndicator(color: Colors.black),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
