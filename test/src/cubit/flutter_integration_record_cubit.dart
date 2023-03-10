import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:clock/clock.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_integration_record/src/cubit/flutter_integration_record_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  late FlutterIntegrationRecordCubit flutterIntegrationRecordCubit;
  late File file;

  setUp(() {
    flutterIntegrationRecordCubit = FlutterIntegrationRecordCubit(
      nomTest: 'test',
      clock: Clock.fixed(
        DateTime(2023, 01, 22, 16, 18, 56),
      ),
      widgetChild: Container(),
    );
    file = File('assets/images/test.jpg');
    flutterIntegrationRecordCubit.emit(
      FlutterIntegrationRecordState(
        stringBuffer: StringBuffer(
          'await tester.pumpWidget(const App());\n'
          'await tester.tapAt(const Offset(10.0, 10.0));\n'
          'await tester.pumpAndSettle();\n'
          '});}\n\n',
        ),
        nomTest: 'nomTest',
        timeLastAction: 1674389934,
        firstAction: false,
      ),
    );
  });

  test('timelastAction never wait', () {
    flutterIntegrationRecordCubit = FlutterIntegrationRecordCubit(
      nomTest: 'test',
      widgetChild: Container(),
      clock: Clock.fixed(
        DateTime(2023, 01, 22, 16, 18, 56),
      ),
    )..emit(
        FlutterIntegrationRecordState(
          stringBuffer: StringBuffer(),
          nomTest: 'nomTest',
          timeLastAction: 1674389935,
        ),
      );
    final duration = flutterIntegrationRecordCubit.timelastAction();
    expect(
      duration,
      '',
    );
  });
  test('timelastAction wait 4 seconds', () {
    flutterIntegrationRecordCubit = FlutterIntegrationRecordCubit(
      nomTest: 'test',
      widgetChild: Container(),
      clock: Clock.fixed(
        DateTime(2023, 01, 22, 16, 18, 58),
      ),
    )..emit(
        FlutterIntegrationRecordState(
          stringBuffer: StringBuffer(),
          nomTest: 'nomTest',
          timeLastAction: 1674389934,
        ),
      );
    final duration = flutterIntegrationRecordCubit.timelastAction();
    expect(
      duration,
      'const Duration(seconds: 4)',
    );
  });

  test('Tap on Offset(10,10)', () {
    flutterIntegrationRecordCubit
      ..emit(
        FlutterIntegrationRecordState(
          stringBuffer: StringBuffer(),
          nomTest: 'nomTest',
          timeLastAction: 1674389935,
          firstAction: false,
        ),
      )
      ..onTapDown(
        details: DragDownDetails(
          globalPosition: const Offset(10, 10),
        ),
      );
    expect(
      flutterIntegrationRecordCubit.state.stringBuffer.toString(),
      'await tester.tapAt(const Offset(10.0, 10.0));\n'
      'await tester.pumpAndSettle();\n',
    );
  });

  test('Genere fichier test', () async {
    final directory = await getApplicationDocumentsDirectory();
    final fileTest = File('${directory.path}/test.dart');
    flutterIntegrationRecordCubit.tapStop = Offset.zero;
    // ignore: avoid_slow_async_io
    if (await fileTest.exists()) fileTest.deleteSync();
    // ignore: avoid_slow_async_io
    flutterIntegrationRecordCubit.writeTestFile();

    // ignore: avoid_slow_async_io
    expect(await fileTest.exists(), true);
    fileTest.deleteSync();
  });

  blocTest<FlutterIntegrationRecordCubit, FlutterIntegrationRecordState>(
    'Supprime last tap and pump',
    tearDown: () async {},
    build: () => FlutterIntegrationRecordCubit(
      nomTest: 'test',
      widgetChild: Container(),
    )
      ..emit(
        FlutterIntegrationRecordState(
          nomTest: 'test',
          stringBuffer: StringBuffer(
            'IntegrationTestWidgetsFlutterBinding.ensureInitialized()'
            '.framePolicy = '
            'LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;\n'
            "testWidgets('test', (WidgetTester tester) async {\n"
            'await tester.pumpWidget(const App());\n'
            'await tester.tapAt(const Offset(10.0, 10.0));\n'
            'await tester.pumpAndSettle();\n'
            'await tester.tapAt(const Offset(20.0, 20.0));\n'
            'await tester.pumpAndSettle();\n',
          ),
          file: file,
          currentWord: 'Alex',
          writeStart: true,
          champFocus: const Offset(11, 11),
        ),
      )
      ..tapStop = const Offset(20, 20),
    act: (bloc) => bloc.writeTestFile(),
    expect: () => [
      FlutterIntegrationRecordState(
        stringBuffer: StringBuffer(
          'IntegrationTestWidgetsFlutterBinding.ensureInitialized()'
          '.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;\n'
          "testWidgets('test', (WidgetTester tester) async {\n"
          'await tester.pumpWidget(const App());\n'
          'await tester.tapAt(const Offset(10.0, 10.0));\n'
          'await tester.pumpAndSettle();\n'
          'await tester.tapAt(const Offset(20.0, 20.0));\n'
          'await tester.pumpAndSettle();\n'
          'await tester.tapAt(const Offset(11.0, 11.0));\n'
          'await tester.pumpAndSettle();\n'
          "tester.testTextInput.enterText('Alex');\n"
          '});}\n',
        ),
        nomTest: 'test',
        file: file,
        champFocus: const Offset(11, 11),
      ),
      FlutterIntegrationRecordState(
        stringBuffer: StringBuffer(
          'IntegrationTestWidgetsFlutterBinding.ensureInitialized()'
          '.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;\n'
          "testWidgets('test', (WidgetTester tester) async {\n"
          'await tester.pumpWidget(const App());\n'
          'await tester.tapAt(const Offset(10.0, 10.0));\n'
          'await tester.pumpAndSettle();\n'
          'await tester.tapAt(const Offset(11.0, 11.0));\n'
          'await tester.pumpAndSettle();\n'
          "tester.testTextInput.enterText('Alex');\n"
          '});}\n',
        ),
        nomTest: 'test',
        file: file,
        champFocus: const Offset(11, 11),
      ),
    ],
  );

  blocTest<FlutterIntegrationRecordCubit, FlutterIntegrationRecordState>(
    'Focus change',
    build: () => FlutterIntegrationRecordCubit(
      nomTest: 'test',
      widgetChild: Container(),
    )..emit(
        FlutterIntegrationRecordState(
          currentWord: 'Alex',
          writeStart: true,
          nomTest: 'test',
          stringBuffer: StringBuffer(),
        ),
      ),
    act: (bloc) => bloc.focusChanged(
      offset: const Offset(10, 10),
    ),
    expect: () => [
      FlutterIntegrationRecordState(
        stringBuffer:
            StringBuffer('await tester.tapAt(const Offset(10.0, 10.0));\n'
                'await tester.pumpAndSettle();\n'
                "tester.testTextInput.enterText('Alex');\n"),
        nomTest: 'test',
        champFocus: const Offset(10, 10),
      ),
    ],
  );
  blocTest<FlutterIntegrationRecordCubit, FlutterIntegrationRecordState>(
    'write',
    build: () => FlutterIntegrationRecordCubit(
      nomTest: 'test',
      widgetChild: Container(),
    ),
    act: (bloc) => bloc
      ..write(
        character: 'A',
      )
      ..write(character: 'l')
      ..write(character: 'e')
      ..write(character: 'x'),
    expect: () => [
      FlutterIntegrationRecordState(
        stringBuffer: StringBuffer(),
        nomTest: 'test',
        writeStart: true,
      ),
      FlutterIntegrationRecordState(
        stringBuffer: StringBuffer(),
        nomTest: 'test',
        currentWord: 'A',
        writeStart: true,
      ),
      FlutterIntegrationRecordState(
        stringBuffer: StringBuffer(),
        nomTest: 'test',
        currentWord: 'Al',
        writeStart: true,
      ),
      FlutterIntegrationRecordState(
        stringBuffer: StringBuffer(),
        nomTest: 'test',
        currentWord: 'Ale',
        writeStart: true,
      ),
      FlutterIntegrationRecordState(
        stringBuffer: StringBuffer(),
        nomTest: 'test',
        currentWord: 'Alex',
        writeStart: true,
      ),
    ],
  );

  blocTest<FlutterIntegrationRecordCubit, FlutterIntegrationRecordState>(
    'write supprime last tap',
    build: () => FlutterIntegrationRecordCubit(
      nomTest: 'test',
      widgetChild: Container(),
    )
      ..emit(
        FlutterIntegrationRecordState(
          stringBuffer: StringBuffer(
            'await tester.tapAt(const Offset(11.0, 11.0));\n'
            'await tester.pumpAndSettle();\n',
          ),
          nomTest: 'test',
          champFocus: const Offset(10, 10),
        ),
      )
      ..tapStop = const Offset(11, 11),
    act: (bloc) => bloc.write(
      character: 'A',
    ),
    expect: () => [
      FlutterIntegrationRecordState(
        stringBuffer: StringBuffer(),
        nomTest: 'test',
        champFocus: const Offset(10, 10),
      ),
      FlutterIntegrationRecordState(
        stringBuffer: StringBuffer(),
        nomTest: 'test',
        writeStart: true,
        champFocus: const Offset(10, 10),
      ),
      FlutterIntegrationRecordState(
        stringBuffer: StringBuffer(),
        nomTest: 'test',
        currentWord: 'A',
        writeStart: true,
        champFocus: const Offset(10, 10),
      ),
    ],
  );
}
