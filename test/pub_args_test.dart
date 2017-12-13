@TestOn("vm")
library tekartik_pub.test.pub_args_test;

import 'dart:mirrors';
import 'package:path/path.dart';
import 'package:dev_test/test.dart';
import 'package:tekartik_pub/pub_args.dart';

class _TestUtils {
  static final String scriptPath =
      (reflectClass(_TestUtils).owner as LibraryMirror).uri.toFilePath();
}

String get testScriptPath => _TestUtils.scriptPath;
String get packageRoot => dirname(dirname(testScriptPath));

void main() => defineTests();

void defineTests() {
  //useVMConfiguration();
  group('pub_args', () {
    test('pubArgs', () {
      expect(pubArgs(), []);
      expect(pubArgs(version: true), ['--version']);
      expect(pubArgs(help: true), ['--help']);
      expect(pubArgs(verbose: true), ['--verbose']);
    });

    test('pubBuildArgs', () {
      expect(pubBuildArgs(), ['build']);
      expect(pubBuildArgs(output: 'out'), ['build', '--output', 'out']);
      expect(pubBuildArgs(mode: BuildMode.DEBUG), ['build', '--mode', 'debug']);
      expect(pubBuildArgs(mode: BuildMode.RELEASE),
          ['build', '--mode', 'release']);
      expect(pubBuildArgs(format: BuildFormat.JSON),
          ['build', '--format', 'json']);
      expect(pubBuildArgs(format: BuildFormat.TEXT),
          ['build', '--format', 'text']);
      expect(pubBuildArgs(args: ['web']), ['build', 'web']);
      expect(pubBuildArgs(directories: ['web']), ['build', 'web']);
    });

    test('pubRunTestArgs', () {
      expect(pubRunTestArgs(), ['run', "test"]);
      expect(
          pubRunTestArgs(
              args: ['arg1', 'arg2'],
              platforms: ['platform1', 'platform2'],
              reporter: RunTestReporter.JSON,
              color: true,
              concurrency: 2,
              name: 'name'),
          [
            'run',
            'test',
            '-r',
            'json',
            '-j',
            '2',
            '-n',
            'name',
            '--color',
            '-p',
            'platform1',
            '-p',
            'platform2',
            'arg1',
            'arg2'
          ]);
    });

    test('pubRunTestRunnerArgs', () {
      expect(pubRunTestRunnerArgs(), []);
      expect(
          pubRunTestRunnerArgs(new TestRunnerArgs(
              args: ['arg1', 'arg2'],
              platforms: ['platform1', 'platform2'],
              reporter: RunTestReporter.COMPACT,
              color: true,
              concurrency: 2,
              name: 'name')),
          [
            '-r',
            'compact',
            '-j',
            '2',
            '-n',
            'name',
            '--color',
            '-p',
            'platform1',
            '-p',
            'platform2',
            'arg1',
            'arg2'
          ]);
    });

    test('pubGetArgs', () {
      expect(pubGetArgs(), ['get']);
    });

    test('pubUpgradeArgs', () {
      expect(pubUpgradeArgs(), ['upgrade']);
    });
  });
}
