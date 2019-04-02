/*
  Netanel Avraham 207544131
  Neriya Bar-lev  313366676
 */

import 'dart:io';
import 'dart:convert';
import 'arithmetic-parser.dart';
import 'logic-parser.dart';
import 'memory-access-parser.dart';

class VMTranslator1 {
  var memoryReg = new RegExp(
    r'^(pop|push) (local|argument|this|that|constant|temp|pointer|static) \d*$');
  var arithmeticReg = new RegExp(r'^(add|sub|neg|and|or|not)$');
  var logicReg = new RegExp(r'^(eq|gt|lt)$');

  parse(List<String> listOfLines, String fileName) {
    var hackCode = '';
    for (var line in listOfLines) {
      print(line);
      hackCode += _parseCommand(line, fileName);
    }
    return hackCode;
  }

  _parseCommand(String line, String fileName) {
    var arithmeticParser = new ArithmeticCommands();
    var memoryParser = new MemoryAccessCommands();
    var logicParser = new LogicCommands();

    String type = _checkValidMemoryCommand(line);
    if (type == 'arithmetic') return arithmeticParser.parse(line);
    if (type == 'memory') return memoryParser.parse(line, fileName);
    if (type == 'logic') {
      return logicParser.parse(line);
    };
    if (type == 'comment' || type == 'empty') return '';
    throw 'not valid';
  }

  String _checkValidMemoryCommand(String line) {
    if (line.startsWith('//')) return 'comment';
    if (line == '') return 'empty';
    if (arithmeticReg.hasMatch(line)) return 'arithmetic';
    if (memoryReg.hasMatch(line)) return 'memory';
    if (logicReg.hasMatch(line)) return 'logic';
    return 'not valid';
  }
}

main() async {
  print("enter the file name");
  var path = stdin.readLineSync();
  var file = new File(path);

  if (!file.path.endsWith('.vm')) {
    print('${path} not found vm file');
    return;
  }
  var inputStream = file.openRead();
  var lines = await inputStream
    .transform(utf8.decoder)
    .transform(LineSplitter())
    .toList();
  var asmFile = new File('${file.path.substring(0, file.path.length - 3)}.asm')
    .openWrite();
  var translator = new VMTranslator1();
  try {
    var fileNameStart =file.path.contains('/')? file.path.lastIndexOf('/')+1: 0;
    var outString = translator.parse(
      lines, file.path.substring(fileNameStart, file.path.length - 3));
    asmFile.write(outString);
  } catch (e) {
    print('not valid code\n\n');
    print(e);
  }
}
