import 'dart:io';
import 'Entities.dart';
import 'compiler.dart';

class Tokenizer {
  static final _commentLine = new RegExp(r'//[^\n]*');
  static final _commentMultyLint = new RegExp(r'/\*((?!\*/)[\s\S])*\*/');
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
  }

  generateTokens() {
    buffer = '';
    outputTokenList = List<Token>();
    _removeWhiteSpaceAndNewLin();
    while (inputFileText.length > 0) {
      buffer += inputFileText[0];
      inputFileText = inputFileText.substring(1);
      _regExMap.forEach((key, val) =>
      {
        if (val.hasMatch(buffer)) {_checkAndGenerateToken(key)}
      });
    }
  }

  _removeWhiteSpaceAndNewLin() {
    while (inputFileText.length > 0 &&
      (inputFileText[0] == ' ' ||
        inputFileText[0] == '\t' ||
        inputFileText[0] == '\n' ||
        inputFileText[0] == '\r')) {
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
    if (key == 'stringConstant') {
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
      resultedXML += '<$tokenType> ${token.value} </$tokenType>\n';
    }
    resultedXML += '</tokens>\n';

    // create text file and write xml
    var XmlFile = new File(JackFileName + 'T.xml').openWrite();
    XmlFile.write(resultedXML);
  }
}
