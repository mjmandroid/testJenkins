class ClientSts{
  String accessKeyId;
  String accessKeySecret;
  String securityToken;
  ClientSts({required this.accessKeyId,required this.accessKeySecret,required this.securityToken});

  Map<String,dynamic> toJson(){
    return {
      'accessKeyId': accessKeyId,
      'accessKeySecret': accessKeySecret,
      'securityToken': securityToken
    };
  }
}