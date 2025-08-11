import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quick_toast/quick_toast.dart';
import 'package:unrar/unrar.dart';

void main() {
    runApp(const MyApp());
}

class MyApp extends StatefulWidget {
    const MyApp({super.key});

    @override
    State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 

    List<String> files = [
        "https://image.yyf2024.com/manghe/476d1ca8b2380547307b37e2985c8089.rar", // 无密码
        "https://image.yyf2024.com/manghe/a2993082d08842b80e24e6c79600c9fd.rar", // 无密码
    ];


    String download = "";
    String password = "";

    List<String> status = [];


    TextEditingController downloadController = TextEditingController();
    TextEditingController passwordController = TextEditingController();




    @override
    void initState() {
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            theme: ThemeData(
                primaryColor: Colors.blue
            ),
            builder: QuickToast.init(),
            home: Scaffold(
                appBar: AppBar(
                    title: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text("RAR文件解压", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),),
                            Text("支持RAR5文件解压", style: TextStyle(fontSize: 12, color: Colors.black54)),
                        ],
                    ),
                ),
                body: ListView(
                    children: [


                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                            child: Column(
                                children: [
                                    TextField(
                                        controller: downloadController,
                                        decoration: const InputDecoration(
                                            labelText: "输入文件下载地址"
                                        ),

                                        onChanged: (value) {
                                            download = value;
                                            setState(() { });
                                        },
                                    ),

                                    const SizedBox(height: 15),

                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                            InkWell(
                                                child: const Text("测试文件1", style: TextStyle(fontSize: 14, color: Colors.blue)),
                                                onTap: () {
                                                    downloadController.text = files[0];
                                                    passwordController.text = "";
                                                    download = files[0];
                                                    password = "";
                                                },
                                            ),
                                            const SizedBox(width: 30),
                                            InkWell(
                                                child: const Text("测试文件2(带密码)", style: TextStyle(fontSize: 14, color: Colors.blue)),
                                                onTap: () {
                                                    downloadController.text = files[1];
                                                    passwordController.text = "123456";
                                                    download = files[1];
                                                    password = "123456";
                                                },
                                            ),
                                        ],
                                    )
                                ],
                            ),
                        ),

                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                            child: Column(
                                children: [
                                    TextField(
                                        controller: passwordController,
                                        decoration: const InputDecoration(
                                            labelText: "解压密码",
                                            helperText: "留空则不需要解压密码"
                                        ),

                                        onChanged: (value) {
                                            password = value;
                                            setState(() { });
                                        },
                                    ),
                                ],
                            ),
                        ),

                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                            child: MaterialButton(
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                color: Colors.blueAccent,
                                onPressed: () async {
                                    status = [];

                                    if(download == ""){
                                        status.add("文件下载地址为空下载失败");
                                        setState(() {});
                                        return;
                                    }

                                    status.add("开始下载文件 $download");
                                    status.add("当前解压密码 $password");

                                    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();


                                    DateTime dateTime = DateTime.now();
                                    int timestampInSeconds = dateTime.millisecondsSinceEpoch;

                                    status.add("当前程序路径 ${appDocumentsDir.path}");

                                    String filePath = "${appDocumentsDir.path}/$timestampInSeconds.rar";

                                    QuickToast.showLoading(status: '正在下载');
                                    try {
                                        Dio dio = Dio();
                                        await dio.download(download, filePath,onReceiveProgress: (int count, int total){
                                            QuickToast.showProgress(count/total, status: '下载中.');
                                        });
                                        QuickToast.dismiss();
                                    } on DioException catch (e) {
                                        status.add("文件下载失败 $e");
                                        QuickToast.dismiss();
                                    }

                                    status.add("下载完成 \n保存路径-> $filePath");

                                    Directory directory = Directory("${appDocumentsDir.path}/$timestampInSeconds");
                                    await directory.create();

                                    setState(() {});

                                    try {
                                        var result = await Unrar.extractRAR(
                                            filePath: filePath,
                                            destinationPath: directory.path,
                                            password: password
                                        );

                                        status.add("解压结果\n" + result.toString());

                                        setState(() {});

                                        status.add("解压完成 \n解压路径-> ${directory.path}");


                                        // 获取目录下文件
                                        List<FileSystemEntity> fileList = directory.listSync(recursive: false);

                                        status.add("文件信息:");
                                        for (var file in fileList) {
                                            status.add("${file.path} \n");
                                        }
                                        setState(() {});
                                    }catch (e){
                                        print("解压失败" + e.toString());
                                        setState(() {});
                                    }

                                }, 
                                child: const Text("开始解压文件", style: TextStyle(fontSize: 18, color: Colors.white),)
                            ),
                        ),

                        Container(
                            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: const Color(0xFFF1F1F1),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: status.length, 
                                itemBuilder: (BuildContext context, int index) => Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: Text(status[index], style: const TextStyle(fontSize: 12, color: Colors.black54),),
                                ),
                            )
                        ),



                    ],
                ),
            ),
        );
    }
}
