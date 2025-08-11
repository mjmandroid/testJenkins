import 'package:desk_cloud/generated/json/base/json_convert_content.dart';
import 'package:desk_cloud/entity/socket_entity.dart';

SocketEntity $SocketEntityFromJson(Map<String, dynamic> json) {
  final SocketEntity socketEntity = SocketEntity();
  final String? token = jsonConvert.convert<String>(json['token']);
  if (token != null) {
    socketEntity.token = token;
  }
  final String? server = jsonConvert.convert<String>(json['server']);
  if (server != null) {
    socketEntity.server = server;
  }
  return socketEntity;
}

Map<String, dynamic> $SocketEntityToJson(SocketEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['token'] = entity.token;
  data['server'] = entity.server;
  return data;
}

extension SocketEntityExtension on SocketEntity {
  SocketEntity copyWith({
    String? token,
    String? server,
  }) {
    return SocketEntity()
      ..token = token ?? this.token
      ..server = server ?? this.server;
  }
}