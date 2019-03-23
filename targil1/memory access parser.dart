class MemoryAccessCommands {
  static const _HELP_MAP = const {
    'local': 'LCL',
    'argument': 'ARG',
    'this': 'THIS',
    'that': 'THAT'
  };
  static const _PUSH_D = '@SP\n' 'A=M\n' 'M=D\n' '@SP\n' 'M=M+1\n';
  static const _POP_TO_D = '@SP\n' 'A=M-1\n' 'D=M\n';
  static const _STORE_D = 'M=D\n' '@SP\n' 'M=M-1\n';

  push(segment, index, {fileName = ''}) {
    if (_HELP_MAP.keys.contains(segment)) return _pushGroup1(segment, index);
    switch (segment) {
      case 'constant':
        return _pushConstant(index);
      case 'temp':
        return _pushTemp(index);
      case 'pointer':
        return _pushPointer(index);
      case 'static':
        return _pushStatic(index, fileName);
    }
  }

  _pushGroup1(segment, index) {
    return '@${index}\n'
        'D=A\n'
        '@${_HELP_MAP[segment]}\n'
        'A=M+D\n'
        'D=M\n' +
        _PUSH_D;
  }

  _pushTemp(index) {
    return '@${5 + index}\n'
        'D=M\n' +
        _PUSH_D;
  }

  _pushStatic(index, fileName) {
    return '@${fileName}.${index}\n'
        'D=M\n' +
        _PUSH_D;
  }

  _pushPointer(index) {
    var ptr = index == '0' ? 'THIS' : 'THAT';
    return '@${ptr}\n'
        'D=M\n' +
        _PUSH_D;
  }

  _pushConstant(val) {
    return '@${val}\n'
        'D=A\n' +
        _PUSH_D;
  }

  pop(segment, index, {fileName = ''}) {
    if (_HELP_MAP.keys.contains(segment)) return _popGroup1(segment, index);
    switch (segment) {
      case 'temp':
        return _popTemp(index);
      case 'pointer':
        return _popPointer(index);
      case 'static':
        return _popStatic(index, fileName);
    }
  }

  _popGroup1(segment, index) {
    return _POP_TO_D +
        '@${_HELP_MAP[segment]}\n'
        'A=M\n' +
        ('A=A+1\n' * index) +
        _STORE_D;
  }

  _popTemp(index) {
    return _POP_TO_D + '@${5 + index}\n' + _STORE_D;
  }

  _popPointer(index) {
    var ptr = index == '0' ? 'THIS' : 'THAT';
    return _POP_TO_D + '@${ptr}\n' + _STORE_D;
  }

  _popStatic(index, fileName) {
    return _POP_TO_D + '@${fileName}.${index}' + _STORE_D;
  }
}
