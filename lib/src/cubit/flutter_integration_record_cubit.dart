import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:path_provider/path_provider.dart';

part 'flutter_integration_record_state.dart';

class FlutterIntegrationRecordCubit
    extends Cubit<FlutterIntegrationRecordState> {
  FlutterIntegrationRecordCubit({
    required String nomTest,
    required this.widgetChild,
    this.clock = const Clock(),
  }) : super(
          FlutterIntegrationRecordState(
            stringBuffer: StringBuffer(),
            nomTest: nomTest,
            timeLastAction: (clock.now().millisecondsSinceEpoch / 1000).round(),
          ),
        ) {
    initialiseFile();
  }
  late Offset tapStop;
  late Clock clock;
  final Widget widgetChild;

  Future<void> initialiseFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${state.nomTest}.dart');
    await file.create(recursive: true);
    state.stringBuffer
        .writeln("import 'package:flutter_test/flutter_test.dart';");
    state.stringBuffer
        .writeln("import 'package:integration_test/integration_test.dart';");
    state.stringBuffer.writeln('void main() {');
    state.stringBuffer.writeln(
        'IntegrationTestWidgetsFlutterBinding.ensureInitialized()'
        '.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;');
    state.stringBuffer.writeln(
      "testWidgets('${state.nomTest}', (WidgetTester tester) async {",
    );
    state.stringBuffer.writeln(
        'await tester.pumpWidget(const ${widgetChild.runtimeType}());');
    emit(
      state.copywith(
        file: file,
      ),
    );
  }

  void onTapDown({required DragDownDetails details}) {
    firstAction();
    if (state.writeStart) {
      focusChanged(offset: details.localPosition);
    }

    tapStop = details.localPosition;
    state.stringBuffer.writeln(
      'await tester.tapAt(const ${details.localPosition.toString()});',
    );
    state.stringBuffer
        .writeln('await tester.pumpAndSettle(${timelastAction()});');
  }

  String timelastAction() {
    final timeAction = (clock.now().millisecondsSinceEpoch / 1000).round();
    final timeBeforeLastAction = timeAction - state.timeLastAction! <= 1
        ? ''
        : 'const Duration(seconds: ${timeAction - state.timeLastAction!})';
    emit(
      state.copywith(
        timeLastAction: timeAction,
      ),
    );
    return timeBeforeLastAction;
  }

  void focusChanged({required Offset offset}) {
    firstAction();
    if (state.writeStart) {
      state.stringBuffer
          .writeln('await tester.tapAt(const ${state.champFocus});');
      state.stringBuffer
          .writeln('await tester.pumpAndSettle(${timelastAction()});');
      state.stringBuffer
          .writeln("tester.testTextInput.enterText('${state.currentWord}');");
    }
    emit(
      state.copywith(
        champFocus: offset,
        writeStart: false,
        currentWord: '',
      ),
    );
  }

  Future<void> write({required String character}) async {
    print('write $character');
    firstAction();
    if (state.writeStart == false) {
      emit(
        state.copywith(
          stringBuffer: StringBuffer(
            state.stringBuffer.toString().replaceAll(
                  'await tester.tapAt(const ${tapStop.toString()});\n'
                      'await tester.pumpAndSettle(${timelastAction()});\n',
                  '',
                ),
          ),
        ),
      );
      emit(state.copywith(writeStart: true));
    }
    emit(state.copywith(currentWord: '${state.currentWord}$character'));
  }

  void firstAction() {
    if (state.firstAction) {
      state.stringBuffer
          .writeln('await tester.pumpAndSettle(${timelastAction()});');
      emit(
        state.copywith(firstAction: false),
      );
    }
  }

  void writeTestFile() {
    firstAction();
    if (state.champFocus != null) {
      focusChanged(offset: state.champFocus!);
    }

    state.stringBuffer.writeln('});}');

    final listSplit = state.stringBuffer.toString().split('\n')
      ..removeRange(
        state.stringBuffer.toString().split('\n').length - 4,
        state.stringBuffer.toString().split('\n').length - 2,
      );
    emit(
      state.copywith(
        stringBuffer: StringBuffer(
          listSplit.join('\n'),
        ),
      ),
    );
    state.file?.writeAsStringSync(state.stringBuffer.toString());
    exit(0);
  }
}
