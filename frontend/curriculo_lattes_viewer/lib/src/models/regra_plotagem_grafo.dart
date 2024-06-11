import 'package:flutter/material.dart';

class RegraPlotagemGrafo {
  String cor;
  final NP inicio;
  final NP fim;

  RegraPlotagemGrafo(
      {required this.cor, required this.inicio, required this.fim});

  Map<String, dynamic> toMap() {
    return {'cor': cor, 'inicio': inicio.getValue(), 'fim': fim.getValue()};
  }
}

class NP {
  final TextEditingController controller;
  final bool readonly;

  NP({required this.controller, required this.readonly});

  int getValue() {
    try {
      return int.parse(controller.text);
    } catch (e) {
      return -1;
    }
  }
}
