import 'package:flutter/material.dart';

class RegraPlotagemGrafo {
  String cor;
  final NP inicio;
  final NP fim;

  RegraPlotagemGrafo(
      {required this.cor, required this.inicio, required this.fim});
}

class NP {
  final TextEditingController controller;
  final bool readonly;

  NP({required this.controller, required this.readonly});

  int getValue() {
    return int.parse(controller.text);
  }
}
