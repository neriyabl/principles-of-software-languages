import 'dart:io';
import 'Entities.dart';

class Tokenizer {
  static final _commentLine = new RegExp(r'//[^\n]*');
  static final _commentMultyLint = new RegExp(r'/\*[\s\S]*\*/');
  static final _keyword = new RegExp(
      r'^(class|constructor|function|method|field|static|var|int|char|boolean|void|true|false|null|this|let|do|if|else|while|return)$');
  static final _symbol = new RegExp(r"^([{}()\[\].,;+\-*/&|<>=~])$");
  static final _integerConstant = new RegExp(
      r'^([1-2]?[0-9]?[0-9]?[0-9]?[0-9]|3[0-1][0-9]{3}|32[0-6][0-9]{2}|327[0-5][0-9]|3276[0-7])$');
  static final _stringConstant = new RegExp(r'^"[^"\n]*"$');
  static final _identifier = new RegExp(r'^([a-z]|[A-Z]|_)(^\s|\w)*$');

  static final _regExMap = {
    'symbol': _symbol,
    'keyword': _keyword,
    'integerConstant': _integerConstant,
    'stringConstant': _stringConstant,
    'identifier': _identifier
  };

  String buffer;
  String inputFileText;
  List<Token> outputTokenList;

  Tokenizer(String _inputFileText) {
    inputFileText = _inputFileText.replaceAll(_commentLine, '');
    inputFileText = inputFileText.replaceAll(_commentMultyLint, '');
    print(inputFileText);
  }

  generateTokens() {
    buffer = '';
    outputTokenList = List<Token>();
    _removeWhiteSpaceAndNewLin();
    while (inputFileText.length > 0) {
      buffer += inputFileText[0];
      inputFileText = inputFileText.substring(1);
      _regExMap.forEach((key, val) => {
            if (val.hasMatch(buffer)) {_checkAndGenerateToken(key)}
          });
    }
  }

  _removeWhiteSpaceAndNewLin() {
    while (inputFileText.length > 0 &&
        (inputFileText[0] == ' ' ||
            inputFileText[0] == '\t' ||
            inputFileText[0] == '\n')) {
      inputFileText = inputFileText.substring(1);
    }
  }

  _checkAndGenerateToken(String key) {
    if (inputFileText.length > 0 &&
        _regExMap[key].hasMatch(buffer + inputFileText[0])) return;
    const symbolMap = {'<': '&lt;', '>': '&gt;', '"': '&quot;', '&': '&amp;'};

    if (key == 'symbol' && symbolMap.keys.contains(buffer)) {
      buffer = symbolMap[buffer];
    }
    if(key == 'stringConstant'){
      buffer = buffer.replaceAll('"', '');
    }

    outputTokenList.add(Token(
        TokenType.values.firstWhere((type) => getTokenString(type) == key),
        buffer));
    buffer = '';
    _removeWhiteSpaceAndNewLin();
  }

  exportFileToXML(String JackFileName, {List<Token> tokenStream = null}) {
    String resultedXML = '<tokens>\n';
    if (tokenStream == null) {
      tokenStream = outputTokenList;
    }

    for (var token in tokenStream) {
      var tokenType = getTokenString(token.type);
      resultedXML += '\t<$tokenType> ${token.value} </$tokenType>\n';
    }
    resultedXML += '</tokens>';

    // create text file and write xml
    var XmlFile = new File(JackFileName + 'T.xml').openWrite();
    XmlFile.write(resultedXML);
  }
}

main() {
  var tokenizer = new Tokenizer('// This file is part of the materials '
      'accompanying the book\n'
      '// "The Elements of Computing Systems" by Nisan and Schocken, \n'
      '// MIT Press. Book site: www.idc.ac.il/tecs\n'
      '// File name: projects/10/ArrayTest/Main.jack\n'
      '/** Computes the average of a sequence of integers. */\n'
      'class Main {\n'
      'function void main() {\n'
      'var Array a;\n'
      'var int length;\n'
      'var int i, sum;\n'
      'let length = Keyboard.readInt("HOW MANY NUMBERS? ");\n'
      'let a = Array.new(length);\n'
      'let i = 0;\n'
      'while (i < length) {\n'
      'let a[i] = Keyboard.readInt("ENTER THE NEXT NUMBER: ");\n'
      'let i = i + 1;\n'
      '}\n'
      'let i = 0;\n'
      'let sum = 0;\n'
      'while (i < length) {\n'
      'let sum = sum + a[i];\n'
      'let i = i + 1;\n'
      '}\n'
      'do Output.printString("THE AVERAGE IS: ");\n'
      'do Output.printInt(sum / length);\n'
      'do Output.println();\n'
      'return;\n'
      '}\n'
      '}\n');

  print('generate tokens...');
  tokenizer.generateTokens();
  print('export to xml file...');
  tokenizer.exportFileToXML('test');
}
