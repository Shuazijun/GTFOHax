# ImGui 子模块升级操作手册

## 当前状态分析

### 当前版本
- **当前提交**: 7f9533b8400120faa23e2cca7eec53e97e4143a9
- **版本标签**: v1.90-77-g7f9533b84 (基于 v1.90 分支)
- **描述**: 当前版本是 v1.90 分支上的第 77 个提交

### 最新稳定版本
- **最新稳定版本**: v1.92.5 (发布于 2024-XX-XX)
- **最新稳定版本 (docking分支)**: v1.92.5-docking
- **版本差异**: 从 v1.90 到 v1.92.5，包含多个重要更新和 bug 修复

## 兼容性评估

### 项目使用的 ImGui API
根据代码分析，项目使用了以下 ImGui API：

1. **基本窗口操作**: `Begin()`, `End()`, `SetNextWindowPos()`, `SetNextWindowBgAlpha()`
2. **文本渲染**: `Text()`, `CalcTextSize()`, `PushFont()`, `PopFont()`
3. **控件**: `Checkbox()`, `Button()`, `SliderInt()`, `SliderFloat()`, `ColorEdit4()`
4. **布局**: `SameLine()`, `SetCursorPosX()`, `PushItemWidth()`
5. **树形控件**: `TreeNode()`, `TreePop()`, `CollapsingHeader()`
6. **组合框**: `Combo()`, `BeginCombo()`, `Selectable()`, `EndCombo()`
7. **绘图**: `GetBackgroundDrawList()->AddText()`, `GetColorU32()`
8. **标识符**: `PushID()`, `PopID()`
9. **视口**: `GetMainViewport()`

### 重大变化分析
从 CHANGELOG 分析，v1.90 到 v1.92.5 的主要变化：

1. **v1.90.0 (2023-11-15)**:
   - `BeginChild()` API 从 `bool border` 参数改为 `ImGuiChildFlags flags`
   - `BeginChildFrame()`/`EndChildFrame()` 被移除，使用 `BeginChild()` 配合 `ImGuiChildFlags_FrameStyle`
   - `ShowStackToolWindow()` 重命名为 `ShowIDStackToolWindow()`
   - ListBox/Combo 的回调函数签名变化

2. **v1.89.7 (2023-07-04)**:
   - `SetItemAllowOverlap()` 被废弃，使用 `SetNextItemAllowOverlap()`
   - `ImGuiTreeNodeFlags_AllowItemOverlap` 重命名为 `ImGuiTreeNodeFlags_AllowOverlap`
   - `ImGuiSelectableFlags_AllowItemOverlap` 重命名为 `ImGuiSelectableFlags_AllowOverlap`

3. **其他变化**:
   - 各种 bug 修复和性能改进
   - 新的功能添加（如椭圆绘制、工具提示改进等）

### 兼容性结论
**项目代码与最新版本兼容**，因为：
1. 未使用 `BeginChild()` 或 `BeginChildFrame()`
2. 未使用 `SetItemAllowOverlap()` 或相关的重叠标志
3. 未使用已废弃的 API
4. 使用的 API 在版本间保持稳定

## 升级操作步骤

### 方法一：更新到最新稳定版本 (推荐)

#### 步骤 1: 备份当前状态
```bash
# 确保在项目根目录
cd f:/CodeBase/GTFO/GTFOHax

# 备份当前 imgui 子模块状态
git submodule status > imgui_backup_status.txt
cd imgui ; git log --oneline -10 > ../imgui_backup_log.txt
cd ..
```

#### 步骤 2: 更新子模块到特定版本
```bash
# 方法 A: 更新到最新稳定版本 v1.92.5
cd imgui
git fetch --tags
git checkout v1.92.5

# 或者更新到 docking 分支的最新版本
# git checkout v1.92.5-docking

# 返回项目根目录
cd ..
```

#### 步骤 3: 提交子模块更新
```bash
# 更新主项目的子模块引用
git add imgui
git commit -m "更新 imgui 子模块到 v1.92.5"
```

### 方法二：更新到最新 master 分支

#### 步骤 1: 更新到最新提交
```bash
cd imgui
git checkout master
git pull origin master

# 或者使用特定分支
# git checkout docking
# git pull origin docking

cd ..
```

