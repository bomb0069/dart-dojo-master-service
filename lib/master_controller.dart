import 'master_service.dart';

class MasterController {
  String _status = 'Completed';
  MasterService _masterService = MasterService();

  MasterController() {
    _masterService.updateSetStatusFunction(_setStatus);
  }

  MasterController.fromService(this._masterService) {
    _masterService.updateSetStatusFunction(_setStatus);
  }

  String get status => _status;

  void _setStatus(String status) {
    print(' set $status');
    _status = status;
  }

  void syncMaster() {
    _masterService.updateMasters();
  }
}
