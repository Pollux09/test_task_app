import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task_app/bloc/app_bloc.dart';
import 'package:test_task_app/bloc/app_states.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (AppBloc().checkWasIntrodution()) {
      Navigator.of(context).pushNamed("/catalogScreen");
    }
    return BlocProvider(
      create: (context) => AppBloc(),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: null,
          body: BlocBuilder<AppBloc, AppStates>(
            builder: (context, state) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, const Color(0xFFE4F0E4)],
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/startImage.png'),
                          SizedBox(height: 28.0),
                          Text(
                            "Добро пожаловать",
                            style: TextStyle(
                              color: Color(0xFF343235),
                              fontWeight: FontWeight.bold,
                              fontSize: 36.0,
                            ),
                          ),
                          SizedBox(height: 40.0),
                          Text(
                            "Lorem ipsum dolor sit amet, consecteturadipiscing elit. Proin et",
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 40.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushNamed("/secondIntoductionScreen");
                          },
                          style: ButtonStyle(
                            padding: WidgetStatePropertyAll(
                              EdgeInsets.symmetric(vertical: 16.0),
                            ),
                            backgroundColor: WidgetStatePropertyAll(
                              Color(0xFF427A5B),
                            ),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                          child: Text(
                            "Далее",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
