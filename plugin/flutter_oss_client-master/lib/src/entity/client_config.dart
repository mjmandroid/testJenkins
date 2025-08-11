class ClientConfig{
  ///设置最大并发数，默认值5。
  int? maxConcurrentRequest;
  ///设置Socket层传输数据的超时时间，默认值60s。
  int? socketTimeout;
  ///设置建立连接的超时时间，默认值60s。
  int? connectionTimeout;
  ///设置日志文件大小，默认值5 MB。
  int? maxLogSize;
  ///请求失败后最大的重试次数。默认2次。
  int? maxErrorRetry;

  Map<String,dynamic> toJson(){
    return {
      'maxConcurrentRequest': maxConcurrentRequest,
      'socketTimeout': socketTimeout,
      'connectionTimeout': connectionTimeout,
      'maxLogSize': maxLogSize,
      'maxErrorRetry': maxErrorRetry
    };
  }
}