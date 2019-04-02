import '../targil1/memory-access-parser.dart';
import '../targil1/logic-parser.dart';
import '../targil1/arithmetic-parser.dart';
import 'flow-commands.dart';
import 'functions-commands.dart';

import 'dart:io';
import 'dart:convert';

class VMTranslatorFile {
  final memoryReg = new RegExp(
      r'^(pop|push) (local|argument|this|that|constant|temp|pointer|static) \d+$');
  final arithmeticReg = new RegExp(r'^(add|sub|neg|and|or|not)$');
  final logicReg = new RegExp(r'^(eq|gt|lt)$');
  final flowReg = new RegExp(r'^(label|goto|if-goto) (\w|\.)+$');
  final functionsReg = new RegExp(r'^(return|(call|function) (\w|\.)+ \d+)$');

  ArithmeticCommands arithmeticParser;
  LogicCommands logicParser;
  MemoryAccessCommands memoryParser;
  FlowCommands flowParser;
  FunctionCommands functionParser;

  final _fileName;

  VMTranslatorFile(this._fileName) {
    arithmeticParser = new ArithmeticCommands();
    logicParser = new LogicCommands();
    memoryParser = new MemoryAccessCommands(_fileName);
    flowParser = new FlowCommands(_fileName);
    functionParser = new FunctionCommands(_fileName);
  }

  _parseFile(List<String> listOfLines) {
    var hackCode = '';
    for (var line in listOfLines) {
      hackCode += _parseCommand(line);
    }
    return hackCode;
  }

  String _parseCommand(String line) {
    switch (_CheckTypeCommand(line)) {
      case 'arithmetic':
        return arithmeticParser.parse(line);
      case 'memory':
        return memoryParser.parse(line);
      case 'logic':
        return logicParser.parse(line);
      case 'flow':
        return flowParser.parse(line);
      case 'function':
        return functionParser.parse(line);
      case 'comment':
      case 'empty':
        return '';
      default:
        throw 'command not valid';
    }
  }

  _CheckTypeCommand(String line) {
    if (line.startsWith('//')) return 'comment';
    if (line == '') return 'empty';
    if (arithmeticReg.hasMatch(line)) return 'arithmetic';
    if (memoryReg.hasMatch(line)) return 'memory';
    if (logicReg.hasMatch(line)) return 'logic';
    if (flowReg.hasMatch(line)) return 'flow';
    if (functionsReg.hasMatch(line)) return 'function';
    return 'not valid';
  }
}
