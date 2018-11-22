#!/usr/bin/env dart
import 'dart:io';

import 'package:args/args.dart';
import 'package:tekartik_pub/bin/src/pubbin_utils.dart';
import 'package:tekartik_pub/io.dart';

const String argHelpFlag = 'help';
const String argFixFlag = 'fix';
const String argOneByOneFlag = 'one';
const String argOfflineFlag = "offline";
const String argPackagesDir = "packages-dir";
const String argForceRecursiveFlag = "force-recursive";

class PubGetOptions {
  bool forceRecursive;
  bool oneByOne;
  bool offline;
  bool packagesDir;
}

// chmod +x ...
main(List<String> arguments) async {
  ArgParser parser = ArgParser(allowTrailingOptions: true);
  parser.addFlag(argHelpFlag, abbr: 'h', help: 'Usage help', negatable: false);
  parser.addFlag(argOneByOneFlag,
      abbr: 'o', help: 'One at a time', defaultsTo: Platform.isWindows);
  parser.addFlag(argOfflineFlag, help: 'offline get', negatable: false);
  parser.addFlag(argForceRecursiveFlag,
      abbr: 'f',
      help: 'Force going recursive even in dart project',
      negatable: false);
  parser.addFlag(argPackagesDir,
      help: 'generates packages dir', negatable: false);

  ArgResults argResults = parser.parse(arguments);

  bool help = argResults[argHelpFlag] as bool;
  if (help) {
    print(parser.usage);
    return;
  }

  bool oneByOne = argResults[argOneByOneFlag];
  bool offline = argResults[argOfflineFlag];
  bool packagesDir = argResults[argPackagesDir];
  bool forceRecursive = argResults[argForceRecursiveFlag];

  List<String> rest = argResults.rest;
  // if no default to current folder
  if (rest.length == 0) {
    rest = ['.'];
  }

  await pubGet(
      rest,
      PubGetOptions()
        ..oneByOne = oneByOne
        ..forceRecursive = forceRecursive
        ..packagesDir = packagesDir
        ..offline = offline);
}

pubGet(List<String> directories, PubGetOptions options) async {
  List<String> pkgPaths = [];
  // Also Handle recursive projects
  await recursivePubPath(directories, forceRecursive: options.forceRecursive)
      .listen((String dir) {
    pkgPaths.add(dir);
  }).asFuture();

  for (String dir in pkgPaths) {
    PubPackage pkg = PubPackage(dir);
    ProcessCmd cmd;
    if (await isFlutterPackageRoot(dir)) {
      if (!isFlutterSupported) {
        continue;
      }
      cmd = FlutterCmd(['packages', 'get'])..workingDirectory = dir;
    } else {
      cmd = pkg.pubCmd(pubGetArgs(
          offline: options.offline, packagesDir: options.packagesDir));
    }
    var future = runCmd(cmd, oneByOne: options.oneByOne);
    if (options.oneByOne) {
      await future;
    }
  }
}
