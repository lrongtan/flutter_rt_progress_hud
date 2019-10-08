# rt_progress_hud 使用

快捷使用方式

纯文本使用  自动关闭
```
RTProgressHUD.showText(BuildContext context, String label);
```

菊花 + 文本使用  需要手动关闭
```
RTProgressHUD.showIndicator(BuildContext context, String label);
```
成功icon + 文本使用
```
RTProgressHUD.showSuccess(BuildContext context, String label);
```
警告icon + 文本使用
```
RTProgressHUD.showWarn(BuildContext context, String label);
```
失败icon + 文本使用
```
RTProgressHUD.showFail(BuildContext context, String label);
```
自定义widget
```
RTProgressHUD.showCustomWidget(BuildContext context, String label, Widget customWidget);
```
圆形进度条
```
RTProgressHUD.showRate(BuildContext context, String label, double rate);
```

链式调用
```RTProgressHUD.
instance.//全局单例
setStyle().//设置hud的风格
setLabel().//主标题
setDetailLabel().//副标题
setCustomWidget().//自定义组件
setRate().//进度条进度 0-1
show().//展示
scheduleDismiss()/dismiss();//延迟消失/马上消失

```

## 注意点

使用 flutter_screenutil 进行适配。如果项目没有使用flutter_screenutil。

需要额外配置
```
ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
```
如何使用flutter_screenutil

参考 https://github.com/OpenFlutter/flutter_screenutil/blob/master/README_CN.md



