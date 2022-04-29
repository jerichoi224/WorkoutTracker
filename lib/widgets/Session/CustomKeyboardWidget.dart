import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:workout_tracker/util/StringTool.dart';

Widget KeyboardKey(String text, Function method)
{
  switch(text)
  {
    case "+ 5":
    case "- 5":
    case "1":
    case "2":
    case "3":
    case "4":
    case "5":
    case "6":
    case "7":
    case "8":
    case "9":
    case "0":
    case ".":
      return Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              method();
            },
            child: Container(
              margin: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: ["+ 5", "- 5"].contains(text) ? Colors.grey.shade200 : Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              child: Center(
                  child: Text(text,
                      style:TextStyle(
                          fontSize: 22
                      )
                  )
              ),
            ),
          ),
        ),
      );
    case "<-":
    case "clear":
      return Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              method();
            },
            child: Container(
              margin: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              child: Center(
                child: Icon(
                  text == "<-" ? Icons.arrow_back : Icons.clear,
                  color: Color.fromRGBO(0, 0, 0, 1),
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      );
  }
  //      case "check":
  return Expanded(
    flex: 1,
    child: Padding(
      padding: const EdgeInsets.all(1.0),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          method();
        },
        child: Container(
          margin: EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.amber.shade300,
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
          child: Center(
            child: Icon(
              Icons.check,
              color: Color.fromRGBO(0, 0, 0, 1),
              size: 22,
            ),
          ),
        ),
      ),
    ),
  );
}

// function from https://medium.com/flutter-community/custom-in-app-keyboard-in-flutter-b925d56c8465
void _backspace(TextEditingController _controller) {
  final text = _controller.text;
  final textSelection = _controller.selection;
  final selectionLength = textSelection.end - textSelection.start;
  // There is a selection.
  if (selectionLength > 0) {
    final newText = text.replaceRange(
      textSelection.start,
      textSelection.end,
      '',
    );
    _controller.text = newText;
    _controller.selection = textSelection.copyWith(
      baseOffset: textSelection.start,
      extentOffset: textSelection.start,
    );
    return;
  }
  // The cursor is at the beginning.
  if (textSelection.start == 0) {
    return;
  }
  // Delete the previous character
  final previousCodeUnit = text.codeUnitAt(textSelection.start - 1);
  final offset = 1;
  final newStart = textSelection.start - offset;
  final newEnd = textSelection.start;
  final newText = text.replaceRange(
    newStart,
    newEnd,
    '',
  );
  _controller.text = newText;
  _controller.selection = textSelection.copyWith(
    baseOffset: newStart,
    extentOffset: newStart,
  );
}

void _insertText(String input, TextEditingController editingController, bool replace) {
  final text = editingController.text;
  TextSelection textSelection = editingController.selection;
  if((textSelection.start == -1 && textSelection.end == -1) || replace)
    textSelection = textSelection.copyWith(baseOffset: 0,extentOffset:0);
  String newText = "";
  if(replace)
    {
      newText = input;
    }
  else
  {
    newText = text.replaceRange(
      textSelection.start,
      textSelection.end,
      input,
    );
  }
  final textLength = input.length;
  editingController.text = newText;
  editingController.selection = textSelection.copyWith(
    baseOffset: textSelection.start + textLength,
    extentOffset: textSelection.start + textLength,
  );
}

void editText(String key, int textLimit, TextEditingController editingController)
{
  switch(key)
  {
    case "1":
    case "2":
    case "3":
    case "4":
    case "5":
    case "6":
    case "7":
    case "8":
    case "9":
    case "0":
      if(editingController.text.length < textLimit)
        _insertText(key, editingController, false);
      return;
    case ".":
      if(editingController.text.length < textLimit && !editingController.text.contains(".") && textLimit != 3)
        _insertText(key, editingController, false);
      return;
    case "clear":
      _insertText("", editingController, true);
      return;
    case "+5":
      double i = 0;
      if(editingController.text.isNotEmpty)
        i = double.parse(editingController.text);
      _insertText((i+5).toStringRemoveTrailingZero().replaceAll(",", ""), editingController, true);
      return;
    case "-5":
      double i = 0;
      if(editingController.text.isNotEmpty)
        i = double.parse(editingController.text);
      _insertText((i-5).toStringRemoveTrailingZero().replaceAll(",", ""), editingController, true);
      return;
    case "<-":
      if(editingController.text.length > 0)
        _backspace(editingController);
      return;
  }
}

Widget customKeyboard(TextEditingController editingController, bool showKeyboard, int textLimit, [Function? method])
{
  return Container(
    color: Colors.amber.shade50,
    padding: EdgeInsets.fromLTRB(4, 6, 4, 6),
    height: 240.0,
    child: InkWell(
      onTap: () {
      },
      child: Column(
        children: [
          Expanded(
            child: Row(
                children: [
                  KeyboardKey('1', (){editText("1", textLimit, editingController);}),
                  KeyboardKey('2', (){editText("2", textLimit, editingController);}),
                  KeyboardKey('3', (){editText("3", textLimit, editingController);}),
                  KeyboardKey('+ 5', (){editText("+5", textLimit, editingController);}),
                ]
            ),
          ),
          Expanded(
            child: Row(
                children: [
                  KeyboardKey('4', (){editText("4", textLimit, editingController);}),
                  KeyboardKey('5', (){editText("5", textLimit, editingController);}),
                  KeyboardKey('6', (){editText("6", textLimit, editingController);}),
                  KeyboardKey('- 5', (){editText("-5", textLimit, editingController);}),
                ]
            ),
          ),
          Expanded(
            child: Row(
                children: [
                  KeyboardKey('7', (){editText("7", textLimit, editingController);}),
                  KeyboardKey('8', (){editText("8", textLimit, editingController);}),
                  KeyboardKey('9', (){editText("9", textLimit, editingController);}),
                  KeyboardKey('<-', (){editText("<-", textLimit, editingController);}),
                ]
            ),
          ),
          Expanded(
            child: Row(
                children: [
                  KeyboardKey('clear', (){editText("clear", textLimit, editingController);}),
                  KeyboardKey('0', (){editText("0", textLimit, editingController);}),
                  KeyboardKey('.', (){editText(".", textLimit, editingController);}),
                  KeyboardKey('check', method!),
                ]
            ),
          ),
        ],
      ),
    ),
  );
}