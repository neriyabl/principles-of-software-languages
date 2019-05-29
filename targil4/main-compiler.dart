
import 'dart:io';

import 'compiler.dart';
import 'tokenizing.dart';

main() {
  print('Enter folder path');
  var directoryPath = stdin.readLineSync();
  var directory = new Directory(directoryPath);
  if (!directory.existsSync()) {
    print('this directory not found');
    return;
  }
  directory.list(recursive: true).forEach((FileSystemEntity entity) {
    if (entity.path.endsWith('.jack')) {
      var filePath = entity.path.substring(0, entity.path.length - 5);

      var jackCode = File(filePath).readAsStringSync();
      var tokenizer = Tokenizer(jackCode);
      print('$filePath generate tokens...');
      tokenizer.generateTokens();
      print('$filePath export to xml file \'${filePath}T.xml\'...');
      tokenizer.exportFileToXML(filePath);
      print('$filePath compile...');
      var compiler = Compiler(tokenizer.outputTokenList);
      compiler.parse();
      print('$filePath exporte to xml file \'${filePath}.xml\'...');
      compiler.exportToXml(filePath);
      print('$filePath .... FINISH ....');
    }
  });
}
