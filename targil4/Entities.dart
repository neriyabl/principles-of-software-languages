enum TokenType { keyword, symbol, integerConstant, stringConstant, identifier }

class Token {
  final TokenType type;
  final String value;
  Token(this.type, this.value);
}
