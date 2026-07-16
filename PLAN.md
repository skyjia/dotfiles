# PLAN.md — dotfiles 项目改进计划

> 由 2026-07-14 深度分析产生，覆盖 7 个维度：结构组织与文档、自动化与 justfile、Shell 配置质量、Git & Stow 卫生、安全与隐私、包管理与 Brew、配置一致与 Stow。
> 共识别 **43 条** 发现（原始编号 1–43），经逐条确认，**38 条** 纳入本计划，**5 条** 跳过（#14 / #17 / #18 / #32 / #39）。
>
> **进度：** ✅ 22/38 已完成（#1、#2、#3、#4、#5、#8、#11、#12、#13、#15、#16、#19、#20、#21、#22、#26、#28、#29、#30、#31、#36）

---

## 🔴 CRITICAL（1 条）

### 1. ~~Aria2 RPC secret 已提交到 git 历史~~ ✅ 已完成
- **状态：** 已完成（2026-07-14，commit `65f50f0`）
- **位置：** `aria2/.aria2/aria2.conf` 第 335 行
- **问题：** 该 RPC secret 从 commit `ab1e22e` 起就被追踪在 git 中。该 secret 控制 aria2 的 JSON-RPC 接口。
- **实际执行：**
  1. ✅ 立即轮换：生成新的 rpc-secret，存于 `~/.config/aria2/.rpc_secret`（mode 600，**非** stow 管理的本机路径）
  2. ✅ 从 `aria2.conf` 移除明文 secret，改为文档注释指向 wrapper
  3. ✅ 创建 `aria2/.aria2/aria2c-secure` wrapper 脚本，启动时注入 `--rpc-secret`，并带权限校验
  4. ✅ 取消追踪 `aria2/.aria2/core`（本机文件），加入 `.gitignore`
  5. ⏭️ 跳过 git 历史清洗（按用户选择；旧 secret 已失效）

---

## 🟠 HIGH（9 条）

### 2. ~~`./node_modules/.bin` 在 PATH 中，存在命令劫持风险~~ ✅ 已完成
- **状态：** 已完成（2026-07-14，commit `4c33e3a`）
- **位置：**
  - `zsh/.shared-env.zsh:42` — `export PATH=./node_modules/.bin:$PATH`
  - `fish/.config/fish/conf.d/node.fish` — `set -gx PATH ./node_modules/.bin $PATH`
- **问题：** 当前工作目录的 `./node_modules/.bin` 被加到 PATH 最前面。`cd` 进任何包含恶意 `node_modules/.bin/git` 的目录，该二进制会优先于 `/usr/bin/git` 被执行。这是著名的 PATH 注入漏洞模式。
- **实际执行（方案 1：直接删除）：**
  - ✅ `zsh/.shared-env.zsh`：移除 `export PATH=./node_modules/.bin:$PATH` 及其注释
  - ✅ `fish/.config/fish/conf.d/node.fish`：整个文件删除（只含该注入）
  - 现代 JS 工具链（`npm run` / `pnpm exec` / `yarn run` / `npx`）已能自动解析本地 bin，无需污染 PATH

### 3. ~~多个 `.DS_Store` 文件阻断 `stow` 操作~~ ✅ 已完成
- **状态：** 已完成（2026-07-15，commit `26a3b3a`）
- **位置：** 15 个 `.DS_Store` 文件分布在 fish / nushell / karabiner / iTerm / aria2 / raycast / zed 等包内
- **问题：** macOS Finder 自动生成的 `.DS_Store` 存在于 stow 包内，`stow fish` / `stow nushell` / `stow karabiner` 等都会因目标文件已存在而报错中止。
- **实际执行：**
  - ✅ 根 `.gitignore` 加入 `.DS_Store`（仓库自包含，不再依赖全局 gitignore）
  - ✅ 删除所有 15 个 `.DS_Store` 文件
  - ✅ 7 个包（fish / karabiner / iTerm / aria2 / nushell / raycast / zed）各自的 `.stow-local-ignore` 加入 `\.DS_Store`
- **关键发现：** `.stow-local-ignore` 在 stow 根目录**不**对包生效——stow 只读**包目录内**的 `.stow-local-ignore`。根目录的规则仅作文档性备份。

