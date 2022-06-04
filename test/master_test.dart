import 'package:master/master_controller.dart';
import 'package:master/master_service.dart';
import 'package:test/test.dart';

void main() {
  test('status should be Completed when initial master controller', () async {
    // Arrange
    var expected = 'Completed';

    //Action
    MasterController masterController = MasterController();
    String actual = masterController.status;

    //Assert
    expect(actual, expected);
  });

  test('status should be Connecting when user call to sync master', () async {
    // Arrange
    var expected = 'Connecting';

    //Action
    MasterController masterController = MasterController();
    masterController.syncMaster();
    String actual = masterController.status;
    await Future.delayed(Duration(seconds: 3));

    //Assert
    expect(actual, expected);
  });

  test('status should be Connecting from master service', () async {
    // Arrange
    var expected = 'Connecting';
    MasterService masterService = MasterService();

    //Action
    MasterController masterController =
        MasterController.fromService(masterService);
    masterController.syncMaster();

    await Future.delayed(Duration(seconds: 3));
    String actual = masterController.status;
    //Assert
    expect(actual, expected);
  });

  test(
      'status should be Downloading when master service called download method',
      () async {
    // Arrange
    var expected = 'Downloading';
    MasterService masterService = MasterService();

    //Action
    MasterController masterController =
        MasterController.fromService(masterService);
    masterController.syncMaster();

    await Future.delayed(Duration(seconds: 15));

    String actual = masterController.status;
    //Assert
    expect(actual, expected);
  });
}
