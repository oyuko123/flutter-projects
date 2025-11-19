import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/utils/check.dart';

void main() {
  test('Returns true for even numbers', () {
    expect(isEven(0), true);
    expect(isEven(2), true);
    expect(isEven(4), true);
  });

  test('Returns false for odd numbers', () {
    expect(isEven(1), false);
    expect(isEven(3), false);
    expect(isEven(9), false);
  });
}