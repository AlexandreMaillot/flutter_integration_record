part of 'flutter_integration_record_cubit.dart';

class FlutterIntegrationRecordState extends Equatable {
  const FlutterIntegrationRecordState({
    required this.stringBuffer,
    this.file,
    required this.nomTest,
    this.champFocus,
    this.writeStart = false,
    this.currentWord = '',
  });
  final StringBuffer stringBuffer;
  final File? file;
  final String nomTest;
  final Offset? champFocus;
  final bool writeStart;
  final String currentWord;

  FlutterIntegrationRecordState copywith({
    StringBuffer? stringBuffer,
    File? file,
    String? nomTest,
    Offset? champFocus,
    bool? writeStart,
    String? currentWord,
  }) {
    return FlutterIntegrationRecordState(
      stringBuffer: stringBuffer ?? this.stringBuffer,
      file: file ?? this.file,
      nomTest: nomTest ?? this.nomTest,
      champFocus: champFocus ?? this.champFocus,
      writeStart: writeStart ?? this.writeStart,
      currentWord: currentWord ?? this.currentWord,
    );
  }

  @override
  List<Object?> get props => [
        stringBuffer.toString(),
        file,
        nomTest,
        champFocus,
        writeStart,
        currentWord,
      ];
}
