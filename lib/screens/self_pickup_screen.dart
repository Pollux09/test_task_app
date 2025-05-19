import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:test_task_app/bloc/app_bloc.dart';
import 'package:test_task_app/bloc/app_events.dart';
import 'package:test_task_app/bloc/app_states.dart';

class SelfPickupScreen extends StatefulWidget {
  const SelfPickupScreen({super.key});

  @override
  State<SelfPickupScreen> createState() => _SelfPickupScreenState();
}

class _SelfPickupScreenState extends State<SelfPickupScreen> {
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();

    phone.addListener(validateForm);
  }

  void validateForm() {
    final isPhoneValid = phone.text.trim().length == 12;

    setState(() {
      isFormValid = isPhoneValid;
    });
  }

  @override
  void dispose() {
    phone.dispose();
    comment.dispose();
    super.dispose();
  }

  int currentIndex = 0;

  TextEditingController phone = TextEditingController(text: "+7");
  TextEditingController comment = TextEditingController();

  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final List<Map> data =
        ModalRoute.of(context)!.settings.arguments as List<Map>;

    return BlocProvider(
      create: (_) => AppBloc()..add(LoadSelfPickUpScreen()),
      child: BlocBuilder<AppBloc, AppStates>(
        builder: (context, state) => Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              padding: const EdgeInsets.only(left: 8),
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text("Самовывоз"),
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Color(0xFFE4F0E4)],
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: state is LoadedSelfPickUpScreen
                ? Column(
                    children: [
                      ...List.generate(state.locations.length, (index) {
                        return Row(
                          children: [
                            Radio<int>(
                              value: index,
                              groupValue: currentIndex,
                              activeColor: Colors.black,
                              onChanged: (int? value) {
                                if (value == null) return;
                                setState(() {
                                  currentIndex = value;
                                  _mapController.move(
                                    LatLng(
                                      state
                                          .locations[currentIndex]['location']
                                          .latitude,
                                      state
                                          .locations[currentIndex]['location']
                                          .longitude,
                                    ),
                                    17,
                                  );
                                });
                              },
                            ),
                            Expanded(
                              child: Text(
                                state.locations[index]['location_title'],
                              ),
                            ),
                          ],
                        );
                      }),
                      const SizedBox(height: 24),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(
                                255,
                                92,
                                92,
                                92,
                              ).withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 12,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: SizedBox(
                          width: double.infinity,
                          height: 200,
                          child: FlutterMap(
                            mapController: _mapController,
                            options: MapOptions(
                              initialCenter: LatLng(
                                state
                                    .locations[currentIndex]['location']
                                    .latitude,
                                state
                                    .locations[currentIndex]['location']
                                    .longitude,
                              ),
                              initialZoom: 17,
                              interactionOptions: const InteractionOptions(
                                flags:
                                    InteractiveFlag.drag |
                                    InteractiveFlag.pinchZoom |
                                    InteractiveFlag.doubleTapZoom |
                                    InteractiveFlag.scrollWheelZoom,
                              ),
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.example.app',
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    child: Icon(
                                      Icons.location_pin,
                                      size: 50,
                                      color: Colors.red,
                                    ),
                                    point: LatLng(
                                      state
                                          .locations[currentIndex]['location']
                                          .latitude,
                                      state
                                          .locations[currentIndex]['location']
                                          .longitude,
                                    ),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Укажите контактный номер *'),
                          SizedBox(height: 4),
                          TextField(
                            controller: phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9+]'),
                              ),
                            ],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              contentPadding: EdgeInsetsGeometry.all(12),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                            ),
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Комментарий'),
                          SizedBox(height: 4),
                          TextField(
                            controller: comment,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              contentPadding: EdgeInsetsGeometry.all(12),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                            ),
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 42.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: isFormValid
                                      ? () {
                                          context.read<AppBloc>().add(
                                            CreateOrder(
                                              productsList: data,
                                              phone: phone.text,
                                              comment: comment.text,
                                              adress: state
                                                  .locations[currentIndex]['location_title'],
                                            ),
                                          );
                                          if (state is OrderCreatedSuccess) {
                                            Navigator.of(context).pushNamed(
                                              "/successScreen",
                                              arguments: true,
                                            );
                                          }
                                        }
                                      : null,
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    backgroundColor: isFormValid
                                        ? const Color(0xFF427A5B)
                                        : Colors.grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                  child: Text(
                                    "Оформить самовывоз",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Center(child: CircularProgressIndicator(color: Colors.black)),
          ),
        ),
      ),
    );
  }
}
