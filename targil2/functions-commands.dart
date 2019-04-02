import '../targil1/memory-access-parser.dart';

class FunctionsCommands {
  final String _fileName;
  final MemoryAccessCommands memAccess = new MemoryAccessCommands();

  static var _returnAddressCounter = 0;
  static var _funcLoopCounter = 0;

  FunctionsCommands(this._fileName);

  _push(val) {
    return memAccess.push('constant', val);
  }

  _pushSegment(segment) {
    return '@${segment}\n'
        'D=M\n'
        '@SP\n'
        'M=M+1\n'
        'A=M-1\n'
        'M=D\n';
  }

  _popSegment(fromSegment, toSegment) {
    return '@${fromSegment}\n'
        'AM=M-1\n'
        'D=M\n'
        '@${toSegment}\n'
        'M=D\n';
  }

  _call(funcName, nArgs) {
    return this._push('@RA${_returnAddressCounter}') +
        this._pushSegment('LCL') +
        this._pushSegment('ARG') +
        this._pushSegment('THIS') +
        this._pushSegment('THAT') +
        '@SP\n'
        'D=M\n'
        '@${int.parse(nArgs) + 5}\n'
        'D=D-A\n'
        '@ARG\n'
        'M=D\n'
        '@SP\n'
        'D=M\n'
        '@LCL\n'
        'M=D\n'
        '@${funcName}\n'
        '0;JMP\n'
        '(RA${_returnAddressCounter++})\n';
  }

  _function(funcName, nArgs) {
    return '(${_fileName}.${funcName})\n'
        '@${nArgs}\n'
        'D=A\n'
        '@${funcName}.END.${_funcLoopCounter}\n'
        'D;JEQ\n'
        '(${funcName}.Loop.${_funcLoopCounter})\n' +
        this._push(0) +
        '@${funcName}.Loop.${_funcLoopCounter}\n'
        'D=D-1;JNE\n'
        '(${funcName}.END.${_funcLoopCounter})\n';
  }

  _return() {
    return '@SP\n'
        'A=M-1\n'
        'D=M\n'
        '@ARG\n'
        'A=M\n'
        'M=D\n';
  }

  parse(line) {}
}
