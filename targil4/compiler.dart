import 'Entities.dart';
import 'expressions.dart';
import 'program-structure.dart';
import 'statements.dart';

class Compiler {
  final List<Token> tokenList;
  ProgramStructure _programStructure;
  Statements _statements;
  Expressions _expressions;
  TokenNode root;

  Compiler(this.tokenList) {
    _programStructure = new ProgramStructure(tokenList);
    _statements = new Statements(tokenList);
    _expressions = new Expressions(tokenList);
  }

  parse() {
    // root
    root = TokenNode(Grammar.$class, null);
    _programStructure.$class(root);
  }

  printNode(TokenNode t, r) {
    if (t == null) return;
    var grammar =
        t.grammar.toString().substring(t.grammar.toString().indexOf('.') + 1);
    if (grammar == r'$class') grammar = 'class';

    if (t.token != null) {
      print('$r<$grammar> ${t.token.value} </$grammar>');
    } else if (t.sons != null) {
      print('$r<$grammar>');
      for (var node in t.sons) {
        printNode(node, r + '  ');
      }
      print('$r</$grammar>');
    } else {
      print('$r<$grammar>\n$r</$grammar>');
    }
    return;
  }

  exportToXml(String JackFileName, {TokenNode tokenRootNode = null}){
    if(tokenRootNode == null){
      tokenRootNode = root;
    }


  }
}
