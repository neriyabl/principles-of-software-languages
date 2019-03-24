class LogicCommands {
  static const _PREFIX_BINARY_OPERATOR =
      '@SP\n' + 'AM=M-1\n' + 'D=M\n' + 'A=A-1\n';
  static const _STORE_D = 'M=D\n' '@SP\n' 'M=M-1\n';
  static var _counter_TRUE = 0;
  static var _counter_FALSE = 0;

  //eq
  static var _EQ = _PREFIX_BINARY_OPERATOR +
      'D=D-M\n'
      '@IF_TRUE${_counter_TRUE}\n'
      'D;JEQ\n'
      'D=1\n'
      '(IF_TRUE${_counter_TRUE})\n'
      'D=D-1\n' +
      _STORE_D;

  //gt
  static var _GT = _PREFIX_BINARY_OPERATOR +
      'D=M-D\n'
          '@IF_TRUE${_counter_TRUE}\n'
          'D;JGT\n'
          'D=0\n'
          '@IF_FALSE${_counter_FALSE}\n'
          '0;JMP\n'
          '(IF_TRUE${_counter_TRUE})\n'
          'D=-1\n'
          '(IF_FALSE${_counter_FALSE})\n' +
      _STORE_D;
  //LT
  static var _LT = _PREFIX_BINARY_OPERATOR +
      'D=D-M\n'
          '@IF_TRUE${_counter_TRUE}\n'
          'D;JGT\n'
          'D=0\n'
          '@IF_FALSE${_counter_FALSE}\n'
          '0;JMP\n'
          '(IF_TRUE${_counter_TRUE})\n'
          'D=-1\n'
          '(IF_FALSE${_counter_FALSE})\n' +
      _STORE_D;
}
