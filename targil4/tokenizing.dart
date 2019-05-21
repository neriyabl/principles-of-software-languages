import 'dart:html';

import 'Entities.dart';

class Tokenizer {
  final _keyword = new RegExp(
      r'^(class|constructor|function|method|field|static|var|int|char|boolean|void|true|false|null|this|let|do|if|else|while|return)$');

  final _sympol = new RegExp(r"^([{}()\[\].,;+\-*/&|<>=~])$");

  final _integerConstant = new RegExp(r'^([1-2]?[0-9]?[0-9]?[0-9]?[0-9]|3[0-1][0-9]{3}|32[0-6][0-9]{2}|327[0-5][0-9]|3276[0-7])$');

  final _stringConstant = new RegExp(r'^"[^"]*"$');

  final List<String> inputFile;
  List<Token> outputTokenList;

  Tokenizer(this.inputFile);

  initialState () {
    List<Token> tokenStream;
    for(var line in inputFile){
      for(var character in line){
    }
  }


}
