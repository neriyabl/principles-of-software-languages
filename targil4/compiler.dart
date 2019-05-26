import 'Entities.dart';

class Compiler {
  final List<Token> tokenList;
  TokenNode root;

  Compiler(this.tokenList);

  parse() {
    // root
    root = TokenNode(Grammar.$class, null);
    root.sons = [
      // class
      TokenNode(Grammar.keyword, root, token: tokenList.removeAt(0)),
      // className
      TokenNode(Grammar.identifier, root, token: tokenList.removeAt(0)),
      // {
      TokenNode(Grammar.symbol, root, token: tokenList.removeAt(0)),
    ];
    // classVarDec*
    while (tokenList[0].value == 'static' || tokenList[0].value == 'field') {
      root.sons.add(_classVerDec(root));
    }
    // subroutineDec*
    while (
        ['constractor', 'function', 'method'].contains(tokenList.first.value)) {
      root.sons.add(_subroutineDecs(root));
    }
    // }
    root.sons
        .add(TokenNode(Grammar.symbol, root, token: tokenList.removeAt(0)));
  }

  _classVerDec(TokenNode father) {
    // classVarDec
    var tokenNode = TokenNode(Grammar.classVarDec, father);
    tokenNode.sons = [
      // static | field
      TokenNode(Grammar.keyword, tokenNode, token: tokenList.removeAt(0)),
      // type
      _type(tokenNode),
      // varName
      TokenNode(Grammar.identifier, tokenNode, token: tokenList.removeAt(0)),
    ];
    //  (',' varName)*
    while (tokenList[0].value == ',') {
      tokenNode.sons.addAll([
        // ,
        TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0)),
        // varName
        TokenNode(Grammar.identifier, tokenNode, token: tokenList.removeAt(0))
      ]);
    }
    // ;
    tokenNode.sons.add(
        TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0)));
    return tokenNode;
  }

  _type(TokenNode father) {
    var grammar = Grammar.values.firstWhere((g) =>
        g.toString().substring(g.toString().indexOf('.') + 1) ==
        tokenList[0]
            .type
            .toString()
            .substring(tokenList[0].type.toString().indexOf('.') + 1));
    // take type from the token
    return TokenNode(grammar, father, token: tokenList.removeAt(0));
  }

  _subroutineDecs(TokenNode father) {
    // subroutineDec
    var tokenNode = TokenNode(Grammar.subroutineDec, father);
    tokenNode.sons = [
      // ('constructor' | 'function' | 'method')
      TokenNode(Grammar.keyword, tokenNode, token: tokenList.removeAt(0)),
      // ('void' | type)
      _type(tokenNode),
      // subroutineName
      TokenNode(Grammar.identifier, tokenNode, token: tokenList.removeAt(0)),
      // (
      TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0)),
      // paramList
      _paramList(tokenNode),
      // )
      TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0)),
      // subroutineBody
      _subroutineBody(tokenNode)
    ];
    return tokenNode;
  }

  _paramList(TokenNode father) {
    // parameterList
    TokenNode tokenNode = TokenNode(Grammar.parameterList, father);
    if (tokenList.first.value == ')') return tokenNode;
    tokenNode.sons = [
      _type(tokenNode),
      TokenNode(Grammar.identifier, tokenNode, token: tokenList.removeAt(0))
    ];
    while (tokenList.first.value == ',') {
      tokenNode.sons.addAll([
        _type(tokenNode),
        TokenNode(Grammar.identifier, tokenNode, token: tokenList.removeAt(0))
      ]);
    }
    return tokenNode;
  }

  _subroutineBody(TokenNode father) {
    // subroutineBody
    TokenNode tokenNode = TokenNode(Grammar.subroutineBody, father);
    tokenNode.sons = [
      // {
      TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0))
    ];
    // varDec*
    while (tokenList.first.value == 'var') {
      tokenNode.sons.add(_varDec(tokenNode));
    }
    tokenNode.sons.addAll([
      // statements
      _statements(tokenNode),
      // }
      TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0))
    ]);
    return tokenNode;
  }

  _varDec(TokenNode father) {
    // varDec
    TokenNode tokenNode = TokenNode(Grammar.varDec, father);
    tokenNode.sons = [
      // var
      TokenNode(Grammar.keyword, tokenNode, token: tokenList.removeAt(0)),
      // type
      _type(tokenNode),
      // varName
      TokenNode(Grammar.identifier, tokenNode, token: tokenList.removeAt(0))
    ];
    while (tokenList.first.value == ',') {
      tokenNode.sons.addAll([
        // ,
        TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0)),
        // varName
        TokenNode(Grammar.identifier, tokenNode, token: tokenList.removeAt(0))
      ]);
    }
    // ;
    TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0));
    return tokenNode;
  }

  _statements(TokenNode father) {
    // statements
    var tokenNode = TokenNode(Grammar.statements, father);
    tokenNode.sons = [];
    while (tokenList.first.value != '}') {
      tokenNode.sons.add(_statement(tokenNode));
    }
    return tokenNode;
  }

  _statement(TokenNode father) {
    switch (tokenList.first.value) {
      case 'let':
        return _letStatement(father);
      case 'if':
        return _ifStatement(father);
      case 'while':
        return _whileStatement(father);
      case 'do':
        return _doStatement(father);
      case 'return':
        return _returnStatement(father);
    }
  }

  _letStatement(TokenNode father) {
    // letStatement
    var tokenNode = TokenNode(Grammar.letStatement, father);
    tokenNode.sons = [
      // let
      TokenNode(Grammar.keyword, tokenNode, token: tokenList.removeAt(0)),
      // varName
      TokenNode(Grammar.identifier, tokenNode, token: tokenList.removeAt(0)),
    ];
    // ('[' expression ']')?
    if (tokenList.first.value == '[') {
      tokenNode.sons.addAll([
        // [
        TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0)),
        // expression
        _expression(tokenNode),
        // ]
        TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0))
      ]);
    }
    tokenNode.sons.addAll([
      // =
      TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0)),
      // expression
      _expression(tokenNode),
      // ;
      TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0))
    ]);
  }

  _ifStatement(TokenNode father) {
    // ifStatement
    var tokenNode = TokenNode(Grammar.ifStatement, father);
    tokenNode.sons = [
      // if
      TokenNode(Grammar.keyword, tokenNode, token: tokenList.removeAt(0)),
      // (
      TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0)),
      // expression
      _expression(tokenNode),
      // )
      TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0)),
      // {
      TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0)),
      // statements
      _statements(tokenNode),
      // }
      TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0))
    ];
    // ( 'else' '{' statements '}' )?
    if (tokenList.first.value == 'else') {
      tokenNode.sons.addAll([
        // else
        TokenNode(Grammar.keyword, tokenNode, token: tokenList.removeAt(0)),
        // {
        TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0)),
        // statements
        _statements(tokenNode),
        // }
        TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0))
      ]);
    }
    return tokenNode;
  }

  _whileStatement(TokenNode father) {
    var tokenNode = TokenNode(Grammar.whileStatement, father);
    tokenNode.sons = [
      // while
      TokenNode(Grammar.keyword, tokenNode, token: tokenList.removeAt(0)),
      // (
      TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0)),
      // expression
      _expression(tokenNode),
      // )
      TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0)),
      // {
      TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0)),
      // statements
      _statements(tokenNode),
      // }
      TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0))
    ];
  }

  _doStatement(TokenNode father) {
    var tokenNode = TokenNode(Grammar.doStatement, father);
    tokenNode.sons = [
      // do
      TokenNode(Grammar.keyword, tokenNode, token: tokenList.removeAt(0)),
      // subroutineCall
      _subroutineCall(tokenNode),
      // ;
      TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0)),
    ];
    return tokenNode;
  }

  _returnStatement(TokenNode father) {
    var tokenNode = TokenNode(Grammar.ReturnStatement, father);
    tokenNode.sons = [
      // return
      TokenNode(Grammar.keyword, tokenNode, token: tokenList.removeAt(0))
    ];
    if (tokenList.first.value != ';') {
      tokenNode.sons.add(_expression(tokenNode));
    }
    tokenNode.sons.add(
        // ;
        TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0)));
    return tokenNode;
  }

  _expression(TokenNode father) {
    var tokenNode = TokenNode(Grammar.expression, father);
    tokenNode.sons = [
      // term
      _term(tokenNode)
    ];
    while (['+', '-', '*', '/', '&amp;', ',', '&lt;', '&gt;', '=']
        .contains(tokenList.first.value)) {
      tokenNode.sons.addAll([
        // op
        TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0)),
        // term
        _term(tokenNode)
      ]);
    }
    return tokenNode;
  }

  _term(TokenNode father) {
    var tokenNode = TokenNode(Grammar.term, father);
    if (tokenList.first.type == TokenType.integerConstant) {
      tokenNode.sons = [
        TokenNode(Grammar.integerConstant, tokenNode,
            token: tokenList.removeAt(0))
      ];
    } else if (tokenList.first.type == TokenType.stringConstant) {
      tokenNode.sons = [
        TokenNode(Grammar.stringConstant, tokenNode,
            token: tokenList.removeAt(0))
      ];
    } else if (['true', 'false', 'null', 'this']
        .contains(tokenList.first.value)) {
      tokenNode.sons = [
        TokenNode(Grammar.keyword, tokenNode, token: tokenList.removeAt(0))
      ];
    } else if (['-', '~'].contains(tokenList.first.value)) {
      tokenNode.sons = [
        // unaryOp
        TokenNode(Grammar.keyword, tokenNode, token: tokenList.removeAt(0)),
        // term
        _term(tokenNode)
      ];
    } else if (tokenList.first.value == '(') {
      tokenNode.sons = [
        // (
        TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0)),
        // expression
        _expression(tokenNode),
        // )
        TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0))
      ];
    } else if (tokenList.first.type == TokenType.identifier) {
      if (tokenList[1].value == '(' || tokenList[1].value == '.') {
        tokenNode.sons = [_subroutineCall(tokenNode)];
      } else {
        tokenNode.sons = [
          // varName
          TokenNode(Grammar.identifier, tokenNode, token: tokenList.removeAt(0))
        ];
        if (tokenList.first.value == '[') {
          tokenNode.sons.addAll([
            // [
            TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0)),
            // expression
            _expression(tokenNode),
            // ]
            TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0))
          ]);
        }
      }
    }
    return tokenNode;
  }

  _subroutineCall(TokenNode father) {
    var tokenNode = TokenNode(Grammar.subroutineCall, father);
    tokenNode.sons = [
      // subroutineName | className | varName
      TokenNode(Grammar.identifier, tokenNode, token: tokenList.removeAt(0))
    ];
    if (tokenList.first.value == '.') {
      tokenNode.sons.addAll([
        // .
        TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0)),
        // subroutineName
        TokenNode(Grammar.identifier, tokenNode, token: tokenList.removeAt(0))
      ]);
    }
    tokenNode.sons.addAll([
      // (
      TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0)),
      // expressionList
      _expressionList(tokenNode),
      // )
      TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0))
    ]);
    return tokenNode;
  }

  _expressionList(TokenNode father) {
    var tokenNode = TokenNode(Grammar.expressionList, father);
    if (tokenList.first.value != ')') {
      tokenNode.sons = [
        // expression
        _expression(tokenNode)
      ];
      while (tokenList.first.value == ',') {
        tokenNode.sons.addAll([
          // ,
          TokenNode(Grammar.symbol, tokenNode, token: tokenList.removeAt(0)),
          // expression
          _expression(tokenNode)
        ]);
      }
    }
  }

  printNode(TokenNode t, r) {
    if (t == null) return;
    var grammar = t.grammar.toString().substring(t.grammar.toString().indexOf
      ('.')+1);
    if(grammar == r'$class') grammar = 'class';
    if (t.token != null) {
      print('$r<$grammar> ${t.token.value} </$grammar>');
    } else if (t.sons != null) {
      print('$r<$grammar>');
      for (var node in t.sons) {
        printNode(node, r + '  ');
      }
      print('$r</$grammar>');
    }
    return;
  }
}

