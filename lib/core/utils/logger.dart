import 'package:flutter/material.dart';
import 'package:logging/logging.dart';


// Sets global log level 
// Defines how logs are printed
void setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint(
      '${record.level.name}  '
      '${record.time.toIso8601String()}  '
      '[${record.loggerName}]  '
      '${record.message}'
      '${record.error != null ? '  ERROR: ${record.error}' : ''}'
      '${record.stackTrace != null ? '\n${record.stackTrace}' : ''}',
    );
  });
}

Logger getLogger(String name) => Logger(name);