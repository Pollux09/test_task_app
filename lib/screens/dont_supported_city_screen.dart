import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task_app/bloc/app_bloc.dart';
import 'package:test_task_app/bloc/app_states.dart';
import 'package:url_launcher/url_launcher.dart';

class DontSupportedCityScreen extends StatelessWidget {
  const DontSupportedCityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonIsVisible = ModalRoute.of(context)!.settings.arguments as bool;

    final Uri mapUrl = Uri.parse("https://yandex.ru/maps");

    void openWebMap() {
      launchUrl(mapUrl);
    }

    return BlocProvider(
      create: (context) => AppBloc(),
      child: Builder(
        builder: (context) {
          return BlocBuilder<AppBloc, AppStates>(
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  actions: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pushNamed("/catalogScreen"),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                body: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Color(0xFFE4F0E4)],
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/dontSupportedCityImage.png'),
                              const SizedBox(height: 32),
                              const Text(
                                "Мы не работаем в вашем городе",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        buttonIsVisible
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 46.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: const Color(0xFF427A5B),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          15.0,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16.0,
                                      ),
                                    ),
                                    onPressed: () {
                                      openWebMap();
                                    },
                                    child: const Text(
                                      "Построить маршрут",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Text(''),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
