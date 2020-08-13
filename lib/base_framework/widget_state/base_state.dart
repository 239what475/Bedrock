


import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bedrock/base_framework/ui/behavior/over_scroll_behavior.dart';
import 'package:flutter_bedrock/base_framework/ui/widget/progress_widget.dart';
import 'package:flutter_bedrock/base_framework/utils/image_helper.dart';
import 'package:oktoast/oktoast.dart';



abstract class BaseState<T extends StatefulWidget> extends State<T>  {

  double marginLeft = 0.0;
  double dragPosition = 0.0;
  bool slideOutActive = false;

  ///所有页面请务必使用此方法作为根布局
  ///切换状态栏 模式：light or dark
  ///应在根位置调用此方法
  ///needSlideOut是否支持右滑返回、如果整个项目不需要，可以配置默认值为false
  Widget switchStatusBar2Dark({bool isSetDark = true,@required Widget child,
    ///适配、
    EdgeInsets edgeInsets,bool needSlideOut = false}){
    if(! needSlideOut){
      return AnnotatedRegion(
          value: isSetDark ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
          child: Material(
            color: Colors.white,
            child: Padding(
              padding: edgeInsets??EdgeInsets.only(bottom: ScreenUtil.getInstance().bottomBarHeight),
              child: child,
            ),
          )
      );

    }
    return AnnotatedRegion(
      value: isSetDark ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: edgeInsets??EdgeInsets.only(bottom: ScreenUtil.getInstance().bottomBarHeight),
          child: GestureDetector(
            onHorizontalDragStart: (dragStart){
              slideOutActive = dragStart.globalPosition.dx < (getScreenWidth() / 10);

            },
            onHorizontalDragUpdate: (dragDetails){
              if(!slideOutActive) return;
              marginLeft = dragDetails.globalPosition.dx;
              dragPosition = marginLeft;
              //if(marLeft > 250) return;
              if(marginLeft < getWidthPx(50)) marginLeft = 0;
              setState(() {

              });
            },
            onHorizontalDragEnd: (dragEnd){
              if(dragPosition > getScreenWidth()/5){
                Navigator.of(context).pop();
              }else{
                marginLeft = 0.0;
                setState(() {

                });
              }
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.only(left: marginLeft),
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: child,
              ),
            ),

          ),
        ),
      )
    );
  }


  ///去掉 scroll view的 水印  e.g : listView scrollView
  ///当滑动到顶部或者底部时，继续拖动出现的蓝色水印
  Widget getNoInkWellListView({@required Widget scrollView}){
    return ScrollConfiguration(
      behavior: OverScrollBehavior(),
      child: scrollView,
    );
  }


  /// 一般页面的通用APP BAR 具体根据项目需求调整
  Widget commonAppBar({Widget leftWidget,String title,List<Widget> rightWidget ,
    Color bgColor = Colors.white,@required double leftPadding,@required double rightPadding}){
    return Container(
      width: getWidthPx(750),
      height: getHeightPx(115),
      color: bgColor??Color.fromRGBO(241, 241, 241, 1),
      padding: EdgeInsets.only(bottom: getHeightPx(10),left: leftPadding,right: rightPadding),
      alignment: Alignment.bottomCenter,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          Positioned(
            left: 0,
            child: leftWidget ?? Container(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Visibility(
              visible:  title != null,
              child: Text(
                "$title",
                style: TextStyle(fontSize: getSp(36),color: Colors.black,
                    decoration: TextDecoration.none),
              ),
            ),
          ),
          if(rightWidget != null)
            ...rightWidget,
        ],
      ),
    );
  }

  ///通用APP bar 统一后退键
  Widget buildAppBarLeft(){
    return GestureDetector(
      onTap: (){
        if(Navigator.of(context).canPop()){
          Navigator.of(context).pop();
        }else{
          ///增加需要的提示信息
        }

      },
      child: Container(
        color: Colors.white,
        width: getWidthPx(150),
        height: getHeightPx(90),
        alignment: Alignment.bottomLeft,
        child: Image.asset(ImageHelper.wrapAssetsIcon("icon_back_black"),width: getWidthPx(17),height: getHeightPx(32),),
      ),
    );
  }


  ///占位widget
  Widget getSizeBox({double width = 1,double height = 1}){
    return SizedBox(
      width: width,
      height: height,
    );
  }




  /// current widget is visible and focusable if is true;
  bool isResumed = true;

  ///
  bool isInactive = true;

  ///cant not interact with user
  bool isPause = false;


  ///生命周期变化时回调
//  resumed:应用可见并可响应用户操作
//  inactive:用户可见，但不可响应用户操作
//  paused:已经暂停了，用户不可见、不可操作
//  suspending：应用被挂起，此状态IOS永远不会回调

  /// just trigger at user is pressing home or back button;
//  @override
//  void didChangeAppLifecycleState(AppLifecycleState state) {
//    isResumed = state == AppLifecycleState.resumed;
//
//    isInactive = state == AppLifecycleState.inactive;
//    isPause = state == AppLifecycleState.paused;
//
//  }




  /*
  * size adapter with tool ScreenUtil
  *
  * */

  ///得到适配后的高度
  double getHeightPx(double height) => ScreenUtil.getInstance().getHeightPx
    (height);
  ///得到适配后的宽度
  double getWidthPx(double width) => ScreenUtil.getInstance().getWidthPx(width);

  ///屏幕宽度
  double getScreenWidth()=>ScreenUtil.getInstance().screenWidth;
  ///屏幕高度
  double getScreenHeight()=>ScreenUtil.getInstance().screenHeight;


  //目前仅对于手机： 因为手机大多数情况下是长度变化较大，
  // 所以以高度来算出半径，保证异形屏的弧度不会缩小
  //有其他需求，还需要重改
  /// 得到适配后的圆角半径
  double getRadiusFromHeight(double radius) => ScreenUtil.getInstance()
      .getHeightPx(radius) ;
  ///得到适配后的字号
  double getSp(double fontSize) => ScreenUtil.getInstance().getSp(fontSize);

  ///目前webview插件主要有两种，就当前版本介绍一下：
  ///  1、webview_flutter ^0.3.21
  ///     不支持html富文本、网页加载导致滚动异常 (如果遇到，使用wrapWebView() 方法可以解决)
  ///  2、flutter_webview_plugin  ^0.3.11
  ///     支持html富文本、但是会有web浮层导致遮盖其他原生页面（滑动退出页面时即可发现）


  ///解决 webview_flutter 滚动问题 update:解决不了
//  Widget wrapWebView(Widget webView){
//    return ListView(
//      padding: EdgeInsets.all(0),
//      children: <Widget>[
//        SizedBox.fromSize(
//          size: Size(100, 1000),
//          child: webView,
//        )
//      ],
//    );
//  }

  ///在页面上方显示一个 loading widget
  ///共有两种方法，showProgressDialog是其中一种
  ///具体参见 : progress_widget.dart
  DialogLoadingController _dialogLoadingController;
  showProgressDialog({Widget progress,
    Color bgColor,}){
    if(_dialogLoadingController == null){
      _dialogLoadingController = DialogLoadingController();
      Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (ctx,animation,secondAnimation){
            return LoadingProgress(controller: _dialogLoadingController
              ,progress: progress,bgColor: bgColor,);
          }
      ));
    }
  }

  dismissProgressDialog(){
    _dialogLoadingController?.dismissDialog();
    _dialogLoadingController = null;
  }
}