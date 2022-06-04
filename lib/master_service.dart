import 'dart:async';

enum Status { connecting(1), requesting(2), downloading(3), applying(4);

    final int id;
    const Status({
      required this.id
    });
 }

class MasterService {
  late final void Function(String status) _updateStatus;

  void updateSetStatusFunction(void Function(String status) updateStatus) {
    _updateStatus = updateStatus;
  }

  FutureOr<dynamic> updateMasters() async {
    _connectToHeadQuarter();
    _requestMasters();
    _download();
    _apply();
  }

  void _connectToHeadQuarter() {
    _updateStatus(Status.connecting.toString());
    Future.delayed(Duration(seconds: 1));
  }

  void _requestMasters() {
    _updateStatus('กำลังร้องขอข้อมูล');
    Future.delayed(Duration(seconds: 1)).then(_download);
  }

  void _download() {
    _updateStatus('กำลังดาวน์โหลดข้อมูล');
    Future.delayed(Duration(seconds: 1)).then(_apply);
  }

  void _apply() {
    _updateStatus('กำลังปรับปรุงข้อมูล');
    Future.delayed(Duration(seconds: 1))
        .then((value) => _updateStatus('ปรับปรุงข้อมูลเสร็จสมบูรณ์'));
  }
}
