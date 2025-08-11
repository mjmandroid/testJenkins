import 'dart:convert';

import 'package:desk_cloud/alert/normal_input_sheet.dart';
import 'package:desk_cloud/entity/disk_file_entity.dart';
import 'package:desk_cloud/entity/share_data_entity.dart';
import 'package:desk_cloud/utils/export.dart';

class UserBaseMixin extends BaseLogic{}

mixin UserOptionMixin on UserBaseMixin{
  
  Future<bool> deleteFile(List<DiskFileEntity> diskFiles) async {
    showLoading();
    try{
      await ApiNet.request(Api.fileDelete,data: {
        'del_data': jsonEncode(diskFiles.map((e) => {'id':e.id,'is_dir':e.isDir,'name':e.title}).toList())
      });
      dismissLoading();
      showShortToast('内容已删除，可在回收站中查看');
      return true;
    }catch(e){
      dismissLoading();
      showShortToast(e.toString());
      return false;
    }
  }

  Future<bool> renameFile(DiskFileEntity diskFile,{String? name}) async {
    if (name?.isNotEmpty != true) return false;
    showLoading();
    try{
      await ApiNet.request(Api.renameFile,data: {
        'id':diskFile.id,
        'is_dir':diskFile.isDir,
        'name': name
      });
      dismissLoading();
      showShortToast('重命名成功');
      return true;
    }catch(e){
      dismissLoading();
      showShortToast(e.toString());
      return false;
    }
  }

  Future<ShareDataEntity?> diskCodeCreate(List<DiskFileEntity> diskFiles,{required String day,String codeType = '1',String? codes}) async {
    showLoading();
    try{
      var base = await ApiNet.request<ShareDataEntity>(Api.diskCodeCreate,data: {
        'ids': jsonEncode(diskFiles.map((e) => {'id':e.id,'is_dir':e.isDir,'name':e.title}).toList()),
        'day': day,
        if (codes != null)
          'codes': codes,
        'code_type': codeType
      });
      dismissLoading();
      return base.data;
    }catch(e){
      dismissLoading();
      showShortToast(e.toString());
      return null;
    }
  }

  Future<bool> fileDetail(DiskFileEntity diskFile) async {
    showLoading();
    try{
      await ApiNet.request(Api.diskDetail,data: {
        'file_id': diskFile.id
      });
      dismissLoading();
      return true;
    }catch(e){
      dismissLoading();
      showShortToast(e.toString());
      return false;
    }
  }

  Future<bool> diskMove(List<DiskFileEntity> diskFiles,{required int targetDirId}) async {
    showLoading();
    try{
      await ApiNet.request(Api.diskMove,data: {
        'ids': diskFiles.map((e) => '${e.id ?? 0}').join(','),
        'dir_id': targetDirId
      });
      showShortToast('移动成功');
      dismissLoading();
      return true;
    }catch(e){
      dismissLoading();
      showShortToast(e.toString());
      return false;
    }
  }

  Future<bool> createDir(int id)async{
    var r = await showNormalInputSheet(title: '新建文件夹',hint: '请输入文件夹名');
    if (r == null) return false;
    if (r.isEmpty) {
      showShortToast('请输入文件夹名');
      return false;
    }
    try{
      showLoading();
      var base = await ApiNet.request(Api.addDir,data: {
        'pid': id,
        'name': r
      });
      if (base.code == 200) {
        showShortToast('新建成功');
      }
      dismissLoading();
      return true;
    }catch(e){
      dismissLoading();
      showShortToast(e.toString());
      return false;
    }
  }
}