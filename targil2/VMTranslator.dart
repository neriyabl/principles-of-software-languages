import '../targil1/VMTranslator1.dart';
import 'flow-commands.dart';
import 'functions-commands.dart';
import 'dart:io';
import 'dart:convert';
class VMTranslator{

  parse(List<String> listOfLines, String fileName) {
    var hackCode = '';
    for (var line in listOfLines) {
      print(line);
      hackCode += _parseCommand(line, fileName);
    }
    return hackCode;
  }

}