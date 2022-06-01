import 'master_service.dart';

class MasterController {
  String _status = 'Completed';
  MasterService _masterService = MasterService();

  MasterController();

  MasterController.fromService(this._masterService);

  String get status => _status;

  void _setStatus(String status) {
    print(' set $status');
    _status = status;
  }

  void syncMaster() {
    _masterService.syncMaster(_setStatus);
  }
}
