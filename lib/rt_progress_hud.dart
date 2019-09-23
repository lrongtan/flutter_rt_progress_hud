library rt_progress_hud;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';


//菊花半径
const double _rtDefaultIndicatorRadius = 15.0;

//窗口颜色
const Color _rtDefaultBgColor = Colors.black12;

//视图颜色
const Color _rtDefaultContentColor = Colors.black54;

// 视图裁剪半径
const double _rtDefaultContentRadius = 10.0;

// 视图内边距
const double _rtDefaultContentPadding = 30;

// label 字体颜色
const Color _rtDefaultLabelColor = Colors.white;

// label 字体大小
const double _rtDefaultLabelFontsize = 32.0;

// label 字体行数
const int _rtDefaultLabelMaxLines = 2;

// detailsLabel 字体颜色
const Color _rtDefaultDetailsLabelColor = Colors.white;


// detailsLabel 字体大小
const double _rtDefaultDetailLabelFontsize = 30.0;


// detailsLabel 字体行数
const int _rtDefaultDetailLabelMaxLines = 10;

// content最大宽度 这个数据 用在 label 和 detailsLabel上 不包括边距
const double _rtDefaultContentMaxWidth = 500;

// content最小宽度 这个数据 用在 label 和 detailsLabel上 不包括边距
const double _rtDefaultContentMinWidth = 200;

//自动pop 的时间
const int _rtDefaultscheduleDismiss = 1500;

// content内容的内边距
const double _rtDefaultItemPadding = 20;

// 成功 失败等iconfont 或图片 的宽度
const double _rtDefaultStateIconWidth = 65;

// ios dialog 的 动画
final Animatable<double> _dialogScaleTween = Tween<double>(begin: 1.3, end: 1.0)
    .chain(CurveTween(curve: Curves.linearToEaseOut));
//const TextStyle _rtDefaultLabelFont = TextStyle(color: Colors.white,fontSize: );

//hud 的风格
enum HUDStyle {
  None,// 纯文本
  Indicator,// 菊花loading
  Success,//成功
  Fail,//失败
  Warn,//警告
  Custom,//自定义 。。。。未实现
}

class RTProgressHUD{
  
  factory RTProgressHUD() => _getInstance();

  static RTProgressHUD _instance;

  static RTProgressHUD get instance => _getInstance();

  static RTProgressHUD _getInstance(){
    if(_instance == null){
      _instance = RTProgressHUD._init();
    }
  }

  RTProgressHUD._init();

  OverlayEntry _overlayEntry;//实现在任意页面都能弹窗的组件

  RTProgressView _hudView;

  bool barrierDismissible = true;

  BuildContext _context;

  RTProgressHUD show(BuildContext context){
    _context = context;

    if(_overlayEntry == null){
      _overlayEntry = OverlayEntry(builder: (context){
        return Container();
      });
      Overlay.of(context).insert(_overlayEntry);
    }
  }


//  auto dismiss

  Timer _timer;
  void scheduleDismiss({Duration time = const Duration(milliseconds: _rtDefaultscheduleDismiss)}){
    if(_timer != null){
      _timer.cancel();
      _timer = null;
    }
    _timer = new Timer.periodic(time, (t){
      _timer.cancel();
      _timer = null;
      remove();
    });
  }

  void remove(){
    if(_context != null){
      _overlayEntry.remove();
      _overlayEntry = null;
    }
  }

  static void dismiss(){


  }
}


class RTProgressView extends StatefulWidget {

  HUDStyle mhudStyle;

  String mLabel;

  String mDetailsLabel;

  RTProgressView({this.mhudStyle, this.mLabel, this.mDetailsLabel});

  @override
  _RTProgressViewState createState() => _RTProgressViewState();
}

class _RTProgressViewState extends State<RTProgressView> with SingleTickerProviderStateMixin{

  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    );
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}




