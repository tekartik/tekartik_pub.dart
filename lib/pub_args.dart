library tekartik_io_tools.pub_args;

// 2016-09-25 Use this

enum RunTestReporter { COMPACT, EXPANDED, JSON }

enum BuildMode { DEBUG, RELEASE }
enum BuildFormat { TEXT, JSON }

final Map<BuildMode, String> _buildModeValueMap = new Map.fromIterables(
    [BuildMode.DEBUG, BuildMode.RELEASE], ["debug", "release"]);

final Map<BuildFormat, String> _buildFormatValueMap = new Map.fromIterables(
    [BuildFormat.TEXT, BuildFormat.JSON], ["text", "json"]);

final Map<RunTestReporter, String> _runTestReporterValueMap =
    new Map.fromIterables([
  RunTestReporter.COMPACT,
  RunTestReporter.EXPANDED,
  RunTestReporter.JSON
], [
  "compact",
  "expanded",
  "json"
]);

Map<String, RunTestReporter> _runTestReporterEnumMap;

RunTestReporter runTestReporterFromString(String reporter) {
  if (_runTestReporterEnumMap == null) {
    _runTestReporterEnumMap = {};
    _runTestReporterValueMap
        .forEach((RunTestReporter runTestReporter, String reporter) {
      _runTestReporterEnumMap[reporter] = runTestReporter;
    });
  }
  return _runTestReporterEnumMap[reporter];
}

Iterable<String> pubArgs(
    {Iterable<String> args, bool version, bool help, bool verbose}) {
  List<String> pubArgs = [];
  // --version          Print pub version.

  if (version == true) {
    pubArgs.add('--version');
  }
  // --help             Print this usage information.
  if (help == true) {
    pubArgs.add('--help');
  }
  // --verbose          Shortcut for "--verbosity=all".
  if (verbose == true) {
    pubArgs.add('--verbose');
  }
  if (args != null) {
    pubArgs.addAll(args);
  }

  return pubArgs;
}

/// list of argument for pubCmd
Iterable<String> pubBuildArgs(
    {Iterable<String> directories,
    Iterable<String> args,
    BuildMode mode,
    BuildFormat format,
    String output}) {
  List<String> buildArgs = ['build'];
  // --mode      Mode to run transformers in.
  //    (defaults to "release")
  if (mode != null) {
    buildArgs.addAll(['--mode', _buildModeValueMap[mode]]);
  }
  // --format    How output should be displayed.
  // [text (default), json]
  if (format != null) {
    buildArgs.addAll(['--format', _buildFormatValueMap[format]]);
  }
  // -o, --output    Directory to write build outputs to.
  // (defaults to "build")
  if (output != null) {
    buildArgs.addAll(['--output', output]);
  }
  if (directories != null) {
    buildArgs.addAll(directories);
  }
  if (args != null) {
    buildArgs.addAll(args);
  }

  return buildArgs;
}

Iterable<String> pubGetArgs({bool offline, bool dryRun, bool packagesDir}) {
  List<String> args = ['get'];
  if (offline == true) {
    args.add('--offline');
  }
  if (dryRun == true) {
    args.add('--dry-run');
  }
  if (packagesDir == true) {
    args.add('--packages-dir');
  }
  return args;
}

Iterable<String> pubUpgradeArgs({bool offline, bool dryRun, bool packagesDir}) {
  List<String> args = ['upgrade'];
  if (offline == true) {
    args.add('--offline');
  }
  if (dryRun == true) {
    args.add('--dry-run');
  }
  if (packagesDir == true) {
    args.add('--packages-dir');
  }
  return args;
}

const pubDepsStyleCompact = "compact";
const pubDepsStyleTree = "tree";
const pubDepsStyleList = "list";

Iterable<String> pubDepsArgs({Iterable<String> args, String style}) {
  List<String> depsArgs = ['deps'];
  if (style != null) {
    depsArgs.addAll(['--style', style]);
  }
  if (args != null) {
    depsArgs.addAll(args);
  }
  return (depsArgs);
}

const pubRunTestReporterJson = "json";
const pubRunTestReporterExpanded = "expanded";
const pubRunTestReporterCompact = "compact";

List<String> pubRunTestReporters = [
  pubRunTestReporterCompact,
  pubRunTestReporterExpanded,
  pubRunTestReporterJson
];

class TestRunnerArgs {
  TestRunnerArgs(
      {this.args,
      this.reporter,
      this.color,
      this.concurrency,
      this.platforms,
      this.name});

  final Iterable<String> args;
  final RunTestReporter reporter;
  final bool color;
  final int concurrency;
  final List<String> platforms;
  final String name;
}

Iterable<String> pubRunTestRunnerArgs([TestRunnerArgs args]) {
  List<String> testArgs = [];
  if (args?.reporter != null) {
    testArgs.addAll(['-r', _runTestReporterValueMap[args.reporter]]);
  }
  if (args?.concurrency != null) {
    testArgs.addAll(['-j', args.concurrency.toString()]);
  }
  if (args?.name != null) {
    testArgs.addAll(['-n', args.name]);
  }
  if (args?.color != null) {
    if (args.color) {
      testArgs.add('--color');
    } else {
      testArgs.add('--no-color');
    }
  }
  if (args?.platforms != null) {
    for (String platform in args.platforms) {
      testArgs.addAll(['-p', platform]);
    }
  }
  if (args?.args != null) {
    testArgs.addAll(args.args);
  }
  return (testArgs);
}

/// list of argument for pubCmd
Iterable<String> pubRunTestArgs(
    {Iterable<String> args,
    RunTestReporter reporter,
    bool color,
    int concurrency,
    List<String> platforms,
    String name}) {
  List<String> testArgs = ['run', 'test'];
  testArgs.addAll(pubRunTestRunnerArgs(new TestRunnerArgs(
      args: args,
      reporter: reporter,
      color: color,
      concurrency: concurrency,
      platforms: platforms,
      name: name)));
  return (testArgs);
}

/// list of argument for pubCmd
Iterable<String> pubRunArgs(Iterable<String> args) {
  List<String> runArgs = ['run'];
  if (args != null) {
    runArgs.addAll(args);
  }
  return (runArgs);
}

Iterable<String> dartdocArgs(
    {Iterable<String> args,
    bool version,
    bool help,
    String input,
    String output}) {
  List<String> pubArgs = [];
  // --version          Print pub version.

  if (version == true) {
    pubArgs.add('--version');
  }
  // --help             Print this usage information.
  if (help == true) {
    pubArgs.add('--help');
  }
  // --verbose          Shortcut for "--verbosity=all".
  if (input != null) {
    pubArgs..add('--input')..add(input);
  }
  if (output != null) {
    pubArgs..add('--output')..add(output);
  }
  if (args != null) {
    pubArgs.addAll(args);
  }

  return pubArgs;
}
