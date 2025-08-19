import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

/// Initializes global logging configuration
void setupLogging() {
  Logger.root.level = Level.ALL;

  Logger.root.onRecord.listen((record) {
    final emoji = _getEmojiForLevel(record.level);

    final logMessage = '''
$emoji ${record.level.name.toUpperCase()} | ${record.time.toIso8601String()}
[${record.loggerName}]
→ ${record.message}
${record.error != null ? '❌ ERROR: ${record.error}' : ''}
${record.stackTrace != null ? '📌 STACKTRACE:\n${record.stackTrace}' : ''}
''';

    debugPrint(logMessage.trim());
  });
}

/// Returns a visual emoji/icon based on log level
String _getEmojiForLevel(Level level) {
  if (level == Level.SEVERE) return '🔥';
  if (level == Level.WARNING) return '⚠️';
  if (level == Level.INFO) return 'ℹ️';
  if (level == Level.CONFIG) return '🔧';
  if (level == Level.FINE || level == Level.FINER || level == Level.FINEST) return '🐛';
  return '🔍';
}

/// Shortcut to create a named logger
Logger getLogger(String name) => Logger(name);
