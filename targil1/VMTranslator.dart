import 'dart:io';
import 'dart:convert';
import 'arithmetic-parser.dart';
import 'memory access parser.dart';

class VMTranslator {
  var memoryReg = new RegExp(
      r'^(pop|push) (local|argument|this|that|constant|temp|pointer|static) \d*$');
  var arithmeticReg = new RegExp(r'^(add|sub|neg|eq|gt|lt|and|or|not)$');

  parse(List<String> listOfLines) {
    var hackCode = '';
    for (var line in listOfLines) {
      print(line);
      hackCode += _parseCommand(line);
    }
    return hackCode;
  }

  _parseCommand(String line) {
    var arithmeticParser = new ArithmeticCommands();
    var memoryParser = new MemoryAccessCommands();

    String type = _checkValidMemoryCommand(line);
    if (type == 'arithmetic') return arithmeticParser.parse(line);
    if (type == 'memory') return memoryParser.parse(line);
    if (type == 'comment' || type == 'empty') return '';
    throw 'not valid';
  }

  String _checkValidMemoryCommand(String line) {
    if (line.startsWith('//')) return 'comment';
    if (line == '') return 'empty';
    if (arithmeticReg.hasMatch(line)) return 'arithmetic';
    if (memoryReg.hasMatch(line)) return 'memory';
    return 'not valid';
  }
}

main() async {
  print("enter the file name");
  var path = stdin.readLineSync();
  var file = new File(path);
  print(file.existsSync());
  print(file.path);
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
  var translator = new VMTranslator();
  try {
    var outString = translator.parse(lines);
    asmFile.write(outString);
  } catch (e) {
    print('not valid code\n\n');
    print(e);
  }
}
