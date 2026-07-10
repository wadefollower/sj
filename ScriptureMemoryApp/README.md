# ScriptureMemoryApp

一个不需要登录、不需要服务器的 iPhone 经文背诵 App 原型。

## 第一版功能

- 今日背诵：自动推荐还没有完成的经文
- 经文库：按主题浏览示例经文
- 背诵模式：全文、遮挡关键词、首字提示、自测输入
- 收藏：经文收藏保存在本地
- 进度：背诵次数、上次复习时间、已完成状态保存在本地

## 技术选择

- SwiftUI
- 本地 JSON 经文数据
- UserDefaults + Codable 本地保存收藏和进度
- iOS 17+

## 打开方式

用 Xcode 打开：

```sh
open ScriptureMemoryApp.xcodeproj
```

然后选择 iPhone 模拟器运行。

当前项目已可用 Xcode 16.4 构建验证；如果要运行 iOS 模拟器，需要安装与当前 Xcode 匹配的 Simulator Runtime。

## PWA 原型

`prototype/` 目录现在是可部署的 PWA 版本，可以先不走 App Store。

本地预览：

```sh
cd prototype
python3 -m http.server 4173
```

然后打开：

```text
http://localhost:4173
```

部署到 GitHub Pages 或其他 HTTPS 静态站点后，iPhone 用户可以用 Safari 打开，并通过“分享 -> 添加到主屏幕”安装。

PWA 版本支持离线缓存、内置经文、自定义经文、收藏、进度、语言、字号本地保存、浏览器朗读经文，以及自测正确率。内置经文包含用户提供的 NIV 英文对照；公开分发前仍建议确认 NIV 使用授权。

## 经文版权说明

项目里只放了少量“和合本”示例经文，用于产品原型。正式上架前建议确认所使用文本版本的版权与授权范围，特别是不要把“和合本修订版”等仍受版权保护的版本当作可自由内置文本。
