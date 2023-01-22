import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

part 'flutter_integration_record_state.dart';

class FlutterIntegrationRecordCubit
    extends Cubit<FlutterIntegrationRecordState> {
  FlutterIntegrationRecordCubit({
    required String nomTest,
  }) : super(
          FlutterIntegrationRecordState(
            stringBuffer: StringBuffer(),
            nomTest: nomTest,
          ),
        ) {
    initialiseFile();
  }
  late Offset tapStop;

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
    state.stringBuffer.writeln('await tester.pumpWidget(const App());');
    emit(state.copywith(file: file));
  }

  void onTapDown({required DragDownDetails details}) {
    if (state.writeStart) {
      focusChanged(offset: details.localPosition);
    }

    tapStop = details.localPosition;
    state.stringBuffer.writeln(
      'await tester.tapAt(const ${details.localPosition.toString()});',
    );
    state.stringBuffer.writeln('await tester.pumpAndSettle();');
  }

  void focusChanged({required Offset offset}) {
    if (state.writeStart) {
      state.stringBuffer
          .writeln('await tester.tapAt(const ${state.champFocus});');
      state.stringBuffer.writeln('await tester.pumpAndSettle();');
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
    if (state.writeStart == false) {
      emit(
        state.copywith(
          stringBuffer: StringBuffer(
            state.stringBuffer.toString().replaceAll(
                  'await tester.tapAt(const ${tapStop.toString()});\n'
                      'await tester.pumpAndSettle();\n',
                  '',
                ),
          ),
        ),
      );
      emit(state.copywith(writeStart: true));
    }
    emit(state.copywith(currentWord: '${state.currentWord}$character'));
  }

  void writeTestFile() {
    if (state.champFocus != null) {
      focusChanged(offset: state.champFocus!);
    }

    state.stringBuffer.writeln('});}');

    emit(
      state.copywith(
        stringBuffer: StringBuffer(
          state.stringBuffer.toString().replaceAll(
                'await tester.tapAt(const ${tapStop.toString()});\nawait tester.pumpAndSettle();\n',
                '',
              ),
        ),
      ),
    );
    state.file?.writeAsStringSync(state.stringBuffer.toString());
    exit(0);
  }
}
