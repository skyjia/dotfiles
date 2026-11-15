# PRACTICE.md — 项目实践中积累的经验与偏好

> 由 2026-07-14 至 2026-07-16 处理 PLAN.md 的 37 项改进过程中总结。
> 本文档记录实际验证过的最佳实践与用户偏好，供未来维护参考。

---

## Shell & Justfile

### 目标架构
- **Apple Silicon only**：不考虑 Intel 架构（`/opt/homebrew` 可硬编码）
- **macOS 为主**：Homebrew prefix = `/opt/homebrew`

### Shell 偏好
- **Fish 为主 shell**：justfile 使用 `set shell := ['fish', '-c']`，假设 Linux 也安装了 fish
- **避免 bash shebang**：justfile recipe 优先用 fish 语法，不用 `#!/usr/bin/env bash`
- **Justfile 缩进**：所有行必须 4 空格对齐。Fish 的 `if/else/end` 接受无 body 缩进形式，兼容此规则

### Justfile 关键模式
| 模式 | 说明 |
|---|---|
| **错误可见** | 不要加 `-` 前缀；失败应被看见 |
| **`$` 直接写** | Just 不转换 `$$`；awk 中直接写 `$1`（不是 `$$1`）|
| **多行脚本用 shebang** | `#!/usr/bin/env fish` 让整个 recipe 作为单脚本运行（避免每行独立 `fish -c` 调用）|
| **解耦 recipe 与逻辑** | 复杂逻辑提取为 shell function，recipe 只做薄封装 |
| **`{{ justfile_directory() }}`** | 引用 justfile 所在目录的相对路径 |

### Fish 变量与缓存
- **持久缓存用 `set -U`**（universal，跨 session）
- **命名规范**：`<SOURCE>_<PURPOSE>_CACHE_<TTL\|VALUE\|TIME>`
  - 例：`BREW_GOLANG_CACHE_TTL`、`SCUTIL_PROXY_CACHE_VALUE`、`SCUTIL_PROXY_CACHE_TIME`
- **`set -g` vs `set -U`**：`-g` 仅当前 session，`-U` 跨 session 持久化；缓存应统一用 `-U`

---

## Stow

### 关键规则
- **`.stow-local-ignore` 是 per-package 的**：根目录的 ignore 只对根级项目生效
- **`.gitignore` 排除的本机文件，必须同步加到对应包的 `.stow-local-ignore`**
- **`.stow-local-ignore` 用正则**（非 shell glob）：`\.DS_Store` 而非 `*.DS_Store`

### 常见忽略模式
```
# 根 .stow-local-ignore
\.git
\.gitignore
\.DS_Store
backups
\.ruby-lsp
\.claude

# 包 .stow-local-ignore（例：fish/）
.gitignore
\.DS_Store
.config/fish/conf.d/.*\.secure\.fish
.config/fish/fish_variables
```

---

## Fish Functions

### 设计原则
- **参数验证**：检查必需参数数量、路径存在性
- **错误信息显性输出**：不要 `2>/dev/null` 隐藏核心命令的错误；让用户能看到发生了什么
- **函数返回码始终为 0**：最终 `echo` 返回 0，核心命令的错误仅作为信息
- **Autoload 路径**：放 `fish/.config/fish/functions/`，stow 后自动被 fish 加载

### 示例
```fish
function wash-macos-provenance -d "Remove macOS quarantine and provenance"
    if test (count $argv) -ne 1
        echo "Usage: wash-macos-provenance <path>" >&2
        return 1
    end
    set -l target $argv[1]
    if not test -e "$target"
        echo "Error: path does not exist: $target" >&2
        return 1
    end
    xattr -cr "$target"
    echo "Washed extended attributes from: $target"
end
```

---

## Homebrew

### Brewfile 管理
- **视为自动生成**：每次 `brew bundle dump` 重写
- **加 `# AUTO-GENERATED` 头部注释**：`just dump-brew` 自动插入
- **及时清理**：
  - 移除空 tap（无包从该 tap 安装）
  - 移除重复 formula（如 `ffmpeg` + `ffmpeg-full`，保留功能更全的）
  - 改 tap 版回 homebrew-core（同版本时）
  - 移除废弃包（如 `reattach-to-user-namespace`，macOS >= 10.14 不需要）

### Brewfile 的两个陷阱
- **显式 `brew "x"` 会让 x 永久躲过 `brew autoremove`**：`brew bundle dump` 把已沦为他人依赖的包也写成显式请求，Homebrew 因此给它们打上 `installed_on_request`。实例：删掉 `mssql-tools18` 后，`msodbcsql18` 原地留存，必须显式卸载
- **pkg 类 cask 可能不声明 `uninstall`**：`brew uninstall --cask` 只清账本，数据目录留存（实例：`anaconda` 的 4.4 GB）。先查 `brew info --json=v2 --cask X` 的 `uninstall` 是否为 `null`

