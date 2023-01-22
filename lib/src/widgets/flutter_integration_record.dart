import 'package:flutter/material.dart';
import 'package:flutter_integration_record/src/cubit/flutter_integration_record_cubit.dart';

class FlutterIntegrationRecord extends StatelessWidget {
  const FlutterIntegrationRecord({
    super.key,
    required this.child,
  });

  final Widget child;
  @override
  Widget build(BuildContext context) {
    final flutterIntegrationRecordCubit =
        FlutterIntegrationRecordCubit(nomTest: 'ajoute_3', widgetChild: child);
    var firstFocus = true;
    FocusManager.instance.addListener(() {
      final focus = FocusManager.instance.primaryFocus;
      if (focus != null && firstFocus != true) {
        flutterIntegrationRecordCubit.focusChanged(offset: focus.offset);
      }
      firstFocus = false;
    });
    return Material(
      child: GestureDetector(
        onPanDown: (details) =>
            flutterIntegrationRecordCubit.onTapDown(details: details),
        excludeFromSemantics: true,
        behavior: HitTestBehavior.opaque,
        child: KeyboardListener(
          onKeyEvent: (value) => value.character != null
              ? flutterIntegrationRecordCubit.write(character: value.character!)
              : null,
          focusNode: FocusNode(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                child,
                InkWell(
                  onTap: flutterIntegrationRecordCubit.writeTestFile,
                  child: Container(
                    margin: const EdgeInsets.only(top: 25),
                    width: 10,
                    height: 10,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
