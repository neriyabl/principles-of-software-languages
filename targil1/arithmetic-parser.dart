main() {
  print('1'=='1');
}

const PREFIX_BINARY_OPERATOR = '@SP\n' + 'AM=M-1\n' + 'D=M\n' + 'A=A-1\n';

const add = PREFIX_BINARY_OPERATOR + 'M=D+M\n';
const sub = PREFIX_BINARY_OPERATOR + 'M=D-M\n';
const neg = '@SP\n' + 'A=M-1\n' + 'M=-M\n';

const and = PREFIX_BINARY_OPERATOR + 'M=D&M\n';
const or = PREFIX_BINARY_OPERATOR + 'M=D|M\n';
const not = '@SP\n' + 'A=M-1\n' + 'M=!M\n';
