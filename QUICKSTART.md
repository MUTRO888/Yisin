# Yisin 快速启动指南

## 🚀 立即开始

### 1. 打开项目

```bash
cd /Users/mutro/Desktop/开发/Yisin
open Package.swift -a Xcode
```

### 2. 运行应用

在 Xcode 中：
1. 等待依赖解析完成
2. 选择 `Yisin` scheme
3. 按 `⌘R` 运行

### 3. 首次设置

应用启动后：

1. **授予权限**
   - 系统会提示需要辅助功能权限
   - 点击"打开系统设置"
   - 在"隐私与安全性 > 辅助功能"中勾选 Yisin

2. **配置 API**
   - 点击菜单栏的 Yisin 图标
   - 在"API 配置"中粘贴您的 Gemini API Key
   - API Key 会安全地存储在 macOS Keychain 中

3. **自定义快捷键**（即将推出）
   - 默认快捷键：`⌘⇧T`
   - 可在设置中自定义

## 📋 当前功能状态

### ✅ 已完成
- [x] 菜单栏图标
- [x] 设置界面
- [x] API Key 安全存储
- [x] 权限管理
- [x] Logo 动画

### 🚧 开发中
- [ ] 全局快捷键
- [ ] 文本捕获
- [ ] 翻译窗口
- [ ] Gemini API 集成

## 🎨 设计预览

### 菜单栏图标状态

- **待机** ⟷ 静态的对话流动图标
- **聆听** ⟷ 呼吸动画（蓝色）
- **思考** ⟷ 旋转圆环（蓝色）
- **完成** ⟷ 短暂的绿色闪烁

### 设置界面

极简的 MUJI 风格界面，包含：
- API 配置
- 快捷键设置
- 提示词编辑
- 历史记录管理

## 🔧 开发命令

```bash
# 构建项目
swift build

# 运行测试（即将添加）
swift test

# 清理构建
swift package clean
```

## 📚 相关文档

- [PROJECT_STATUS.md](PROJECT_STATUS.md) - 详细项目状态
- [IMPLEMENTATION_PLAN.md](IMPLEMENTATION_PLAN.md) - 完整实施计划
- [instructions.md](instructions.md) - 开发指南

## 🐛 遇到问题？

### 构建失败
```bash
# 清理并重新构建
swift package clean
swift build
```

### 权限问题
- 确保在"系统设置 > 隐私与安全性 > 辅助功能"中启用了 Yisin
- 可能需要重启应用

### Xcode 问题
- 确保使用 Xcode 15.0+
- 尝试 `Product > Clean Build Folder` (⇧⌘K)

## 🎯 下一步

查看 [IMPLEMENTATION_PLAN.md](IMPLEMENTATION_PLAN.md) 了解即将推出的功能。

---

**享受 Yisin 带来的宁静翻译体验** 🍵