### 清理取证方法
单看 `brew leaves` 会误判，四路交叉：**shell 历史频率 → dotfiles 里的真实接线 → 工具运行时状态目录 mtime → 删掉它连带消失多少独占依赖**。
shell 历史**不含** GUI、脚本内部调用与 shell hook，所以 `starship`/`fzf`/`direnv`/`yq`/`delta` 都是 0 次却确实在用；反过来说，被 git 调用的 `delta`、被 justfile 调用的 `yq` 属于"隐形在用"，删前必须查引用。

### macOS 废弃包参考
| 包 | 废弃条件 |
|---|---|
| `reattach-to-user-namespace` | macOS >= 10.14（tmux 直接访问 pasteboard）|
| `python-certifi` | 已重命名为 `certifi` |

---

## Cargo

### Source Replacement 配置
```toml
# rust/.cargo/config.toml
[source.crates-io]
replace-with = 'rsproxy-sparse'

[source.rsproxy-sparse]
registry = "sparse+https://rsproxy.cn/index/"

[registries.rsproxy-sparse]
index = "sparse+https://rsproxy.cn/index/"
```

**关键**：`[registries.rsproxy-sparse]` 段是 cargo-install-update 解析 registry 所需，缺少会导致 `"registry index was not found"` 错误。

### Manifest 管理
- **`rust/.cargo/crates.txt`**：人类维护的包清单
- **`just install-cargo-crates`**：批量安装（新机器 setup）
- **`just cargo-install <pkg>`**：单包安装 + 自动追加到 manifest（去重）
- 安装与更新解耦：`install-cargo-crates`（安装）vs `update-rust`（更新）

---

## Python / uv

### 分工
- **brew 提供解释器，uv 提供虚拟环境 / 依赖 / 工具**，不允许第三方（conda 已于 2026-11-15 移除）
- brew 的 `python@3.15` 只提供 `python3`；裸 `python` 用 `~/.local/bin/python -> /opt/homebrew/bin/python3` 补上，零新增解释器且随 brew 升级自动跟随
- **不设全局包环境**：一次性脚本 `uv run --with <pkg>`，项目 `uv add`

### uv 的默认行为会静默咬人
`uv --help` 原文："By default, uv prefers using Python versions it manages"。所以项目 venv 用 brew 的 python 只是**恰好没有同版本的托管副本**；一旦 uv 下载了同版本，新建 venv 会静默换基座。对策：`uv/.config/uv/uv.toml` 里 `python-preference = "system"`。

### 配置键必须实测，不能凭记忆
- `managed-python = false` 在 uv 0.13.8 的 **uv.toml 中不被接受**（仅 CLI flag / 环境变量），写进去会解析失败
- 验证手法：`uv --config-file <f> python list --only-installed` —— uv 对未知键报错，stderr 为空即通过。注意合法 flag 是 `--only-installed`，`--installed` 不存在

### 断言 venv 基座
读探针 venv 的 `pyvenv.cfg` 中 `home=`，比 `python -V` 可靠（同版本、不同来源是常态）。
**此断言必须在移除 conda 之后再跑**："system" 也包含 Anaconda 的 python，而它在发现顺序里更靠前会被优先选中。

### 已移除：atopile 扩展的 uv PATH 注入
`fish/.config/fish/conf.d/uv.env.fish` 曾 source 扩展自带的 `env.fish`，后者 **prepend** 自己的目录。
关键陷阱：conf.d 按字典序加载，`10-brew.fish`（brew shellenv，也 prepend）在前、`uv.env.fish` 在后，
**后跑的赢**，于是真实终端里的 `uv` 静默变成扩展捆绑的 0.11.21 而非 brew 的 0.13.8。
教训：判断 PATH 归属必须在**干净环境**里测（`env -i HOME=$HOME fish -l -i -c 'command -v uv'`）；
在已运行的 GUI 派生会话里测，会读到父进程继承来的顺序，得出相反结论。

---

## Neovim / AstroNvim

### 命令选择
| 命令 | 同步/异步 | 适用场景 |
|---|---|---|
| `+MasonUpdate` | 异步 | 仅更新 registry |
| `+MasonToolsUpdateSync` | **同步** | 更新所有工具，等待完成 |
| `+MasonToolsInstallSync` | **同步** | 安装所有工具，等待完成 |

**教训**：用 `+MasonUpdate +qa!` 会导致 Mason 在异步安装过程中被强制退出，工具安装中止。改用 `+MasonToolsUpdateSync`。

