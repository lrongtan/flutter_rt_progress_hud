library rt_progress_hud;


//这边引入了flutter_screenutil进行屏幕适配。如果项目没有使用这个进行适配。需要在项目入口的第一个页面配置
//ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);



//想配一个自己的iconFont。但是package导入的时候只有代码导入进项目。暂时放弃。

import 'package:flutter_screenutil/flutter_screenutil.dart';
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
const double _rtDefaultContentPadding = 20;

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
const int _rtDefaultscheduleDismiss = 1000;

// content内容的内边距
const double _rtDefaultItemPadding = 15;

// content内容只有文本的内边距
const double _rtOnlyTextItemPadding = 10;


// 成功 失败等iconfont 或图片 的宽度
const double _rtDefaultStateIconWidth = 65;

// ios dialog 的 动画
final Animatable<double> _dialogScaleTween = Tween<double>(begin: 1.3, end: 1.0)
    .chain(CurveTween(curve: Curves.linearToEaseOut));
//const TextStyle _rtDefaultLabelFont = TextStyle(color: Colors.white,fontSize: );

//hud 的风格
enum HUDStyle {
  None, // 纯文本
  Indicator, // 菊花loading
  Success, //成功
  Fail, //失败
  Warn, //警告
  Custom, //自定义 。。。。未实现
}

class RTProgressHUD {
  factory RTProgressHUD() => _getInstance();

  static RTProgressHUD _instance;

  static RTProgressHUD get instance => _getInstance();

  RTProgressViewController _viewController;

  static RTProgressHUD _getInstance() {
    if (_instance == null) {
      _instance = RTProgressHUD._init();
    }
    if (_instance._viewController == null) {
      _instance._viewController =
          RTProgressViewController(RTProgressViewValue());
    }
    return _instance;
  }

  RTProgressHUD._init();

  OverlayEntry _overlayEntry; //实现在任意页面都能弹窗的组件

  bool barrierDismissible = true;

  BuildContext _context;

  RTProgressHUD show(BuildContext context) {
    _context = context;
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(builder: (context) {
        return RTProgressView(controller: _viewController,);
      });
      Overlay.of(context).insert(_overlayEntry);
    }
    return _instance;
  }

//  auto dismiss

  Timer _timer;

  void scheduleDismiss({Duration time =
  const Duration(milliseconds: _rtDefaultscheduleDismiss)}) {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    _timer = new Timer.periodic(time, (t) {
      _timer.cancel();
      _timer = null;
      _viewController.dismiss(remove: remove);
    });
  }

  void remove() {
    if (_context != null) {
      _overlayEntry.remove();
      _overlayEntry = null;
      _viewController.dispose();
      _viewController = null;
    }
  }

  static void dismiss() {
    if (_instance._timer != null) {
      _instance._timer.cancel();
      _instance._timer = null;
    }
    _instance._viewController.dismiss(remove: _instance.remove);
  }

  //  设置类型
  RTProgressHUD setStyle(HUDStyle style) {
    _viewController.hudStyle = style;
    return _instance;
  }

  //  设置文本
  RTProgressHUD setLabel(String label) {
    _viewController.label = label;
    return _instance;
  }

  //  设置副文本
  RTProgressHUD setDetailsLabel(String detailsLabel) {
    _viewController.detailLabel = detailsLabel;
    return _instance;
  }


  //  显示纯文本 自动dismiss
  static void showText(BuildContext context, String label) {
    _getInstance();
    _instance
        .setStyle(HUDStyle.None)
        .setLabel(label)
        .show(context)
        .scheduleDismiss();
  }

  //  菊花加载
  static void showIndicator(BuildContext context, String label) {
    _getInstance();
    _instance.setStyle(HUDStyle.Indicator).setLabel(label).show(context);
  }

  //成功加载
  static void showSuccess(BuildContext context, String label) {
    _getInstance();
    _instance
        .setStyle(HUDStyle.Success)
        .setLabel(label)
        .show(context)
        .scheduleDismiss();
  }

  //警告
  static void showWarn(BuildContext context, String label) {
    _getInstance();
    _instance
        .setStyle(HUDStyle.Warn)
        .setLabel(label)
        .show(context)
        .scheduleDismiss();
  }

  //失败加载
  static void showFail(BuildContext context, String label) {
    _getInstance();
    _instance
        .setStyle(HUDStyle.Fail)
        .setLabel(label)
        .show(context)
        .scheduleDismiss();
  }

}

class RTProgressView extends StatefulWidget {
  final RTProgressViewController controller;

  const RTProgressView({Key key, this.controller}) : super(key: key);

  @override
  _RTProgressViewState createState() => _RTProgressViewState();
}

class _RTProgressViewState extends State<RTProgressView>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    super.initState();
    _controller.forward();
    widget.controller._animationController = _controller;
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

