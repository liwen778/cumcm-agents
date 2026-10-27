# cumcm-agents · 数学建模国赛双智能体协作工作流

一套面向全国大学生数学建模竞赛（国赛 C 题流程为主，其他题型同样适用）的开源协作方案：

- **5+1 个 Skill（技能提示词）**：读题分析 → 数据清洗 → 代码生成 → 论文撰写 → 裁判审查，覆盖建模全流程；
- **双智能体协作模式**：一个智能体当"选手"（干活），一个当"裁判"（独立复核），互不轻信；
- **可直接编译的 LaTeX 模板**：国赛（`latex模板/`）与 MathorCup（`MathorCup模板/`）两套，同一套版式，均已做跨平台字体兼容与一键编译脚本。

> 零路径配置：全部 Skill 与文档均使用**相对路径**，克隆到任何位置、叫任何名字都能直接用。

---

## 目录结构

```
数学建模/
├── README.md                  # 本文件
├── CLAUDE.md                  # 选手智能体加载的写作/代码规范（去AI味规则）
├── 双智能体工作流使用手册.md      # 完整流程：从拿到题目到交卷
├── 比赛日速查.md                # 比赛当天的精简操作卡
├── .claude/skills/            # Claude Code（选手侧）技能库
├── .hermes/skills/            # Hermes（裁判侧）技能库，内容与左侧一致
├── latex模板/                  # 国赛/CUMCM 模板：JXUSTmodeling.cls + 干净骨架 main.tex（含AI声明章节）+ code/ 示例代码 + 一键编译脚本
├── MathorCup模板/               # MathorCup（妈妈杯）模板：同版式 + 目录页 + 正文页码从1起 + AI声明后置 + 附录软件清单
├── AI使用报告模板/               # 国赛官方要求的《AI工具使用详情》报告模板（Word）及配套使用说明
└── 优秀论文/                    # 放你自己的范文 PDF；蒸馏出的《写作规范.md》在这里
```

`.claude/skills/` 与 `.hermes/skills/` 内容保持一致，各含 6 个技能：

| 技能 | 角色 | 用途 |
|------|------|------|
| `national-c-problem-analysis` | 裁判主笔 | 读题拆解、9 大题型建模推荐、坑点预警、论文素材 |
| `dataclean` | 选手执行 | 数据体检与清洗，产出可复跑的清洗代码与报告 |
| `national-contest-c-solution-code-builder` | 选手执行 | 逐问生成求解代码，实际运行验证后交付 |
| `national-c-paper-writer` | 选手执行 | 按七步闭环逐问撰写 LaTeX 论文 |
| `national-c-judge-review` | 裁判专用 | 代码/论文独立审查，输出可执行的退回意见 |
| `.claude/skills/README.md` | — | Skill 目录格式说明 |

## 快速开始

### 0. 环境要求

| 依赖 | 用途 | 说明 |
|------|------|------|
| [Claude Code](https://claude.com/claude-code) | 选手智能体 | 必需；在本目录下运行 `claude` 即自动加载 `.claude/skills/` 与 `CLAUDE.md` |
| Hermes（裁判智能体） | 裁判 | 可选；独立工具需另行安装配置。没有 Hermes 时，可把 `.hermes/skills/national-c-judge-review` 复制到 `.claude/skills/`，用第二个 Claude Code 会话当裁判 |
| TeX Live 2023+（full 安装）或 MiKTeX | 论文编译 | 国赛编译入口见 `latex模板/README.md`，MathorCup 见 `MathorCup模板/README.md`；西文缺 Times New Roman 时自动回退开源字体；中文在 Windows 下用系统宋体、非 Windows 回退 Fandol，无需改设置 |
| MATLAB R2019b+（含常用工具箱） | 求解代码 | 推荐；未安装时让智能体生成 Python 版代码 |
| Python 3.9+（pandas / numpy / matplotlib / openpyxl） | 备选平台 | `python` 需在 PATH 中 |

### 1. 拿到本仓库后

```powershell
# Windows（PowerShell）—— 克隆或解压到任意位置，例如：
cd D:\mcm-workspace\数学建模

# 裁判智能体（可选，仅首次）：信任本目录
hermes skills trust "$PWD"
```

### 2. 比赛时的两个终端

```powershell
# 窗口A（选手）
cd 你的项目目录
claude

# 窗口B（裁判，可选）
cd 你的项目目录
hermes
```

把题目 PDF/Word 和附件放进 `题目\` 文件夹（目录不存在就新建），然后对窗口A或窗口B说「读题，做完整拆解分析」即可启动流程。完整的阶段划分、每步说什么话、产出什么文件，见《双智能体工作流使用手册.md》；比赛当天只看《比赛日速查.md》。

### 3. 先验证 LaTeX 能编译

```powershell
cd latex模板        # 国赛模板
./build.bat      # Windows
./build.sh       # macOS / Linux

cd ..\MathorCup模板   # MathorCup 模板（同样的命令）
./build.bat
```

看到 `build OK: main.pdf` 即模板可用。论文阶段的正式工作区是 `论文\`（把模板复制过去使用，见手册阶段 5）。

### 4. 两套模板怎么选

两套模板版式同源（字体、字号、行距、章节编号、图表标题、附录代码样式完全一致），差别只在赛事规范要求的页面结构：

| | `latex模板/`（国赛/CUMCM） | `MathorCup模板/`（妈妈杯） |
|---|---|---|
| 首页 | 题目 + 摘要 + 关键词 | 队伍编号/题号 + 题目 + 摘要 + 关键词 |
| 目录 | 无（可选） | **必需，固定第 2 页** |
| 页码 | 从首页起算 | **从正文起算**，首页与目录不编号 |
| 页眉 | 无 | 无（规范强制） |
| AI 声明 | 参考文献**之前** | 参考文献**之后**，且参考文献需增列工具条目 |
| 附录 | 文件明细 + 代码 | 文件明细 + **软件与运行命令** + 代码 |

拿不准时看赛事当年的《论文格式及提交规范》原文，两条硬性差异是"目录页位置/页码起算"和"AI 声明位置"。

## 路径约定（为什么不需要改任何路径）

- 所有 Skill、文档使用**项目内相对路径**（`题目/`、`题目报告/`、`数据预处理/clean/`、`代码/QN/`、`论文/`）。相对路径一律相对于**项目根 = 你启动智能体时所在的目录**，因此请始终在项目根目录启动 `claude` / `hermes`。
- 生成的求解代码不依赖工作目录：MATLAB/Python 模板会**从代码文件自身位置向上推导项目根**，代码放在任何目录、任何盘符都能跑。
- 首次运行时缺失的目录（`题目/`、`论文/figures/` 等）由智能体按需创建，仓库里不预置空目录。

## 给维护者的提醒

`.claude/skills/` 与 `.hermes/skills/` 是同一套技能的两份副本（两个智能体各自从自己的目录加载）。**修改任一技能后请同步另一侧**，保持逐字节一致，避免两侧行为漂移。

## 致谢与许可

- [JXUSTmodeling](https://github.com/sikouhjw/JXUSTmodeling) LaTeX 模板类，原作者 sikouhjw、XAjzh，本项目在其基础上做了字体兼容与注释通用化；
- 《优秀论文/写作规范.md》蒸馏自公开渠道可查的国赛/竞赛优秀论文，仅用于方法学习，范文 PDF 本体因版权不入库，请自行收集后放入该目录；
- 本项目代码与文档以 MIT 许可发布（见 LICENSE）。
