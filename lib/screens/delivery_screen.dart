import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task_app/bloc/app_bloc.dart';
import 'package:test_task_app/bloc/app_events.dart';
import 'package:test_task_app/bloc/app_states.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  TextEditingController adress = TextEditingController();
  TextEditingController phone = TextEditingController(text: "+7");
  TextEditingController comment = TextEditingController();

  bool isFormValid = false;

  @override
  void initState() {
    super.initState();

    adress.addListener(validateForm);
    phone.addListener(validateForm);
  }

  void validateForm() {
    final isAddressValid = adress.text.trim().isNotEmpty;
    final isPhoneValid = phone.text.trim().length == 12;

    setState(() {
      isFormValid = isAddressValid && isPhoneValid;
    });
  }

  @override
  void dispose() {
    adress.dispose();
    phone.dispose();
    comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map> data =
        ModalRoute.of(context)!.settings.arguments as List<Map>;

    return BlocProvider(
      create: (context) => AppBloc(),
      child: Builder(
        builder: (context) {
          return BlocListener<AppBloc, AppStates>(
            listener: (context, state) {
              if (state is OrderCreatedSuccess) {
                Navigator.of(
                  context,
                ).pushNamed("/successScreen", arguments: false);
              } else if (state is DontSupportedCity) {
                Navigator.of(
                  context,
                ).pushNamed("/dontSupportedCity", arguments: false);
              }
            },
            child: Scaffold(
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
                title: Text("Доставка"),
              ),
              body: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, const Color(0xFFE4F0E4)],
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 32),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Укажите адрес доставки *'),
                        SizedBox(height: 4),
                        TextField(
                          controller: adress,
                          decoration: InputDecoration(
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
                    SizedBox(height: 12),
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
                    SizedBox(height: 12),
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
                                            adress: adress.text,
                                          ),
                                        );
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
                                  "Заказать",
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
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
