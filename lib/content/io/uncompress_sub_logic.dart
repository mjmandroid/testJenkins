import 'package:desk_cloud/content/io/io_parent_logic.dart';
import 'package:desk_cloud/content/tabs/tab_io_logic.dart';
import 'package:desk_cloud/entity/transfer_record_entity.dart';
import 'package:desk_cloud/utils/export.dart';
import 'package:desk_cloud/utils/refresh_helper.dart';

class UncompressSubPartLogic extends BaseLogic with RefreshHelper {
  late IoParentLogic ioParentLogic;

  /// 解压
  final int type;

  /// 状态
  int typeStatus = 0;

  final statusList = {"1": "处理中", "2": "已完成", "3": "处理失败", "0": "待处理"};

  UncompressSubPartLogic({required this.type});

  final transferRecordEntity = Rx(TransferRecordEntity());

  @override
  void onInit() {
    super.onInit();
    ioParentLogic = Get.find<IoParentLogic>(tag: 'IoParentLogic_2');
    typeStatus = ioParentLogic.options[ioParentLogic.currentIndex.value].value;
    onLoadRecord(loading: true);
    ever(ioLogic.unzipingCount, (callback) {
      onRefresh();
    });
  }

  onLoadRecord({bool loading = false}) async {
    try {
      if (loading) showLoading();
      var base = await ApiNet.request<TransferRecordEntity>(Api.transferList,
          data: {'page': page, 'pageSize': pageSize, 'type': typeStatus});
      if (page == 1) {
        transferRecordEntity.value.list = null;
      }
      transferRecordEntity.value.list ??= [];
      transferRecordEntity.value.total = base.data?.total ?? 0;
      transferRecordEntity.value.list?.addAll(base.data?.list ?? []);
      transferRecordEntity.value.report = base.data?.report;
      ioParentLogic.options[1].count =
          transferRecordEntity.value.report?.total2 ?? 0;
      ioParentLogic.options[2].count =
          transferRecordEntity.value.report?.total1 ?? 0;
      ioParentLogic.options[3].count =
          transferRecordEntity.value.report?.total3 ?? 0;
      ioLogic.unzipingCount.value =
          transferRecordEntity.value.report?.total1 ?? 0;
      if (typeStatus == 0 && transferRecordEntity.value.list!.isEmpty) {
        ioParentLogic.uncompressIsEmpty.value = true;
      } else {
        ioParentLogic.uncompressIsEmpty.value = false;
      }
      ioParentLogic.options.refresh();
      controller.refreshCompleted();
      if (loading) dismissLoading();
      if ((transferRecordEntity.value.list?.length ?? 0) >=
          (base.data?.total ?? 0)) {
        controller.loadNoData();
      } else {
        controller.loadComplete();
      }
      transferRecordEntity.refresh();
    } catch (e) {
      if (loading) dismissLoading();
      if (page > 1) {
        page--;
        controller.loadFailed();
      } else {
        controller.refreshFailed();
      }
      showShortToast(e.toString());
    }
  }

  @override
  onLoading() {
    page++;
    onLoadRecord();
  }

  @override
  onRefresh() {
    page = 1;
    onLoadRecord();
  }
}
