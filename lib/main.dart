import 'package:flutter/material.dart';

import 'app.dart';
import 'data/database/app_database.dart';
import 'repositories/action_repository.dart';
import 'repositories/vision_repository.dart';

void main() {
  final database = AppDatabase();
  runApp(
    App(
      visionRepository: VisionRepository(database),
      actionRepository: ActionRepository(database),
    ),
  );
}
