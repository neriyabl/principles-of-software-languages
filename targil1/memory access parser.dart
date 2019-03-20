push(segment, index) {
  switch (segment) {
    case 'constant':
      return pushConstant(index);
    case 'local':
      return pushGroup('LCL', index);
    case 'argument':
      return pushGroup('ARG', index);
    case 'this':
      return pushGroup('THIS', index);
    case 'that':
      return pushGroup('THAT', index);
    case 'temp':
      return pushGroup('5', index);
    case 'pointer':
      return pushPointer(index);
    case 'static':
      return //todo
  }
}

const PUSH_D = '@SP\n' + 'A=M\n' + 'M=D\n' + '@SP\n' + 'M=M+1\n';

pushConstant(val) {
  return '@${val}\n'
      'D=A\n' +
      PUSH_D;
}

pushGroup(segment, index) {
  return '@${index}\n'
      'D=A\n'
      '@${segment}\n'
      'A=M+D\n'
      'D=M\n' +
      PUSH_D;
}

pushPointer(index) {
  var ptr = index == '0' ? 'THIS' : 'THAT';
  return '@${ptr}'
      'D=M' +
      PUSH_D;
}