### 4. ~~`aria2/` 把运行时状态文件追踪进了 git~~ ✅ 已完成
- **状态：** 已完成（2026-07-14，commit `39d08a4`）
- **位置：** `aria2/.aria2/dht.dat`、`aria2/.aria2/dht6.dat`
- **问题：** 这些是 aria2 运行时产生的本机状态（DHT 路由表）。它们已经被 `aria2/.aria2/.gitignore` 列为忽略项，但因为是在规则加入之前就被 `git add` 了，git 仍持续追踪。
- **实际执行：**
  - ✅ `git rm --cached aria2/.aria2/dht.dat aria2/.aria2/dht6.dat`（从索引移除，磁盘文件保留）
  - ✅ gitignore 规则现在正常生效
- **补充说明：** `core` 已在 #1 中取消追踪；`aria2.session` 本就未被追踪，无需处理

### 5. ~~多个"本机专属"文件会被 `stow` 错误地链接到 `$HOME`~~ ✅ 已完成
- **状态：** 已完成（2026-07-15，commit `d839c1b`）
- **问题：** stow 不读 `.gitignore`。当前多个包用 `.gitignore` 排除了本机文件（避免污染 git），但没用 `.stow-local-ignore` 排除。结果：这些文件会被 stow 链接到 `$HOME`，造成跨机共享密钥/历史或链接悬空。
- **实际执行：**
  - ✅ 根 `.stow-local-ignore` 新增：`.antigravitycli`、`.ruby-lsp`、`.claude`
  - ✅ `zsh/.stow-local-ignore` 新增：`.zprofile_secure.sh`
  - ✅ `fish/.stow-local-ignore` 新增：`.config/fish/conf.d/.*\.secure\.fish`、`.config/fish/fish_variables`
  - ✅ `nushell/.stow-local-ignore` 新增：`history.txt`、`autoload/.*\.secure\.nu`
  - ✅ `R/.stow-local-ignore` 新建：`Rlib/`、`\.Rhistory`
  - ✅ `rust/.stow-local-ignore` 新增：`.cargo/bin/`、`.cargo/registry/`、`.cargo/\.global-cache`、`.cargo/\.package-cache.*`
  - ✅ `npm/.stow-local-ignore` 新建：`.npm/`
  - ✅ `karabiner/.stow-local-ignore` 新增：`.config/karabiner/automatic_backups/`
- **关键发现：**
  - `.stow-local-ignore` 用**正则**（非 shell glob），所以 `*.secure.fish` 要写成 `.*\.secure\.fish`
  - 根 `.stow-local-ignore` 对根级项目生效（已验证）
  - 包级 `.stow-local-ignore` 对包内项目生效（已验证）
  - 所有 7 个包 `stow -n` 测试通过；深度测试创建 dummy 文件后确认被忽略

### 6. `just wash-macos-provenance` 在任何非空目录树上必然失败
- **位置：** `justfile:30–33`
- **问题：** `xattr -d <attr>` 在文件没有该属性时返回非零退出码；just 默认中止；绝大多数文件都没有该属性。
- **修复（方案 B）：**
  ```just
  wash-macos-provenance:
      find . -exec xattr -d com.apple.quarantine {} \; 2>/dev/null || true
      find . -exec xattr -d com.apple.provenance {} \; 2>/dev/null || true
  ```

### 7. `set shell := ['fish', '-c']` 阻断 Linux 可移植性
- **位置：** `justfile:4`
- **问题：** 所有 recipe 都被强制通过 fish 执行。但 17 个 recipe 中**只有 1 个**（`update-fish`）真的需要 fish。
- **修复：** 删除全局 shell 设定，仅在 `update-fish` 中显式调用 `fish -c`：
  ```just
  # 删除这行: set shell := ['fish', '-c']
  update-fish:
      fish -c 'fisher update'
      fish -c 'fish_update_completions'
      @echo
  ```

### 8. ~~`npm/.npmrc` 全局禁用了 SSL 证书校验~~ ✅ 已完成
- **状态：** 已完成（2026-07-14，commit `cab3f93`）
- **位置：** `npm/.npmrc`
- **问题：** npm 完全不验证 TLS 证书，存在 MITM 风险。代理端口硬编码（与 `wget/.wgetrc`、`R/.Renviron`、`git/.gitconfig` 一致）。
- **实际执行：**
  - ✅ 移除 `strict-ssl=false`，改为 `strict-ssl=true`
  - ⏭️ 代理配置暂留，待 #19 统一处理（收敛到环境变量）
  - ⏭️ 不需要 `cafile`：Surge 默认不开 MitM，npm 走 CONNECT 隧道直接验证 registry.npmjs.org 的真实证书
