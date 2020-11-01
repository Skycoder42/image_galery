import 'dart:io';

import 'package:args/args.dart';
import 'package:piwigo_sync/src/sync_manager.dart';

Future<void> main(List<String> arguments) async {
  final parser = _buildParser();
  try {
    final args = parser.parse(arguments);
    if (args["help"] as bool) {
      stdout.writeln(parser.usage);
      return;
    }

    final syncManager = SyncManager(
      host: args["host"] as String,
      port: int.parse(args["port"] as String),
      username: args["username"] as String,
      password: args["password"] as String,
      interval: Duration(
        minutes: int.parse(args["interval"] as String),
      ),
    );

    return syncManager();
  } on FormatException {
    stderr.writeln(parser.usage);
    exitCode = 1;
  }
}

ArgParser _buildParser() => ArgParser()
  ..addFlag(
    "help",
    abbr: "h",
    help: "Show this help.",
  )
  ..addSeparator("Host-Connection")
  ..addOption(
    "host",
    abbr: "H",
    defaultsTo: "localhost",
    valueHelp: "hostname",
    help: "The name of the host that host the piwigo instance to be accessed.",
  )
  ..addOption(
    "port",
    abbr: "P",
    defaultsTo: "80",
    valueHelp: "port",
    help:
        "The port that must be used to connect to the piwigo instance on the host.",
  )
  ..addOption(
    "username",
    abbr: "u",
    valueHelp: "username",
    help: "The username of the admin account.",
  )
  ..addOption(
    "password",
    abbr: "p",
    valueHelp: "password",
    help: "The password of the admin account.",
  )
  ..addSeparator("Operation")
  ..addOption(
    "interval",
    abbr: "i",
    valueHelp: "minutes",
    help: "The synchronization interval, in minutes.",
  );
