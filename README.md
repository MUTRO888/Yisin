# 🍵 Yisin - 优雅的 macOS 翻译伴侣

> 一个极简、高效的 macOS 菜单栏翻译应用，采用 MUJI 设计哲学

## ✨ 核心特性

- 🎯 **快捷键翻译** - 按 `⌘⌥T` 立即打开翻译窗口
- 📝 **灵活输入** - 支持粘贴、输入或编辑文本
- 🌐 **双向翻译** - 自动检测语言，支持中英文互译
- 🎨 **优雅界面** - MUJI 极简风格，Vibrancy 模糊效果
- ⚡ **无权限烦恼** - 不需要辅助功能权限
- 🔐 **安全存储** - API Key 保存在 macOS Keychain
- 🎭 **背景化存在** - 无 Dock 图标，只在菜单栏显示

## 🚀 快速开始

### 1. 获取 API Key

访问 [Google Gemini API](https://makersuite.google.com/app/apikey) 获取免费 API Key

### 2. 打开项目

```bash
cd /Users/mutro/Desktop/开发/Yisin
open Package.swift -a Xcode
```

### 3. 运行应用

在 Xcode 中按 `⌘R` 运行

### 4. 配置 API Key

1. 点击菜单栏的 Yisin 图标
2. 选择"设置"
3. 粘贴您的 API Key

### 5. 开始翻译

1. 按 `⌘⌥T` 打开输入窗口
2. 输入或粘贴要翻译的文本
3. 按 `⌘Enter` 开始翻译
4. 查看结果，点击复制

---

## ⌨️ 快捷键

| 快捷键 | 功能 |
|--------|------|
| `⌘⌥T` | 打开翻译输入窗口 |
| `⌘Enter` | 开始翻译 |
| `ESC` | 取消/关闭窗口 |
| `⌘,` | 打开设置 |

---

## 📋 交互流程

```
按快捷键 ⌘⌥T
    ↓
弹出输入窗口（自动粘贴剪贴板）
    ↓
输入或编辑文本
    ↓
按 ⌘Enter 翻译
    ↓
显示翻译结果（光窗）
    ↓
点击复制或按 ESC 关闭
```

---

## 🎨 设计特点

### MUJI 质朴美学
- 去除一切装饰元素
- 只保留本质功能
- 清晰的信息层级

### 瑞士国际主义
- 极简的排版
- 均衡的布局
- 无衬线字体

### Apple HIG 合规
- 原生 macOS 体验
- 系统级快捷键
- 标准交互模式

---

## 📁 项目结构

```
Yisin/
├── Sources/
│   ├── YisinApp.swift              # 应用入口
│   ├── MenuBarController.swift      # 菜单栏控制
│   ├── MenuBarIconView.swift        # 图标动画
│   ├── SettingsView.swift           # 设置界面
│   ├── SettingsManager.swift        # 配置管理
│   ├── HotkeyManager.swift          # 快捷键管理
│   ├── HotkeyRecorderView.swift     # 快捷键录制器
│   ├── TranslationInputWindow.swift # 输入窗口 ⭐
│   ├── TranslationWindow.swift      # 结果窗口
│   ├── TranslationResultView.swift  # 结果视图
│   ├── GeminiService.swift          # Gemini API 客户端
│   ├── TranslationEngine.swift      # 翻译引擎
│   └── LanguageDetector.swift       # 语言检测
├── Package.swift                    # Swift Package 配置
├── QUICK_TEST.md                    # 快速测试参考
├── TEST_NEW_VERSION.md              # 详细测试指南
└── README.md                        # 本文件
```

---

## 🛠 技术栈

- **语言**: Swift 5.9+
- **UI**: SwiftUI + AppKit
- **系统**: macOS 13.0+
- **API**: Google Gemini
- **安全**: Keychain Services
- **并发**: async/await
- **语言检测**: NaturalLanguage Framework

---

## 🧪 测试

### 快速测试（3 分钟）

参考 [QUICK_TEST.md](QUICK_TEST.md)

### 详细测试（15 分钟）

参考 [TEST_NEW_VERSION.md](TEST_NEW_VERSION.md)

---

## 📊 开发进度

| Stage | 功能 | 状态 |
|-------|------|------|
| 1 | 项目基础架构 | ✅ Complete |
| 2 | 快捷键系统 | ✅ Complete |
| 3 | 悬浮翻译窗口 | ✅ Complete |
| 4 | AI 翻译引擎 | ✅ Complete |
| 5 | 历史记录 | 📋 Optional |
| 6 | 打磨优化 | 📋 Optional |

---

## 🎯 核心功能完成度

- ✅ 菜单栏应用架构
- ✅ 全局快捷键注册
- ✅ 输入窗口交互
- ✅ 自动粘贴剪贴板
- ✅ Gemini API 集成
- ✅ 语言自动检测
- ✅ 中英文双向翻译
- ✅ 优雅的悬浮窗口
- ✅ 菜单栏图标动画
- ✅ 快捷键自定义

---

## 💡 设计哲学

> "最好的工具是背景化的存在"

Yisin 遵循这一原则：
- 无 Dock 图标（不打扰）
- 快速响应（不等待）
- 简洁界面（不复杂）
- 自动功能（不手动）

---

## 🔗 相关链接

- [GitHub 仓库](https://github.com/MUTRO888/Yisin)
- [Gemini API](https://makersuite.google.com/app/apikey)
- [MUJI 设计哲学](https://www.muji.com)

---

## 📝 许可证

MIT License

---

## 🙏 致谢

设计灵感来自：
- Kenya Hara（MUJI 首席设计师）
- 瑞士国际主义设计
- Apple Human Interface Guidelines

---

**准备好体验优雅的翻译了吗？** 🍵

按 `⌘R` 在 Xcode 中运行，然后按 `⌘⌥T` 开始翻译！
