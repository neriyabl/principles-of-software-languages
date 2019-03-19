

main(){
  print(add());
}


String add() {
  return '@0\n'
         'M=M-1\n'
         'A=M\n'
         'D=M\n'
         'A=A-1\n'
         'A=M\n'
         'D=D+A\n'
         '@0\n'
         'A=M-1\n'
         'M=D';
}