### Headless 模式
```bash
nvim --headless "+AstroUpdate" "+MasonToolsUpdateSync" "+qa!"
```
- `--headless` 避免 UI 和 swap 提示卡住
- `+qa!` 强制退出（不是 `+q +q`）

---

## 文档

### 文档职责分离
| 文件 | 用途 | 是否入 git |
|---|---|---|
| `AGENTS.md` | **所有 AI 工具的唯一权威参考** | ✅ |
| `CLAUDE.md` | 仅 `@AGENTS.md` 导入桩，不含任何独立内容 | ✅ |
| `README.md` | 人类用户入口，对齐 AGENTS.md | ✅ |
| `PRACTICE.md` | 经验沉淀 | ✅ |
| `PLAN.md` | 工作追踪文档 | ❌（本地） |

### 为什么 CLAUDE.md 不能只是"提一句去看 AGENTS.md"
Claude Code 只自动加载 `CLAUDE.md`，**不会自动读 `AGENTS.md`**（本会话的上下文里注入的
就是 CLAUDE.md 正文）。因此桩文件必须使用 `@AGENTS.md` 导入语法，否则 AGENTS.md 对
Claude 完全不进上下文，"统一权威"会变成"两份各自漂移"。

### 同步规则
- **改权威只改 AGENTS.md**：CLAUDE.md 是桩，往它里面加内容是回归——会立刻开始漂移
- **README.md 对齐 AGENTS.md**：包列表、命令参考、架构描述
- **包变动时同步更新**：AGENTS.md + README.md（涉及经验教训时再动 PRACTICE.md）
- **PLAN.md 是本地工作文档**：不追踪，不 review，不 commit

---

## 备份 vs 配置

### 目录组织
- **stow 包**：真正的配置文件（被 stow 链接到 `$HOME`）
- **`backups/`**：非配置性质的备份（git 追踪，stow 忽略）
- **`backups/` 内按来源分子目录**：`backups/vscode/`、`backups/iTerm/` 隔离不同备份源

### 例子
| 路径 | 性质 |
|---|---|
| `zsh/.zshrc` | 配置（stow 包）|
| `backups/vscode/vscode-extensions.txt` | 备份清单 |
| `backups/iTerm/Profiles.json` | 备份配置 |

---

## 终端多路复用

- 工具栈为 `cmux` + `mosh`；gpakosz/.tmux 配置层已移除（`tmux/` stow 包与 submodule，2026-11-14）
- **`brew tmux` 二进制是有意保留的，别当残留清掉**：cmux 内置 `LocalTmuxSettingsModel` 与 `RemoteTmuxController`（附 `cmux-tmux-agent.py`，内含 `exec "$cmux_tmux" attach-session`），其 tmux 镜像模式需要驱动一个真实的 tmux 二进制；mosh 到远端接回会话同样依赖 tmux
- 副作用：无配置层后 tmux 若被直接启动，将以空配置运行（默认前缀 `Ctrl-b`）

---

## 安全

### Secret 管理
- **密钥不进 dotfiles**：用 `.secure.*` 文件（gitignored + stow-ignored）
- **Git 历史中的泄漏**：立即轮换 + `git filter-repo` 清理
- **Credential helper**：用 `osxkeychain`（git 内置，跨架构）

### 权限
- **敏感文件 `chmod 600`**：`~/.config/bitwarden/.password` 等
- **函数内校验**：读取前检查权限

---

## macOS 特性

### Provenance 清洗
- **用 `xattr -cr`**（clear all recursive）
- **不要用 `xattr -d -r`**（会在缺少属性时报错）

### 常见废弃依赖
- `reattach-to-user-namespace`：macOS >= 10.14 不需要
- `python-certifi`：已重命名为 `certifi`

---

## 工作流程

### 修改流程
1. **先调查**：检查当前文件状态、追踪情况、依赖关系
2. **提方案**：列出可选方案，明确优劣
3. **用户确认**：具体细节、方案选择、commit 信息
4. **执行修改**
5. **验证**：语法检查、实际运行测试
6. **提交**：amend 或直接 commit

### Commit 习惯
- **一次 commit 可涵盖多个相关 #**：`fix(...): ... (#6, #7)`
- **commit 信息写明原因**：不仅说做了什么，还说为什么
- **amend 修复**：同 commit 的后续改进用 `--amend`
- **commit 前确认**：展示 diff 和 commit message，等用户确认

### 文档更新
- **改代码同步改文档**：README.md、CLAUDE.md、AGENTS.md
- **PLAN.md 进度更新**：每完成一批就更新进度计数和条目状态
- **PLAN.md 不 commit**：本地工作文档
