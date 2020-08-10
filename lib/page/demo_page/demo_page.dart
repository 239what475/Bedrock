/*
* Author : LiJiqqi
* Date : 2020/5/28
*/


import 'package:flutter/material.dart';
import 'package:flutter_bedrock/base_framework/config/router_manager.dart';
import 'package:flutter_bedrock/base_framework/widget_state/base_state.dart';
import 'package:flutter_bedrock/service_api/bedrock_repository_proxy.dart';

///demo，代码分包比较随意

class DemoPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return DemoPageState();
  }

}

class DemoPageState extends BaseState<DemoPage> {

  final String htmlData = """
        <div>
          <h1>Demo Page</h1>
          <p>This is a fantastic product that you should buy!</p>
          <h3>Features</h3>
          <ul>
            <li>It actually works</li>
            <li>It exists</li>
            <li>It doesn't cost much!</li>
          </ul>
          <!--You can pretty much put any html in here!-->
        </div>
      """;

  @override
  Widget build(BuildContext context) {

    return switchStatusBar2Dark(child: Container(
      width: getWidthPx(750),height: getHeightPx(1334),
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            getSizeBox(height: getWidthPx(100)),
            buildIntro("API请求的异常捕获和处理DEMO"),
            RaisedButton(
              child: Text("demo handle exception",style: TextStyle(color: Colors.black),),
              onPressed: (){
                Navigator.of(context).pushNamed(RouteName.demo_exception_page);
              },
            ),
            getSizeBox(height: getWidthPx(40)),
            buildIntro("路由丢失DEMO"),
            RaisedButton(
              child: Text("route missing",style: TextStyle(color: Colors.black),),
              onPressed: (){
                Navigator.of(context).pushNamed("missing");
              },
            ),
            getSizeBox(height: getHeightPx(40)),
            buildIntro("综合性框架功能演示DEMO"),
            RaisedButton(
              child: Text("main page",style: TextStyle(color: Colors.black),),
              onPressed: (){
                Navigator.of(context).pushNamed(RouteName.main_page);
              },
            ),
            getSizeBox(height: getHeightPx(40)),
            buildIntro("左侧滑动返回上一页"),
            RaisedButton(
              child: Text("left slide to pop page",style: TextStyle(color: Colors.black),),
              onPressed: (){
                Navigator.of(context).pushNamed(RouteName.slide_out_page);
              },
            ),
            getSizeBox(height: getHeightPx(40)),
            buildIntro("web/html DEMO"),
            RaisedButton(
              child: Text("web page",style: TextStyle(color: Colors.black),),
              onPressed: (){
                String url = 'https://github.com/bladeofgod/Bedrock';
                Navigator.of(context).pushNamed(RouteName.web_page
                    ,arguments:{'url':url} );
              },
            ),
            getSizeBox(height: getHeightPx(20)),
            RaisedButton(
              child: Text("html page",style: TextStyle(color: Colors.black),),
              onPressed: (){
                Navigator.of(context).pushNamed(RouteName.html_page,
                arguments: {'data':htmlData});
              },
            ),
            getSizeBox(height: getHeightPx(40)),
            buildIntro("图片相关 DEMO"),
            RaisedButton(
              child: Text("image page",style: TextStyle(color: Colors.black),),
              onPressed: (){
                Navigator.of(context).pushNamed(RouteName.pick_image_page,);
              },
            ),
            getSizeBox(height: getHeightPx(40)),
            buildIntro("页面跳转动画 DEMO"),
            RaisedButton(
              child: Text("route animation page",style: TextStyle(color: Colors.black),),
              onPressed: (){
                Navigator.of(context).pushNamed(RouteName.route_anim_page,);
              },
            ),
            getSizeBox(height: getHeightPx(40)),
            buildIntro("国际化 DEMO"),
            RaisedButton(
              child: Text("i10l page",style: TextStyle(color: Colors.black),),
              onPressed: (){
                Navigator.of(context).pushNamed(RouteName.local_i10l_page,);
              },
            ),
            getSizeBox(height: getHeightPx(40)),
            buildIntro("实验室 DEMO"),
            RaisedButton(
              child: Text("laboratory page",style: TextStyle(color: Colors.black),),
              onPressed: (){
                Navigator.of(context).pushNamed(RouteName.demo_other_page,);
              },
            ),
            getSizeBox(height: getHeightPx(40)),
            buildIntro("dialog 式 loading 演示"),
            RaisedButton(
              child: Text("dialog progress page",style: TextStyle(color: Colors.black),),
              onPressed: (){
                showProgressDialog();
                Future.delayed(Duration(seconds: 2)).then((value) => dismissProgressDialog());
              },
            ),
            getSizeBox(height: getHeightPx(40)),
          ],
        ),
      ),
    ));
  }

  Widget buildIntro(String str){
    return Text(str,style: TextStyle(color: Colors.black,fontSize: getSp(28)),);
  }
}