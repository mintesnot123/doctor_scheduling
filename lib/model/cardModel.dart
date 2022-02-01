import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class CardModel {
  String doctor;
  String label;
  int cardBackground;
  var cardIcon;

  CardModel(this.doctor, this.label, this.cardBackground, this.cardIcon);
}

List<CardModel> cards = [
  new CardModel("CONSULTANT PHYSICIAN", "Physician", 0xFFec407a, FlutterIcons.heart_ant),
  new CardModel("ORTHOPEDICIAN", "Orthopedician", 0xFF5c6bc0, FlutterIcons.tooth_mco),
  new CardModel("NEUROLOGIST", "Neurologist", 0xFFfbc02d, TablerIcons.eye),
  new CardModel("GENERAL SURGEON", "General Sur..", 0xFF1565C0, Icons.wheelchair_pickup_sharp),
  new CardModel("URO SURGEON", "Uro Surgeon", 0xFF2E7D32, FlutterIcons.baby_faw5s),
  new CardModel("CHEST SPECIALIST", "Chest Spec...", 0xFFfbc02d, TablerIcons.eye),
];
