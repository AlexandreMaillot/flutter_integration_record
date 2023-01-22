import 'dart:io';

import 'package:flutter_integration_record/src/cubit/flutter_integration_record_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late StringBuffer stringBuffer;
  late StringBuffer stringBuffer2;
  late File file;
  late String nomTest;
  setUp(() {
    stringBuffer = StringBuffer();
    stringBuffer2 = StringBuffer('test');
    file = File('test');
    nomTest = 'monFichierTest';
  });

  test('Comparaison', () {
    expect(
      FlutterIntegrationRecordState(
        stringBuffer: stringBuffer,
        file: file,
        nomTest: nomTest,
      ),
      FlutterIntegrationRecordState(
        stringBuffer: stringBuffer,
        file: file,
        nomTest: nomTest,
      ),
    );
  });
  test('Copywith', () {
    expect(
      FlutterIntegrationRecordState(
        stringBuffer: stringBuffer,
        file: file,
        nomTest: nomTest,
      ).copywith(),
      FlutterIntegrationRecordState(
        stringBuffer: stringBuffer,
        file: file,
        nomTest: nomTest,
      ),
    );
  });
  test('Copywith StringBuffer', () {
    expect(
      FlutterIntegrationRecordState(
        stringBuffer: stringBuffer,
        file: file,
        nomTest: nomTest,
      ).copywith(stringBuffer: stringBuffer2),
      FlutterIntegrationRecordState(
        stringBuffer: stringBuffer2,
        file: file,
        nomTest: nomTest,
      ),
    );
  });

  test('Copywith file', () {
    expect(
      FlutterIntegrationRecordState(
        stringBuffer: stringBuffer,
        file: file,
        nomTest: nomTest,
      ).copywith(file: file),
      FlutterIntegrationRecordState(
        stringBuffer: stringBuffer,
        file: file,
        nomTest: nomTest,
      ),
    );
  });
  test('Copywith champ focus', () {
    expect(
      FlutterIntegrationRecordState(
        stringBuffer: stringBuffer,
        file: file,
        nomTest: nomTest,
      ).copywith(champFocus: const Offset(10, 10)),
      FlutterIntegrationRecordState(
        stringBuffer: stringBuffer,
        file: file,
        nomTest: nomTest,
        champFocus: const Offset(10, 10),
      ),
    );
  });

  test('Copywith write start', () {
    expect(
      FlutterIntegrationRecordState(
        stringBuffer: stringBuffer,
        file: file,
        nomTest: nomTest,
      ).copywith(writeStart: true),
      FlutterIntegrationRecordState(
        stringBuffer: stringBuffer,
        file: file,
        nomTest: nomTest,
        writeStart: true,
      ),
    );
  });
  test('Copywith current word', () {
    expect(
      FlutterIntegrationRecordState(
        stringBuffer: stringBuffer,
        file: file,
        nomTest: nomTest,
      ).copywith(currentWord: 'ok'),
      FlutterIntegrationRecordState(
        stringBuffer: stringBuffer,
        file: file,
        nomTest: nomTest,
        currentWord: 'ok',
      ),
    );
  });
}
