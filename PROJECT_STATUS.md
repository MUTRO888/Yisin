# Yisin 项目状态

## 当前进度

### ✅ Stage 1: 项目基础架构 (已完成)

**已实现的核心功能**:

1. **菜单栏应用架构**
   - 应用以 `.accessory` 模式运行（无 Dock 图标）
   - 菜单栏图标集成
   - 右键菜单（设置、退出）

2. **权限管理**
   - 辅助功能权限自动检测
   - 优雅的权限请求对话框
   - 系统设置快速跳转

3. **设置系统**
   - Keychain 安全存储 API Key
   - UserDefaults 持久化配置
   - 极简设置界面（MUJI 风格）

4. **视觉设计**
   - Yisin Logo 作为 SwiftUI Shape 实现
   - 菜单栏图标状态系统（待机/聆听/思考/完成）
   - 呼吸动画和旋转动画

## 如何运行

### 在 Xcode 中打开项目

```bash
cd /Users/mutro/Desktop/开发/Yisin
open Package.swift -a Xcode
```

### 构建并运行

1. 在 Xcode 中选择 `Yisin` scheme
2. 选择 "My Mac" 作为目标设备
3. 点击 Run (⌘R)

### 首次运行

应用启动后会：
1. 在菜单栏显示 Yisin 图标
2. 请求辅助功能权限
3. 点击图标可打开设置窗口

## 项目结构

```
Yisin/
├── Package.swift                    # Swift Package 配置
├── IMPLEMENTATION_PLAN.md           # 详细实施计划
├── Yisin/
│   ├── Sources/
│   │   ├── YisinApp.swift          # 应用入口
│   │   ├── MenuBarController.swift  # 菜单栏控制
│   │   ├── MenuBarIconView.swift    # 图标视图
│   │   ├── SettingsView.swift       # 设置界面
│   │   └── SettingsManager.swift    # 配置管理
│   ├── Resources/
│   │   └── Info.plist              # 应用配置
│   └── Assets.xcassets/            # 资源文件
```

## 下一步：Stage 2

### 目标：全局快捷键与文本捕获

**待实现功能**:
1. 全局快捷键监听（使用 NSEvent 或 Carbon API）
2. 选中文本捕获（使用 Accessibility API）
3. 快捷键录制器 UI
4. 快捷键冲突检测

**预计交付**:
- `HotkeyManager.swift` - 快捷键管理
- `TextCaptureService.swift` - 文本捕获服务
- `HotkeyRecorderView.swift` - 快捷键录制器

## 技术栈

- **语言**: Swift 5.9+
- **框架**: SwiftUI + AppKit
- **最低系统**: macOS 13.0 (Ventura)
- **API**: Google Gemini
- **安全**: Keychain Services
- **权限**: Accessibility APIs

## 设计哲学

> "最好的工具是背景化的存在"

Yisin 遵循：
- **MUJI 质朴美学** - 去除装饰，只留本质
- **瑞士国际主义** - 清晰的信息层级
- **Apple HIG** - 原生 macOS 体验

## Git 仓库

- **远程**: https://github.com/MUTRO888/Yisin.git
- **分支**: main
- **最新提交**: Stage 1 Complete

## 注意事项

1. **权限要求**: 应用需要辅助功能权限才能捕获文本
2. **API Key**: 需要在设置中配置 Gemini API Key
3. **开发环境**: 需要 Xcode 15.0+ 和 macOS 13.0+

---

**更新时间**: 2024
**状态**: Stage 1 ✅ | Stage 2 🚧
