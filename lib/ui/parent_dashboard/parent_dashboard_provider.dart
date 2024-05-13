import 'package:flutter/material.dart';
import 'package:nursery/model/baby.dart';

class ParentDashboardProvider extends ChangeNotifier {

  List<Baby>? babies;
  
  bool _isLoadingBabies = false;

  bool get isLoadingBabies => _isLoadingBabies;
  
  ParentDashboardProvider();
}