- **验证：**
  - `npm ping` → PONG 3125ms ✅
  - `npm view is-odd` → 返回真实版本 3.0.1 ✅

### 9. 系统上有 3 个 Python，没有单一权威来源
- **位置：** brew `python@3.14`、`python@3.13` + anaconda + 系统 `/usr/bin/python3`
- **问题：** 3 份 Python 并存，`pip install` 装到哪个完全看 PATH。磁盘浪费，心智负担。
- **修复（方案 B：文档化规则）：**
  - 在 `asdf/.tool-versions` 顶部加注释：`# python intentionally unmanaged by asdf; conda for data-science, brew for system scripting`
  - 在 CLAUDE.md / AGENTS.md 写明 Python 多版本策略

### 10. `just update-conda` 盲目升级所有 conda 包
- **位置：** `justfile:68–73`
- **问题：** `conda update --all -y` 是大锤，可能破坏科学计算栈；前缀 `-` 静默吞掉失败。
- **修复（方案 B：用 environment.yml 锁定）：**
  ```bash
  conda env export -n base > anaconda/base-environment.yml
  ```
  ```just
  update-conda:
      conda env update --file {{ justfile_directory() }}/anaconda/base-environment.yml --prune
  ```
  去掉前缀 `-`。

---

## 🟡 MEDIUM（21 条）

### 11. ~~`README.md` 严重过时且有拼写错误~~ ✅ 已完成
- **状态：** 已完成（2026-07-16，commit `d160b3a`）
- **位置：** `/Users/skyjia/dotfiles/README.md`
- **问题：** 第 24 行 `astor-nvim` 拼写错误（应为 `astro-nvim`）；只列出 10 个包，实际有 31 个；第 14 行 "OS X" 表述不准。
- **实际执行（方案 B：完全重写）：** 修复所有拼写、按类别枚举全部 30 个包、新增 Just 命令参考段、改 "OS X" 为 "macOS/Linux"。

### 12. ~~`just update-submodules` 用 `--remote` 绕过版本锁定~~ ✅ 已完成
- **状态：** 已完成（2026-07-16，commit `d160b3a`）
- **位置：** `justfile:42–45`
- **问题：** 直接 checkout 上游 tracked branch 的最新 commit，丢失可重现性，破坏性变更无预警。
- **实际执行（方案 B：自动升级但显式记录）：** `git submodule update --remote` 后，把 SHAs 写入 `.submodule-versions` 并 `git add`，提示用户 review 后 commit。

