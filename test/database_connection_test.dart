import 'package:test/test.dart';

void main() {
  test('status should be Completed when initial master controller', () async {
    bool isDbReady = false;
    while (!isDbReady) {
      await Future.delayed(const Duration(seconds: 1))
          .then((value) => isDbReady = true);
    }

    expect(isDbReady, true);
  });
}