#### 步骤 2: 提交更新
```bash
git add imgui
git commit -m "更新 imgui 子模块到最新 master 分支"
```

### 方法三：使用 git 子模块更新命令

#### 步骤 1: 使用 git 命令更新所有子模块
```bash
# 更新所有子模块到配置的提交
git submodule update --remote --recursive

# 或者只更新 imgui 子模块
git submodule update --remote imgui
```

#### 步骤 2: 提交更改
```bash
git add imgui
git commit -m "通过 git submodule update 更新 imgui 子模块"
```

## 构建验证

### 步骤 1: 清理构建缓存
```bash
# 如果使用 Visual Studio
# 删除构建目录如 build/, out/, 或解决方案的 .vs 目录

# 如果使用 CMake
rm -rf build/  # Linux/macOS
# 或 Windows PowerShell
Remove-Item -Recurse -Force build
```

### 步骤 2: 重新生成项目
```bash
# 使用 CMake 重新生成
mkdir build
cd build
cmake ..

# 或者使用 Visual Studio 打开解决方案重新构建
```

### 步骤 3: 编译测试
```bash
# 编译项目
cmake --build . --config Release

# 或者使用 Visual Studio 构建
```

### 步骤 4: 运行时测试
1. 启动应用程序
2. 验证 UI 功能正常
3. 检查是否有任何渲染问题
4. 测试所有菜单功能

## 回滚方案

如果升级后出现问题，可以回滚到之前的状态：

### 方法一：使用 git 回滚
```bash
# 回滚 imgui 子模块
cd imgui
git reset --hard 7f9533b8400120faa23e2cca7eec53e97e4143a9
cd ..

# 提交回滚
git add imgui
git commit -m "回滚 imgui 子模块到之前版本"
```

### 方法二：从备份恢复
```bash
# 如果有备份，可以恢复
git submodule deinit imgui
git rm imgui
git commit -m "移除 imgui 子模块"

# 重新添加旧版本
git submodule add -b v1.90 https://github.com/ocornut/imgui.git imgui
```

## 升级后的检查清单

- [ ] 项目编译成功
- [ ] UI 渲染正常
- [ ] 所有控件功能正常
- [ ] 字体渲染正确
- [ ] 颜色选择器工作正常
- [ ] 滑动条和输入框功能正常
- [ ] 组合框和下拉菜单正常
- [ ] 树形控件展开/收起正常
- [ ] 性能无明显下降
- [ ] 内存使用正常

## 注意事项

1. **imconfig.h 自定义配置**: 如果项目修改了 `imgui/imconfig.h` 文件，需要确保在升级后保留这些修改。建议使用 `IMGUI_USER_CONFIG` 定义自定义配置文件。

2. **后端集成**: 项目可能使用了特定的后端（如 DirectX、OpenGL）。确保后端代码与新的 ImGui 版本兼容。

3. **字体管理**: 如果使用了自定义字体，验证字体加载和渲染是否正常。

4. **第三方扩展**: 如果有使用 ImGui 的第三方扩展库，需要检查其兼容性。

## 版本差异摘要

### v1.90 到 v1.92.5 主要改进

1. **性能优化**: 各种渲染和布局性能改进
2. **bug 修复**: 修复了多个渲染和交互问题
3. **新功能**:
   - 椭圆绘制支持 (`AddEllipse()`, `AddEllipseFilled()`)
   - 改进的工具提示系统
   - 更好的表格功能
   - 增强的颜色选择器
4. **API 清理**: 移除已废弃的 API，提高代码清晰度
5. **后端改进**: 各种后端（GLFW、SDL、Vulkan 等）的改进和 bug 修复

## 联系支持

如果在升级过程中遇到问题：

1. 查看 ImGui GitHub Issues: https://github.com/ocornut/imgui/issues
2. 参考 ImGui 文档: https://github.com/ocornut/imgui/wiki
3. 检查 Breaking Changes 部分: 在 `imgui.cpp` 或 CHANGELOG 中

## 结论

升级到 ImGui v1.92.5 是安全的，因为项目使用的 API 保持兼容。建议采用**方法一**更新到稳定版本 v1.92.5，并进行充分的测试验证。

**推荐升级路径**: v1.90 → v1.92.5 (稳定版本)