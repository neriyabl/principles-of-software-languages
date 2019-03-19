main() {
  print(add);
}

const prefixBinaryOperator = '@0\n' + 'AM=M-1\n' + 'D=M\n' + 'A=A-1\n';

const add = prefixBinaryOperator + 'M=D+M\n';
const sub = prefixBinaryOperator + 'M=D-M\n';
const neg = '@0\n' + 'A=M-1\n' + 'M=-M\n';

const and = prefixBinaryOperator + 'M=D&M\n';
const or = prefixBinaryOperator + 'M=D|M\n';
const not = '@0\n' + 'A=M-1\n' + 'M=!M\n';
