#!/usr/bin/env just --justfile
# https://just.systems/

set shell := ['fish', '-c']
set dotenv-load := true

# List all available recipes
default:
    @just --list

# Update all components (dotfiles, brew, shells, apps, editors, dev tools, AI tools)
all: update-dotfiles update-brew update-shells update-dev update-apps update-editors update-ai

# Pull latest changes and update submodules
update-dotfiles: pull-latest update-submodules

# Update Homebrew packages and casks according to global Brewfile, upgrade all installed packages, then cleanup
update-brew: brew-update brew-upgrade brew-cleanup

# Update fish shell plugins and completions
update-shells: update-fish

# Update nvim, vscode, and yazi plugins
update-editors: update-nvim update-vscode update-yazi

# Update R packages, asdf plugins, and rust toolchain
update-dev: update-r-packages update-asdf update-rust

# Update npm packages globally in the active asdf Node
update-npm:
    # Update npm packages globally in the active asdf Node
    with-asdf-node npm update -g
    asdf reshim nodejs
    @echo

# Check for outdated npm packages globally
check-npm-outdated:
    #!/usr/bin/env fish
    # npm outdated 只要发现过时项就返回 1 —— 那是"查到了"而不是"失败了"，
    # 原样透传会让 recipe 报 error 并吞掉结果。这里只在没有输出时才算失败。
    # stderr 不进命令替换，因此真实错误的文字仍然可见。
    set -l out (with-asdf-node npm outdated -g)
    set -l code $status

    if test -z "$out"
        if test $code -ne 0
            echo "npm outdated 执行失败（退出码 $code）" >&2
            exit $code
        end
        echo "全局 npm 包均已是最新"
        exit 0
    end

    printf '%s\n' $out
    echo ""
    echo "发现 "(count $out)" 行过时项（含表头），如需升级: just update-npm"

# List all globally installed npm packages
npm-list:
    # List globally installed npm packages of the active asdf Node
    with-asdf-node npm list -g --depth=0
    @echo

# Install packages listed in ~/.default-npm-packages that the active Node is missing
sync-npm-defaults:
    #!/usr/bin/env fish
    set -l pkgs_file $HOME/.default-npm-packages
    if not test -e $pkgs_file
        echo "No package file: $pkgs_file" >&2
        exit 1
    end

    # 锁定目标环境：brew 也可能装有一个同版本号的 node，其 npm 的 global root 指向
    # /opt/homebrew —— 不锁定就会把包装进 brew 而不是版本目录。
    set -l node_dir (resolve-asdf-node)
    or exit 1
    set -lx PATH $node_dir/bin $PATH

    npm --version >/dev/null
    or begin
        echo "npm is not usable in $node_dir" >&2
        exit 1
    end

    # 期望清单：跳过注释与空行，每行取首个 token。
    # 已知局限：行尾的 npm 标志不会转达（asdf-nodejs 会批量应用，此处只按包名安装）。
    set -l specs (awk 'NF && $1 !~ /^#/ { printf "%s\n", $1 }' $pkgs_file)
    if test (count $specs) -eq 0
        echo "$pkgs_file lists no packages" >&2
        exit 1
    end

    # npm ls 在依赖树不满足时退出码为 1，这里只取它的 JSON 输出，stderr 保持可见
    set -l installed (npm ls --global --depth=0 --json | jq -r '.dependencies // {} | keys[]')

    set -l inst_file (mktemp)
    printf '%s\n' $installed >$inst_file
    # name = spec 去掉尾部 @version/@tag，但保留 @scope 的前导 @
    set -l missing (awk -v ins=$inst_file '
        BEGIN { while ((getline n < ins) > 0) I[n] = 1 }
        NF && $1 !~ /^#/ {
            spec = $1
            name = spec
            if (substr(name, 1, 1) == "@") {
                if (match(substr(name, 2), /@/)) name = substr(name, 1, RSTART)
            } else if (match(name, /@/)) {
                name = substr(name, 1, RSTART - 1)
            }
            if (!(name in I)) printf "%s\n", spec
        }' $pkgs_file)
    rm -f $inst_file

    echo "Node:  $node_dir"
    echo "清单:  "(count $specs)" 个    已装: "(count $installed)" 个"
    if test (count $missing) -eq 0
        echo "无缺失包，未做任何改动"
        exit 0
    end

    # 注意：shebang 型 recipe 里不能用 @echo —— `@` 抑制回显是 just 的逐行语法，
    # 在整段交给 fish 的脚本里它会变成一条名为 `@echo` 的命令。
    echo "缺失:  $missing"
    npm install --global $missing
    asdf reshim nodejs


