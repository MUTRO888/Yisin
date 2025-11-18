#!/bin/bash

echo "🔍 Yisin 诊断工具"
echo "=================="
echo ""

# 1. 检查辅助功能权限
echo "1️⃣ 检查辅助功能权限..."
if osascript -e 'tell application "System Events" to get name of every process' &>/dev/null; then
    echo "✅ 辅助功能权限已授予"
else
    echo "❌ 辅助功能权限未授予"
    echo "   请在系统设置 > 隐私与安全性 > 辅助功能 中启用"
fi
echo ""

# 2. 检查 UserDefaults
echo "2️⃣ 检查保存的配置..."
HOTKEY=$(defaults read com.yisin.app hotkeyDisplay 2>/dev/null)
if [ -n "$HOTKEY" ]; then
    echo "✅ 快捷键配置: $HOTKEY"
else
    echo "⚠️  未找到快捷键配置（将使用默认值）"
fi
echo ""

# 3. 检查 API Key
echo "3️⃣ 检查 API Key..."
if security find-generic-password -s "com.yisin.app" -a "gemini-api-key" &>/dev/null; then
    echo "✅ API Key 已保存在 Keychain"
else
    echo "⚠️  未找到 API Key"
fi
echo ""

# 4. 检查进程
echo "4️⃣ 检查 Yisin 进程..."
if pgrep -x "Yisin" > /dev/null; then
    echo "✅ Yisin 正在运行"
    echo "   PID: $(pgrep -x Yisin)"
else
    echo "❌ Yisin 未运行"
fi
echo ""

# 5. 检查快捷键冲突
echo "5️⃣ 检查可能的快捷键冲突..."
echo "   系统快捷键 ⌘⇧T 通常用于："
echo "   - Safari: 重新打开关闭的标签页"
echo "   - Chrome: 重新打开关闭的标签页"
echo "   建议使用其他快捷键，如 ⌘⌥T 或 ⌃⌥T"
echo ""

echo "=================="
echo "诊断完成！"
echo ""
echo "💡 建议："
echo "1. 确保辅助功能权限已授予"
echo "2. 尝试使用不同的快捷键（避免与浏览器冲突）"
echo "3. 在 Xcode 控制台查看详细日志"
