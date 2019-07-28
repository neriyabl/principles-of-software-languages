import 'dart:io';

void main() {
  Parent c = new Child();
  var arguments = {'argA': 'hello', 'argB': 42};
  c.m1(12);
  print(arguments);
}
class Parent {
  void m1(int a){ print("value of a ${a}");}
}
class Child extends Parent {
  void m1(int b) {
    print("value of b ${b}");
  }
}
