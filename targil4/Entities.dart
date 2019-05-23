enum TokenType { keyword, symbol, integerConstant, stringConstant, identifier }

String getTokenString(TokenType type) {
  return type.toString().substring(type.toString().indexOf('.') + 1);
}

class Token {
  final TokenType type;
  final String value;

  Token(this.type, this.value);
}