//  Material 组件撑满整个屏幕
  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Container(
        padding: EdgeInsets.all(
          ScreenUtil().setWidth(widget.controller.hudStyle == HUDStyle.None
              ? 0
              : _rtDefaultContentPadding),
        ),
        decoration: BoxDecoration(
          color: _rtDefaultContentColor,
          borderRadius: BorderRadius.circular(
              widget.controller.hudStyle == HUDStyle.None
                  ? 5
                  : _rtDefaultContentRadius),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildContent(),
              _buildLabel(),
              _buildDetailLabel(),
            ],
          ),
        ),
      ),
    );

    content = ScaleTransition(scale: _controller, child: content,);

    content = Container(
      decoration: BoxDecoration(
          color: _rtDefaultBgColor
      ),
      child: content,
    );

    content = FadeTransition(opacity: _controller, child: content,);

    content = Material(
      type: MaterialType.transparency,
      child: content,
    );
    return content;
  }

  Widget _buildContent() {
    Widget content = Container(
      height: 0,
      width: 0,
    );

    if (widget.controller.hudStyle == HUDStyle.Indicator) {
      content = Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(_rtDefaultItemPadding)),
        child: CupertinoActivityIndicator(
          radius: _rtDefaultIndicatorRadius,
        ),
      );
    } else if (widget.controller.hudStyle == HUDStyle.None) {

    } else {
      Icon icon = Icon(Icons.check_circle,
        size: ScreenUtil().setWidth(_rtDefaultStateIconWidth),
        color: Colors.white,);
      if (widget.controller.hudStyle == HUDStyle.Success) {
        icon = Icon(Icons.check_circle_outline,
          size: ScreenUtil().setWidth(_rtDefaultStateIconWidth),
          color: Colors.white,);
      }
      if (widget.controller.hudStyle == HUDStyle.Warn) {
        icon = Icon(Icons.error_outline,
          size: ScreenUtil().setWidth(_rtDefaultStateIconWidth),
          color: Colors.white,);
      }
      if (widget.controller.hudStyle == HUDStyle.Fail) {
        icon = Icon(Icons.clear,
          size: ScreenUtil().setWidth(_rtDefaultStateIconWidth),
          color: Colors.white,);
      }
      content = Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(_rtDefaultItemPadding)),
        child: icon,
      );
    }

    return content;
  }

  Widget _buildLabel() {
    Widget label = Container(
      padding: EdgeInsets.all(
        widget.controller.hudStyle == HUDStyle.None ? ScreenUtil().setWidth(
            _rtOnlyTextItemPadding) :
        ScreenUtil().setWidth(_rtDefaultItemPadding),
      ),
      constraints: BoxConstraints(
        maxWidth:
        ScreenUtil().setWidth(_rtDefaultContentMaxWidth),
        minWidth:
        ScreenUtil().setWidth(_rtDefaultContentMinWidth),
      ),
      child: Text(
        widget.controller.label ?? "",
        style: TextStyle(
          color: _rtDefaultLabelColor,
          fontSize:
          ScreenUtil().setWidth(_rtDefaultLabelFontsize),
        ),
        textAlign: TextAlign.center,
        maxLines: _rtDefaultLabelMaxLines,
      ),
    );

    label = Offstage(
      offstage: widget.controller.label == null ? true : false,
      child: label,
    );


    return label;
  }

  Widget _buildDetailLabel() {
    Widget detailLabel = Container(
      padding: EdgeInsets.all(
        widget.controller.hudStyle == HUDStyle.None ? ScreenUtil().setWidth(
            _rtOnlyTextItemPadding) :
        ScreenUtil().setWidth(_rtDefaultItemPadding),
      ),
      constraints: BoxConstraints(
        maxWidth:
        ScreenUtil().setWidth(_rtDefaultContentMaxWidth),
        minWidth:
        ScreenUtil().setWidth(_rtDefaultContentMinWidth),
      ),
      child: Text(
        widget.controller.detailLabel ?? "",
        style: TextStyle(
            fontSize: ScreenUtil()
                .setWidth(_rtDefaultDetailLabelFontsize),
            color: _rtDefaultDetailsLabelColor),
        maxLines: _rtDefaultDetailLabelMaxLines,
        textAlign: TextAlign.center,
      ),
    );

    detailLabel = Offstage(
      offstage: widget.controller.detailLabel == null ? true : false,
      child: detailLabel,
    );
    return detailLabel;
  }
}


// 内容显示对象。
class RTProgressViewValue {
  HUDStyle hudStyle;
  String mLabel;
  String mDetailsLabel;

  RTProgressViewValue({this.hudStyle, this.mLabel, this.mDetailsLabel});

  RTProgressViewValue copyWith({
    HUDStyle style,
    String label,
    String detailLabel,
  }) {
    return RTProgressViewValue(
        hudStyle: style ?? this.hudStyle,
        mLabel: label ?? this.mLabel,
        mDetailsLabel: detailLabel ?? this.mDetailsLabel);
  }
}

//内容显示控制器
class RTProgressViewController extends ValueNotifier<RTProgressViewValue> {

  RTProgressViewController(RTProgressViewValue value) : super(value);

  AnimationController _animationController;

  HUDStyle get hudStyle => value.hudStyle;

  set hudStyle(HUDStyle newStyle) {
    value = value.copyWith(style: newStyle);
  }

  String get label => value.mLabel;

  set label(String newLabel) {
    value = value.copyWith(label: newLabel);
  }

  String get detailLabel => value.mDetailsLabel;

  set detailLabel(String newDetailLabel) {
    value = value.copyWith(detailLabel: newDetailLabel);
  }

  void dismiss({Function remove}) {
    _animationController.reverse();
    _animationController.addListener(() {
      if (_animationController.value == 0) {
        remove();
      }
    });
  }
}
