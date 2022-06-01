class MasterService {
  late void Function(String status) _updateStatus;
  void syncMaster(void Function(String status) updateStatus) async {
    _updateStatus = updateStatus;
    _updateStatus('Connecting');
    Future.delayed(Duration(seconds: 1)).then((value) => download());
  }

  void download() {
    _updateStatus('Downloading');
  }
}
