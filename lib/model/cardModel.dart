import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class CardModel {
  String doctor;
  int cardBackground;
  var cardIcon;

  CardModel(this.doctor, this.cardBackground, this.cardIcon);
}

List<CardModel> cards = [
  new CardModel("CONSULTANT PHYSICIAN", 0xFFec407a, FlutterIcons.heart_ant),
  new CardModel("ORTHOPEDICIAN", 0xFF5c6bc0, FlutterIcons.tooth_mco),
  new CardModel("NEUROLOGIST", 0xFFfbc02d, TablerIcons.eye),
  new CardModel("GENERAL SURGEON", 0xFF1565C0, Icons.wheelchair_pickup_sharp),
  new CardModel("URO SURGEON", 0xFF2E7D32, FlutterIcons.baby_faw5s),
  new CardModel("CHEST SPECIALIST", 0xFFfbc02d, TablerIcons.eye),
];