# Update dws, bailian, claude, and skillshare CLI tools
update-ai: update-dws update-bailian update-claude update-skillshare

# Wash macOS provenance attributes from the project root
wash-macos-provenance:
    # Washing macOS provenance attributes from project root
    wash-macos-provenance {{ justfile_directory() }}

# Pull latest changes from remote repository
pull-latest:
    # Pulling latest changes
    git pull
    @echo

# Pull all changes for the submodules
update-submodules:
    # Pull all changes for the submodules
    git submodule update --remote
    # Record submodule SHAs for review
    git submodule status | awk '{print $1, $2}' > .submodule-versions
    git add .submodule-versions
    @echo "Run 'git diff --cached .submodule-versions' to review, then commit"

# Update fish plugins and generate completions
update-fish:
    # Updating fish plugins
    fisher update
    fish_update_completions
    @echo

# Update asdf plugin repositories and check tool versions
update-asdf:
    # Updating asdf plugin repositories
    asdf plugin update --all
    {{ justfile_directory() }}/asdf/check-tools-version.nu
    @echo

# Update R packages (without prompting)
update-r-packages:
    # Updating R packages
    Rscript -e 'update.packages(ask = FALSE)'
    @echo

# Update vscode extensions and export list to file
update-vscode:
    # Update vscode extensions
    code --update-extensions
    # Export vscode extension list to file
    code --list-extensions > {{ justfile_directory() }}/backups/vscode/vscode-extensions.txt
    @echo

export-vscode-extensions:
    # Export vscode extension list to file
    code --list-extensions > {{ justfile_directory() }}/backups/vscode/vscode-extensions.txt
    @echo

# Update Homebrew formula lists
brew-update:
    # Update Homebrew formula lists
    brew update
    @echo

# Upgrade Homebrew packages and casks according to global Brewfile, then upgrade all installed packages
brew-upgrade:
    # Install packages missing from Brewfile
    brew bundle --global -v
    # Upgrade all installed packages
    brew upgrade --yes
    echo "run `just brew-upgrade-greedy` to upgrade all installed packages (including :latest casks and greedy-outdated ones)"
    @echo

# Upgrade Homebrew packages and casks according to global Brewfile, then upgrade all installed packages (greedy: also refresh :latest casks and greedy-outdated ones)
brew-upgrade-greedy:
    # Install packages missing from Brewfile
    brew bundle --global -v
    # Upgrade all installed packages (greedy: also refresh :latest casks and greedy-outdated ones)
    brew upgrade --yes --greedy
    @echo

# Cleanup Homebrew packages and casks according to global Brewfile, then remove unused dependencies and clean up old versions and cache
brew-cleanup:
    # Remove packages not in Brewfile
    brew bundle cleanup --global --force
    # Remove unused dependencies
    brew autoremove
    # Clean up old versions and cache
    brew cleanup
    @echo

