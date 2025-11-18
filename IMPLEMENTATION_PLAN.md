# Yisin 实施计划

## Stage 1: 项目基础架构与权限系统
**目标**: 建立macOS应用基础框架，实现权限请求系统
**状态**: ✅ Complete

**已完成**:
- ✅ 项目目录结构
- ✅ Swift Package 配置
- ✅ 菜单栏应用基础 (NSStatusBar)
- ✅ 辅助功能权限请求流程
- ✅ 设置管理器 (Keychain 集成)
- ✅ 极简设置界面
- ✅ Logo 图标设计 (SwiftUI Shape)
- ✅ 菜单栏图标状态系统

**交付物**:
- `YisinApp.swift` - 应用入口
- `AppDelegate.swift` - 应用生命周期管理
- `MenuBarController.swift` - 菜单栏控制
- `MenuBarIconView.swift` - 图标视图与动画
- `SettingsView.swift` - 设置界面
- `SettingsManager.swift` - 配置管理
- `Info.plist` - 权限配置

**成功标准**: ✅ 应用可启动，菜单栏图标显示，权限请求优雅呈现

---

## Stage 2: 全局快捷键与文本捕获
**目标**: 实现核心的快捷键监听和选中文本获取
**状态**: ✅ Complete

**已完成**:
- ✅ 全局快捷键注册系统 (Carbon API)
- ✅ 辅助功能 API 文本获取
- ✅ 快捷键录制器 UI 组件
- ✅ 快捷键动态更新
- ✅ 剪贴板备份恢复机制
- ✅ 菜单栏图标状态动画集成

**交付物**:
- `HotkeyManager.swift` - 快捷键管理
- `TextCaptureService.swift` - 文本捕获
- `HotkeyRecorderView.swift` - 快捷键录制器

**成功标准**: ✅ 按下快捷键能捕获任意应用的选中文本

---

## Stage 3: "光窗" - 悬浮翻译界面
**目标**: 实现动态、优雅的翻译结果展示窗口
**状态**: 📋 Not Started

**待实现**:
- [ ] 无边框半透明窗口
- [ ] Vibrancy 模糊效果
- [ ] 动态尺寸调整
- [ ] 语言切换交互
- [ ] 鼠标位置计算
- [ ] 优雅的淡入淡出动画

**交付物**:
- `TranslationWindow.swift` - 翻译窗口
- `TranslationResultView.swift` - 结果视图

**成功标准**: 窗口在鼠标附近优雅浮现，内容自适应，交互流畅

---

## Stage 4: AI 翻译引擎集成
**目标**: 接入 Gemini API，实现翻译核心逻辑
**状态**: 📋 Not Started

**待实现**:
- [ ] Gemini API 客户端
- [ ] 异步翻译请求
- [ ] 错误处理与重试
- [ ] 提示词模板系统
- [ ] 语言检测

**交付物**:
- `GeminiService.swift` - API 客户端
- `TranslationEngine.swift` - 翻译引擎
- `LanguageDetector.swift` - 语言检测

**成功标准**: 能使用用户 API Key 完成实际翻译，结果准确显示

---

## Stage 5: 历史记录与高级功能
**目标**: 完善历史记录和扩展功能
**状态**: 📋 Not Started

**待实现**:
- [ ] 翻译历史记录
- [ ] 历史记录查看界面
- [ ] 钉住模式
- [ ] 通知中心集成
- [ ] 菜单栏图标完整动画流程

**交付物**:
- `HistoryManager.swift` - 历史管理
- `HistoryView.swift` - 历史界面

**成功标准**: 所有设置可配置，图标动画优雅过渡，历史可查询

---

## Stage 6: 打磨与优化
**目标**: 细节打磨，性能优化，错误处理
**状态**: 📋 Not Started

**待实现**:
- [ ] 完整的错误处理
- [ ] 性能优化
- [ ] 动画细节调优
- [ ] 单元测试
- [ ] DMG 打包配置
- [ ] 用户文档

**交付物**:
- 完整的测试套件
- 打包脚本
- 用户指南

**成功标准**: 应用稳定流畅，符合 Apple HIG，可分发

---

## 技术栈确认

- ✅ Swift 5.9+
- ✅ SwiftUI + AppKit
- ✅ macOS 13.0+
- ✅ Keychain Services
- ✅ Accessibility APIs
- ✅ Gemini API

## 设计原则

- ✅ MUJI 质朴美学
- ✅ 瑞士国际主义秩序
- ✅ Apple HIG 合规
- ✅ 无装饰元素
- ✅ 代码自解释
