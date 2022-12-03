import 'dart:io';

import 'package:path/path.dart' as path;

main() async{
  String fontName ='TolyIcon';
  String fileName ='toly_icon';
  String resDir="assets/iconfont";//资源文件夹
  String outFile='lib/app/src/iconfont/$fileName.dart';//输出文件地址

  String result = """import 'package:flutter/widgets.dart';
//Power By 张风捷特烈--- Generated file. Do not edit.

class $fontName {

    $fontName._();
""";
  File fileCss = File(path.join(Directory.current.path,"$resDir/iconfont.css"));
  if (! await fileCss.exists()) return;

  String read = await fileCss.readAsString();

  RegExp exp = RegExp(r'\.icon\-(.*?):.*\s.*"\\(.*?)"');
  List<RegExpMatch> allMatches = exp.allMatches(read).toList();

  for (var match in allMatches) {
    String name = match.group(1)??'';
    String value = match.group(2)??'';
    result += "static const IconData " +
        name.replaceAll("-", "_") +
        " = IconData(" +
        "0x$value" +
        ", fontFamily: \"$fontName\");\n";
  }

  result+="}";
  fileCss.delete();//删除css文件

  File fileOut = File(path.join(Directory.current.path,"$outFile"));
  if(! await fileOut.exists()){
    await fileOut.create(recursive: true);
  }
  fileOut.writeAsString(result);//将代码写入dart文件

  String config="""
fonts:
  - family: $fontName
    fonts:
      - asset: """+"$resDir/iconfont.ttf";

  print("build OK:\n $config");
}