# Dump current Homebrew packages to global Brewfile, keeping only intentional tools
dump-brew:
    #!/usr/bin/env fish
    set -l brewfile {{ justfile_directory() }}/brew/.Brewfile
    set -l keep /tmp/brewfile-keep-block
    set -l leaves /tmp/brewfile-leaves

    # 1) 暂存人工声明的意图块：从首个 @keep 标记到文件结尾，原样保留。
    #    必须在 dump 之前抢救出来，否则 brew bundle dump 会把整份文件重写掉。
    set -l marker_line (grep -n -m 1 '@keep' $brewfile | cut -d: -f1)
    if test -n "$marker_line"
        sed -n "$marker_line,\$p" $brewfile > $keep
    else
        printf '' > $keep
    end

    # 2) 重新 dump（Brewfile 此刻等于所有 installed_on_request 的包，含依赖噪音）
    brew bundle dump --global --force --no-vscode --no-go --no-cargo --no-npm --no-mas

    # 3) 剪枝：只保留 brew leaves —— 已安装且不是任何已安装包的依赖。
    #    brew bundle dump 的选取谓词是 installed_on_request，该位一旦置真永不被撤销，
    #    所以依赖会单向沉淀；改用 leaves 作为谓词可自愈。连带吃掉条目的描述注释行，
    #    否则留下孤儿注释。
    brew leaves | sort > $leaves
    awk -v LEAVES=$leaves '
        BEGIN { while ((getline l < LEAVES) > 0) L[l] = 1 }
        /^# / { c = c $0 "\n"; next }
        /^brew "/ {
            n = $0; sub(/^brew "/, "", n); sub(/".*$/, "", n)
            if (n in L) { printf "%s", c; c = ""; print } else { c = "" }
            next
        }
        { if (c != "") { printf "%s", c; c = "" }; print }
        END { if (c != "") printf "%s", c }
    ' $brewfile > $brewfile.new

    # 4) 组装：自动生成声明 + 顶层意图 + 人工意图块
    set -l tmp $brewfile.tmp
    echo "# AUTO-GENERATED by `just dump-brew`. Do not edit manually." > $tmp
    cat $brewfile.new >> $tmp
    if test -s $keep
        echo >> $tmp
        cat $keep >> $tmp
    end
    mv $tmp $brewfile
    rm -f $brewfile.new $leaves $keep

    # 5) 报告与自检：brew 条目数不该少于 brew leaves，差值即人工保留数
    set -l n_brew (grep -c '^brew ' $brewfile); or set n_brew 0
    set -l n_top (brew leaves | wc -l | tr -d ' ')
    set -l n_keep (math $n_brew - $n_top)
    if test $n_keep -lt 0
        echo "⚠ 剪枝异常：Brewfile 有 $n_brew 条，但 brew leaves 有 $n_top 条" >&2
    end
    echo "Brewfile: $n_brew 条 = 顶层 $n_top + 人工保留 $n_keep"

# Update rustup, rust toolchain, and cargo packages
update-rust:
    # Keeping rustup up to date
    rustup self update
    @echo

    # Keeping rust up to date
    rustup update
    @echo

    # Keeping rust packages up to date.
    cargo install-update -a
    @echo

# Install cargo packages from crates.txt manifest (for new machine setup)
install-cargo-crates:
    # Installing cargo packages from manifest
    grep -v '^#' {{ justfile_directory() }}/rust/.cargo/crates.txt | grep -v '^$$' | xargs -I {} cargo install {}
    @echo

# Install a cargo package and sync it to crates.txt
cargo-install pkg:
    # Installing cargo package: {{ pkg }}
    cargo install {{ pkg }}
    # Append package to crates.txt if not already present
    grep -qx '{{ pkg }}' {{ justfile_directory() }}/rust/.cargo/crates.txt || echo '{{ pkg }}' >> {{ justfile_directory() }}/rust/.cargo/crates.txt
    @echo

# Update AstroNvim and Mason packages
update-nvim:
    #!/usr/bin/env fish
    # Updating AstroNvim (skipped if nvim is not installed)
    if command -v nvim >/dev/null 2>&1
    nvim --headless "+AstroUpdate" "+MasonToolsUpdateSync" "+qa!" 2>&1 || echo "nvim/AstroNvim update failed (non-fatal)"
    else
    echo "nvim not installed; skipping"
    end

# Check outdated applications from App Store
update-apps:
    #!/usr/bin/env fish
    # Checking outdated applications from AppStore
    if test (uname) = Darwin
    mas outdated || true
    mas upgrade || echo "mas upgrade failed or nothing to update"
    else
    echo "App Store updates are macOS-only; skipping"
    end

# Update yazi plugins
update-yazi:
    # Update yazi plugins
    ya pkg upgrade
    @echo

# Update claude CLI
update-claude:
    # Update claude
    claude update
    @echo

# Update DingTalk Workspace CLI (dws)
update-dws:
    # Update DingTalk Workspace CLI (dws)
    dws upgrade -y
    @echo

# Update Bailian CLI & its plugins
update-bailian:
    # Update Bailian CLI
    bailian update
    @echo

# Update Skillshare CLI
update-skillshare:
    # Update Skillshare CLI
    skillshare upgrade --force
    @echo