import 'dart:html';

import 'Entities.dart';


class Tokenizer {
  final _keyword = new RegExp(
      r'^(class|constructor|function|method|field|static|var|int|char|boolean|void|true|false|null|this|let|do|if|else|while|return)$');

  final _sympol = new RegExp(r"^([{}()\[\].,;+\-*/&|<>=~])$");

  final _integerConstant = new RegExp(
      r'^([1-2]?[0-9]?[0-9]?[0-9]?[0-9]|3[0-1][0-9]{3}|32[0-6][0-9]{2}|327[0-5][0-9]|3276[0-7])$');

  final _stringConstant = new RegExp(r'^"[^"]*"$');

  final List<String> inputFile;
  List<Token> outputTokenList;

  Tokenizer(this.inputFile);

  void ExportFileToXML(List<Token> tokenStream,String JackFileName)
  {
    String startTok="<token>\n";
    String resultedXML="";
    String EndTok="</token>";

    String startTokVal;
    String tokenValue;
    String EndTokVal;
    for (int i=0;i<tokenStream.length;i++)
    {
      TokenType tokenType=tokenStream[i].type;
      switch (tokenType.toString())
      {
        case 'keyword':
          startTokVal="<keyword>";
          tokenValue=tokenStream[i].value;
          EndTokVal="</keyword>\n";
          resultedXML = resultedXML + startTokVal + tokenValue + EndTokVal;
          break;
        case 'symbol':
          startTokVal="<symbol>";
          tokenValue=tokenStream[i].value;
          EndTokVal="</symbol>\n";
          resultedXML = resultedXML + startTokVal + tokenValue + EndTokVal;
          break;
        case 'integerConstant':
          startTokVal="<integerConstant>";
          tokenValue=tokenStream[i].value;
          EndTokVal="</integerConstant>\n";
          resultedXML = resultedXML + startTokVal + tokenValue + EndTokVal;
          break;
        case 'stringConstant':
          startTokVal="<stringConstant>";
          tokenValue=tokenStream[i].value;
          EndTokVal="</stringConstant>\n";
          resultedXML = resultedXML + startTokVal + tokenValue + EndTokVal;
          break;
        case 'identifier':
          startTokVal="<identifier>";
          tokenValue=tokenStream[i].value;
          EndTokVal="</identifier>\n";
          resultedXML = resultedXML + startTokVal + tokenValue + EndTokVal;
          break;
      }
    }
    resultedXML = startTok + resultedXML +"\n"+ EndTok;
/////////////////////to verify input as XML//////////////////
    try {
      //var document = xml.parse(bookshelfXml);
    }
    on Exception catch(e) {}

////////////////////create text file and write xml//////////////////
    //var XmlFile = new File(JackFileName + 'T.XML').openWrite();
    //XmlFile.write(resultedXML);
  }



  initialState () {
    List<Token> tokenStream;
    for (var line in inputFile) {
      for (var character in line) {}
    }
  }

}
