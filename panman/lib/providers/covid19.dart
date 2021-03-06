import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:panman/models/hospital.dart';
import 'package:panman/models/medicalSupply.dart';

import '../models/patient.dart';
import '../models/c19data.dart';

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class Covid19 with ChangeNotifier {
  List<c19> referenceCovid19SeverityLevelsList = [];

  Future getReferenceCovid19SevererityLevels() async {
    referenceCovid19SeverityLevelsList.clear();
    var referenceCovid19SeverityLevelsCollection =
        Firestore.instance.collection('covid19severitylevels');

    var newList = await referenceCovid19SeverityLevelsCollection.getDocuments();

    newList.documents.forEach((element) {
      print(element['fullText']);
      referenceCovid19SeverityLevelsList.add(c19(
        isSymptomatic: element['symptomatic'],
        abbrv: element['abbreviation'],
        fullText: element['fullText'],
        info: element['info'],
        stateColor: HexColor(element['stateColorInHex']),
        index: element['index'],
      ));
    });

    notifyListeners();
  }
}
