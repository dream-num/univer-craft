# Univer Craft

Univer Craft 帮助你在 Codex 中开发 Univer 应用：按需研究 Univer Office SDK，再调用 [Tina](https://github.com/yangluoshen/tina) 完成规划、实现或验证。

## 快速安装

准备好 Git、Node.js 和 npm，在 Codex 中打开目标项目，发送：

```text
请读取 https://raw.githubusercontent.com/dream-num/univer-craft/main/INSTALL.md，将 Univer Craft 安装到当前仓库。
```

安装会同时配置 Tina 和 Univer Craft，无需预装技能或全局 OpenSpec。完成后，**新建 Codex 会话**再使用。

如果只想在本机使用、保持 Git 状态不变，在指令末尾加上：

```text
使用 incognito 模式，保持 Git 状态不变。
```

incognito 模式要求目标是 Git 工作区根目录。它使用本地 Git 排除规则，保留已跟踪文件；如果根目录 `AGENTS.md` 后续有变化，需要同步刷新由它生成的 `AGENTS.override.md`。

也可以将“当前仓库”换成目标的绝对路径。在线指南无法访问时，可提供本地 [INSTALL.md](INSTALL.md) 的绝对路径。

## 快速开始

在已安装的目标项目中使用：

| 操作 | 技能 |
| --- | --- |
| 研究 SDK、规划功能，或执行指定的实现、验证阶段 | `$univer-craft` |
| 自主完成整个任务，包括规划、实现和验证 | `$univer-craft-yolo` |

先研究接入方案：

```text
$univer-craft 研究现有应用接入 Univer 协同和自有权限系统需要哪些 SDK，并给出下一步指令
```

直接构建应用：

```text
$univer-craft-yolo 在这个新仓库构建支持本地编辑和保存的 Univer Sheets App
```

构建在线五子棋游戏：

```text
$univer-craft-yolo 使用 Univer Office SDK 构建在线五子棋游戏。

1. 无需登录注册，输入名称、创建房间，等待玩家加入即可开始。
2. 使用 Spreadsheet 构建棋盘。
3. 使用 Server 协同引擎进行联机同步。
4. 游戏结束后显示明显的弹窗，并分别向双方展示获胜或失败界面。
5. 界面采用清新美观的浅蓝色主题。
6. 己方和对方落子时都需要声音提示。
7. 允许观众加入房间观战。
```

新项目默认使用 pnpm、TypeScript，应用代码放在根目录 `src/`；已有项目沿用原有技术栈和目录结构。普通模式按请求进入对应阶段，YOLO 模式持续推进至完成或遇到明确阻塞。

## 更新与迁移

以下维护技能在 **Univer Craft 源码仓库**中使用，不会安装到目标项目。

### 获取源码

```sh
git clone --recurse-submodules https://github.com/dream-num/univer-craft.git
cd univer-craft
```

维护技能需要 OpenSpec，版本以 `vendor/tina/dependencies.env` 为准；可按 [安装指南](INSTALL.md) 的方式临时使用指定版本，无需全局安装。

### 更新已有项目

在干净的 Univer Craft 源码仓库中拉取更新，并检出其锁定的 Tina 版本：

```sh
git pull --ff-only
git submodule update --init vendor/tina
```

然后在 Codex 中打开该源码仓库，发送：

```text
$univer-craft-sync /absolute/path/to/target-repository
```

同步会一起更新 Univer Craft 和 Tina，识别并保留普通或 incognito 安装模式，保留项目自定义内容；遇到冲突时先处理冲突。已有 Tina 的项目也可用此命令补装 Univer Craft。**不要用初始化命令覆盖旧安装。**

### 安装到另一个项目

在新目标项目中使用上面的快速安装指令，或在源码仓库中选择一个初始化命令：

```text
$univer-craft-init /absolute/path/to/target-repository
```

仅本地安装：

```text
$univer-craft-init-incognito /absolute/path/to/target-repository
```

这些命令安装工作流和技能；应用代码与业务数据需另行迁移。

### 升级 Tina 依赖（维护者）

在源码仓库中发送以下指令，默认升级到 Tina 上游 `main`；也可在后面指定标签、分支或提交：

```text
$univer-craft-update-dependencies
```

技能会检查兼容性并运行 `./test.sh`，验证失败则恢复原版本。升级结果需随本仓库提交记录；已有项目需再执行 `$univer-craft-sync` 才会更新。

## 开发与参考

- [安装指南](INSTALL.md)：完整安装流程与前置条件。
- [SDK 研究地图](skills/univer-craft/references/univer-sdk.md)：Web、Server 和 AI SDK 的接入范围。
- `.agents/skills/`：本仓库的安装、同步和依赖升级技能。
- `skills/`：安装到目标项目的技能。
- `vendor/tina`：锁定版本的 Tina 子模块，通过 Git 升级，保持其源码不变。

修改技能、安装器或 Tina 依赖后，运行 `./test.sh`。
