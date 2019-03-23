

class ArithmeticCommands {
  static const _PREFIX_BINARY_OPERATOR = '@SP\n' + 'AM=M-1\n' + 'D=M\n' + 'A=A-1\n';

  final add = _PREFIX_BINARY_OPERATOR + 'M=D+M\n';
  final sub = _PREFIX_BINARY_OPERATOR + 'M=D-M\n';
  final neg = '@SP\n' + 'A=M-1\n' + 'M=-M\n';

  final and = _PREFIX_BINARY_OPERATOR + 'M=D&M\n';
  final or = _PREFIX_BINARY_OPERATOR + 'M=D|M\n';
  final not = '@SP\n' + 'A=M-1\n' + 'M=!M\n';
}