### 13. ~~`just update-rust` 的 awk 管道脆弱且低效~~ ✅ 已完成
- **状态：** 已完成（2026-07-15，commit `1115f3a`，经 3 次迭代）
- **位置：** `justfile:104–115`、`rust/.cargo/config.toml`
- **问题：**
  1. `tee /dev/tty` 在无 TTY 环境失败；`awk '$4 == "Yes"'` 对列格式敏感；`cargo install --force` 每次都从源码重建
  2. **更严重的问题**：`cargo install-update -a` 在 source replacement（如 rsproxy）下**完全无法安装**——报错 `registry index was not found in any configuration: rsproxy-sparse`，`.crates.toml` / `.crates2.json` 不会被更新（[cargo-update#185](https://github.com/nabijaczleweli/cargo-update/issues/185)、[#248](https://github.com/nabijaczleweli/cargo-update/issues/248)）
- **最终修复（用户提出的更优方案）：**
  - `rust/.cargo/config.toml`：添加 `[registries.rsproxy-sparse]` 段，显式声明 sparse index URL。cargo-install-update 需要此段来解析 registry
  - `justfile`：保持简洁的 `cargo install-update -a`（不再需要 awk workaround）
  - 清理：移除未使用的镜像定义（aliyun、ustc、sjtu、tuna、rustcc）
- **验证：** cargo-edit 成功通过 rsproxy-sparse 升级 v0.13.12 → v0.13.13，`.crates.toml` 正确更新
- **附带发现（已处理，commit `7638560`）：**
  - ✅ 创建 `rust/.cargo/crates.txt` 清单文件（11 个 cargo 包），类似 `brew/.Brewfile`
  - ✅ 新增 `just install-crates` recipe：从清单安装所有包
  - ✅ `install-crates` 与 `update-rust` 解耦：前者是新机安装，后者是日常更新
  - ✅ 取消追踪 `rust/.cargo/.crates.toml` 和 `.crates2.json`（cargo 内部状态文件，含 rustc 版本、target、registry URL 等机器专属信息）
  - ✅ 加入 `rust/.cargo/.gitignore` 和 `rust/.stow-local-ignore`

### 15. ~~`just update-nvim` 用 `-` 前缀静默吞掉所有错误~~ ✅ 已完成
- **状态：** 已完成（2026-07-16，commit `8e0ba82`，基于 `3d1542a` 的修复）
- **位置：** `justfile:118–121`
- **问题：** `-` 让任何错误被忽略；`+q +q` 不带 `--headless` 可能卡住。
- **实际执行：** 移除 `-`、加 `--headless`、加 `command -v nvim` 守卫、用 `+qa!` 强退；fish 多行 if/else/end
- **关键学习：** justfile 严格要求 recipe 所有行 4 空格对齐，但 fish 的 `if/else/end` 不强制 body 缩进——两者可兼容

### 16. ~~`just update-apps` 中 `mas outdated` 退出码敏感~~ ✅ 已完成
- **状态：** 已完成（2026-07-16，commit `8e0ba82`，基于 `3d1542a` 的修复）
- **位置：** `justfile:124–128`
- **问题：** `mas outdated` 在"没有更新"时可能返回退出码 1，just 中止；macOS 专属命令无平台守卫。
- **实际执行：** 加 `|| true`、加 `test (uname) = Darwin` 平台守卫；fish 多行 if/else/end
      {{endif}}
  ```

### 19. ~~静态代理端口硬编码在 4 个不同配置文件中~~ ✅ 已完成
- **状态：** 已完成（2026-07-14，commit `a648163`）
- **位置：** `git/.gitconfig`、`wget/.wgetrc`、`R/.Renviron`、`npm/.npmrc`、`rust/.cargo/config.toml`（注释）
- **问题：** 全部硬编码 `127.0.0.1:6152`。代理配置是机器专属的，但被 stow 共享到所有机器。zsh 已有动态代理方案但其他工具没用上。
- **实际执行（混合方案）：**
  - ✅ 保留所有静态配置文件中的代理设置（GUI 工具如 RStudio 直接读取）
  - ✅ 新增 `update_proxy_config` 函数（alias `tpu`）：当代理地址变更时，一次性同步所有静态配置
  - ✅ 用 `realpath` 解析 stow symlink（`sed -i` 拒绝编辑 symlink）
  - ✅ 函数与现有 surge-proxy.fish 合并，加文件级注释、分节、常量抽取
  - ⏭️ `tpe`/`tpd` 保持原行为（只影响 env vars + git config）
- **附带修复：**
  - ✅ Surge 关闭时 `is_sys_proxy_enabled` 报错 "test: Missing argument at index 3"（命令替换空值 → 引号包裹）
  - ✅ `set_proxy` 加防御：host/port 为空时拒绝设置（fish 的 `(empty):(empty)` 是空列表，不是 `:`）
- **用法：**
  - 高频开关：`tpe`（启用）/ `tpd`（禁用）/ `tp`（切换）
  - 低频改地址：`tpu`（读 scutil → 写回 git/wget/R/npm 静态配置）

### 20. ~~`tmux/.tmux.conf.local` 被 git 追踪~~ ✅ 已完成（保持现状 + 文档化）
- **状态：** 已完成（2026-07-16，commit `22d684e`）
- **位置：** `tmux/.tmux.conf.local`
- **用户澄清：** 上游 gpakosz/.tmux 的设计约定是 `.tmux.conf.local` 作为本机专属覆盖（gitignored），但**下游 dotfiles 项目**有意的将其作为**跨机器共享的配置层**追踪。不侵入修改 submodule 的逻辑。
- **实际执行：** 保持文件追踪现状，仅在文件头部添加注释说明：
  - 上游约定（machine-local + gitignored）
  - 下游意图（跨机器共享）
  - 真正机器专属设置应使用环境变量或条件逻辑

### 21. ~~`.ignore` 文件引用了过时的路径~~ ✅ 已完成
- **状态：** 已完成（2026-07-16，commit `22d684e`）
- **位置：** `/Users/skyjia/dotfiles/.ignore`
- **问题：** `raycast/script-commands/` 路径不存在，实际为 `raycast/.config/raycast/script-commands/`。
- **实际执行：** 更新为正确路径。

### 22. ~~`logs/` 临时文件清理 + AGENTS.md 错误描述~~ ✅ 已完成
- **状态：** 已完成（2026-07-15，commit `b1bd42c`）
- **位置：** `/Users/skyjia/dotfiles/logs/`、`AGENTS.md`
- **用户澄清：** logs/ 是调试日志输出目录；里面的 bpmn/puml 文件是临时存入的，应该清理掉；AGENTS.md 中"BPMN diagrams and log files"的描述是错误的。
- **实际执行：**
  - ✅ 删除 `logs/` 中 5 个临时文件（`a.bpmn`、`diagram_1.bpmn`、`t.bpmn`、`t.puml`、`zsh.log`）
  - ✅ AGENTS.md 描述改为 "debug log output directory"
  - ✅ 保留 `logs/` 目录（用途：调试日志输出）

### 23. `vscode/` 包名不副实——实际不是 stow 包
- **位置：** `/Users/skyjia/dotfiles/vscode/`（只含 `vscode-extensions.txt`）
- **问题：** `stow vscode` 会创建 `~/vscode-extensions.txt` 符号链接，但 VSCode 不读这个位置。该文件只是 `just update-vscode` 生成的备份清单。
- **修复（方案 A）：** 移到非 stow 包位置：
  ```bash
  mkdir -p backups
  mv vscode/vscode-extensions.txt backups/
  rmdir vscode
  # 修改 justfile 中 update-vscode 的输出路径
  ```

### 24. `iTerm/` 仍在用但被错误标为 legacy
- **位置：** `/Users/skyjia/dotfiles/iTerm/`、`CLAUDE.md`
- **用户澄清：** iTerm 仍在使用；CLAUDE.md 标为 legacy 是错误的。
- **修复（方案 B）：**
  1. 在 `iTerm/.stow-local-ignore` 中加 `Profiles.json`，避免链接到 `$HOME`
  2. 修订 CLAUDE.md，移除 iTerm 的 "legacy" 标注

### 25. fish 启动时每次调用 `brew --prefix golang`
- **位置：** fish 配置中 `brew --prefix golang` 子进程调用
- **问题：** 每次 fish 启动耗时 ~26ms；加上 `scutil --proxy` 等调用累积拖慢 shell 启动。
- **修复（方案 A：缓存结果）：** 把 `brew --prefix` 的结果缓存到变量或直接硬编码 Apple Silicon 路径 `/opt/homebrew/opt/go`。

### 26. ~~nushell 每次启动都重新生成 asdf completion 文件~~ ✅ 已完成
- **状态：** 已完成（2026-07-15，commit `24383bc`）
- **位置：** `nushell/autoload/12-0-brew-asdf.nu`
- **问题：** 每次启动都调用 `asdf` 子进程 + `sed` + 写文件，即便内容未变。
- **实际执行：** 改为按需重生成——先对比新旧内容（byte-for-byte 通过临时文件），仅内容变化时写入。用 `save -f` 直接写 byte stream，避免 `str join` 引起的格式差异。
- **附带修复：** 移除过时的 `sed 's/\-\-ignore\-errors/--optional/'`（asdf 0.14+ 已修复 #2156，不再输出 `--ignore-errors`）。

### 27. `f_clean_dup` 函数存在 symlink 校验绕过漏洞
- **位置：** `fish/.config/fish/functions/f_clean_dup.fish`
- **问题：** 校验用 `realpath` 解析后的路径，但 fdupes 运行在原始 `$target_dir` 上。如果 `$target_dir` 是 symlink，校验可能被绕过。
- **修复（最小信任原则）：** 校验后所有后续操作（fdupes、rm）都使用规范化路径 `$abs_dir`，或用 `cd $abs_dir; fdupes ...`。

### 28. ~~多个配置文件中硬编码绝对路径~~ ✅ 已完成
- **状态：** 已完成（2026-07-15）
- **位置：** `fish_variables`、`starship.nu`、`git/.gitconfig`、`zsh/.shared-env.zsh`、`f_clean_dup.fish`
- **问题：** 硬编码 `/Users/skyjia/...`、`/opt/homebrew/...`、`/usr/local/...`，绑定当前机器和架构。
- **实际执行（Apple Silicon only）：**
  - ✅ **A（commit `4510dcb`）：** `git/.gitconfig` credential helper `/usr/local/share/gcm-core/git-credential-manager`（Intel 路径，新机器必 fail）→ `osxkeychain`（git 内置，架构无关）
  - ✅ **F（commit `4510dcb`）：** `zsh/.shared-env.zsh` 的 openssl@3 / curl / postgresql@18 路径改为 `$(brew --prefix ...)` 动态获取，openssl 块缓存变量避免重复调用
  - ✅ **D（commit `af4bc76`）：** `warp/.warp/settings.toml` 主题路径 `/Users/skyjia/.warp/themes/sky/v-for-vendetta.yaml` → `sky/v-for-vendetta.yaml`（相对路径，warp 自动在 `~/.warp/themes/` 下解析；测试过 name-only 方式不生效）
  - ⏭️ **B：** `git/.gitconfig` gpg 路径 `/opt/homebrew/bin/gpg` 保留（Apple Silicon 上正确，GUI 应用依赖此绝对路径）
  - ⏭️ **C：** `git/.gitconfig` safe.directory `/opt/homebrew` 保留（系统目录）
  - ⏭️ **E：** `zsh/.shared-env.zsh` 的 `brew shellenv` 保留绝对路径（首次启动时 brew 可能不在 PATH）
  - ⏭️ **G：** `starship.nu` 不处理（Apple Silicon 上 `/opt/homebrew/bin/starship` 本就正确）
  - ⏭️ **H/I：** nushell `10-brew.nu` / `config.nu` 不处理（同上理由）
  - ⏭️ **J：** `f_clean_dup.fish` 不处理（仅注释中的示例，代码已用 `$HOME`）

### 29. ~~`waveterm/` 下的 `secrets.enc` 加密文件被提交到 git~~ ✅ 无需修复
- **状态：** 调查后确认无需修复（2026-07-15）
- **位置：** `waveterm/.config/waveterm/secrets.enc`
- **实际发现：** PLAN.md 原始描述路径有误（实际在 `.config/waveterm/` 子目录下）。该文件**从未被 git 追踪**，且已有 `*.enc` 规则在 `waveterm/.config/waveterm/.gitignore` 中。无需任何修改。

### 30. ~~`zed/` 目录下堆积了未追踪的 junk 文件~~ ✅ 无需修复
- **状态：** 调查后确认无需修复（2026-07-15）
- **位置：** `zed/.config/zed/` 下的 `.tmp*`、`embeddings/`、`prompts/`、`conversations/`
- **实际发现：** `zed/.gitignore` 已覆盖所有 junk 模式（`.config/zed/.tmp*`、`.config/zed/embeddings`、`.config/zed/prompts`、`.config/zed/conversations`）。`.DS_Store` 由 #3 的根 gitignore + 包级 stow ignore 覆盖。`git status` 验证 zed/ 干净无未追踪文件。

### 31. ~~`bitwarden.unlock` 函数从 world-readable 文件读取密码~~ ✅ 已完成
- **状态：** 已完成（2026-07-14，commit `65f50f0`）
- **位置：** `~/.config/bitwarden/.password` + `fish/.config/fish/functions/bitwarden.unlock.fish`
- **问题：** 包含 Bitwarden 主密码，默认权限 644（world-readable）。
- **实际执行：**
  - ✅ 磁盘权限已为 `600`（用户已预先修好，无需再改）
  - ✅ 在 `bitwarden.unlock.fish` 函数开头加入权限校验：权限不是 `600` 时拒绝读取并提示 `chmod 600`
  - ✅ 使用跨平台 `stat`（macOS `-f %Lp` / Linux `-c %a`）读取权限
  - ✅ 用 `$pwfile` 变量统一引用路径，避免硬编码重复

### 34. `ffmpeg` 与 `ffmpeg-full` 同时安装，功能重复
- **位置：** `brew/.Brewfile` 第 86 行、第 90 行
- **修复：** 保留 `ffmpeg-full`，移除 `brew "ffmpeg"`。

### 35. `helvesec/rmux/rmux` 遮蔽了 homebrew-core 的 `rmux`
- **位置：** `brew/.Brewfile` 第 7 行、第 278 行
- **修复（方案 B）：** 改回 homebrew-core 版本
  ```bash
  brew untap hevesec/rmux
  # Brewfile 改为 brew "rmux"
  ```

### 36. ~~`just dump-brew` 重生成会抹掉手工注释和分组~~ ✅ 已完成
- **状态：** 已完成（2026-07-16，commit `8e0ba82`，基于 `3d1542a` 的修复）
- **位置：** `justfile:98–101`
- **修复（方案 A）：** 把 Brewfile 视为"自动生成的产物"，不手工编辑；接受字母序；在 Brewfile 顶部加注释 `# AUTO-GENERATED by just dump-brew; do not edit`。
- **实际执行：** 每次 `dump-brew` 后在 Brewfile 顶部插入 `# AUTO-GENERATED by \`just dump-brew\`. Do not edit manually.`；用 fish `set -l` 做变量作用域

---

## 🟢 LOW（7 条）

### 33. `origin/mbp-2015` 远端分支过期
- **问题：** 旧 MacBook Pro 的本地分支残留在远端，污染 `git branch -r`。
- **修复：**
  ```bash
  git push origin --delete mbp-2015
  git remote prune origin
  ```

### 37. `reattach-to-user-namespace` 已废弃
- **位置：** `brew/.Brewfile:214`
- **问题：** 仅在 macOS < 10.14 时需要，现代 macOS 上 tmux 直接访问 pasteboard。
- **修复：** 先 `grep -r reattach tmux/` 核实 tmux 配置不引用，然后从 Brewfile 移除。

### 38. 两个 tap 已注册但没有任何包来自它们
- **位置：** `brew/.Brewfile` 第 8 行 `leoafarias/fvm`、第 9 行 `manaflow-ai/cmux`
- **修复：**
  ```bash
  brew untap leoafarias/fvm
  brew untap manaflow-ai/cmux
  # 从 Brewfile 中删除这两行 tap
  ```

### 40. `rust/.cargo/config.toml` 定义了 5 个未使用的镜像源
- **问题：** 文件定义 6 个镜像源，实际只使用 `rsproxy-sparse`，其他 5 个是死代码；还有注释掉的 proxy 行。
- **修复：** 删除未使用的镜像定义和注释掉的 proxy 行。

### 41. `anaconda/.condarc` 硬编码清华镜像，无 `environment.yml`
- **修复（方案 B）：** 保留清华镜像，增加 `environment.yml` 锁定 base 环境：
  ```bash
  conda env export -n base > anaconda/base-environment.yml
  ```

### 42. `node` 和 `ruby` 同时通过 brew 依赖和 asdf 安装
- **修复（方案 B）：** 在 `asdf/.tool-versions` 顶部加注释说明 node/ruby 由 asdf 管理，brew 的是依赖。

### 43. `python-certifi` 已重命名为 `certifi`，本机安装名过期
- **修复：** `brew migrate python-certifi`，或等下次 `brew update` 自动处理。

---

## 执行顺序建议

建议按以下顺序执行（依赖关系 + 影响面）：

1. **安全紧急（今天）：** #1（Aria2 secret）+ #31（Bitwarden 密码权限）
2. **安全高危（本周）：** #2（PATH 劫持）+ #8（npm strict-ssl）+ #19（代理统一）+ #28（绝对路径）
3. **Stow/Git 卫生：** #3（.DS_Store）+ #4（aria2 状态）+ #5（per-machine 文件）+ #22（logs 清理）+ #29（waveterm secrets）+ #30（zed junk）
4. **Justfile 修复：** #6（wash-macos-provenance）+ #7（fish shell）+ #13（rust awk）+ #15（nvim）+ #16（mas）+ #12（submodules）+ #36（dump-brew）
5. **包管理清理：** #34（ffmpeg）+ #35（rmux）+ #37（reattach）+ #38（unused taps）+ #40（cargo mirrors）+ #43（python-certifi）
6. **配置文档：** #9（Python 文档）+ #10（conda env）+ #11（README）+ #20（tmux）+ #21（.ignore）+ #23（vscode）+ #24（iTerm）
7. **Shell 性能：** #25（brew prefix 缓存）+ #26（nushell completion）+ #27（f_clean_dup）
8. **收尾：** #33（stale branch）+ #41（anaconda env）+ #42（node/ruby 注释）

---

## 跳过的发现（5 条）

以下经讨论决定**不**纳入本计划：
- **#14** `~/.Brewfile` 是相对 symlink（接受现状）
- **#17** justfile 缺少 `bootstrap`/`doctor`/`stow-all` 等 recipe
- **#18** 当前 git 状态（1 个未推送 commit + 1 个未提交改动）
- **#32** git remote 使用 HTTPS
- **#39** `asdf/check-tools-version.nu` 的 java 正则只匹配 LTS 后缀
