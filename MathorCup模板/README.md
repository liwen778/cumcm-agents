# MathorCup 论文模板使用说明

面向 MathorCup 数学应用挑战赛（妈妈杯）的 LaTeX 论文模板。版式与仓库里的国赛模板（`latex模板/`）**同一套**：字体、字号、行距、章节编号（一、/1.1）、图表标题黑体五号、附录代码样式全部一致，只按 MathorCup 官方规范补上了"目录页 + 正文重新编页码"等结构差异。

## 文件构成

| 文件/目录 | 作用 |
|-----------|------|
| `MathorCupmodeling.cls` | 论文类文件（控制版式：首页题目/摘要、目录页、页码起算、章节编号"一、"、图表标题黑体等），由 `latex模板/JXUSTmodeling.cls` 改写 |
| `main.tex` | 干净骨架：首页信息 + 摘要 + 目录 + 各章节占位 + 参考文献 + AI 声明 + 附录，比赛时逐问填充 |
| `code/` | 附录代码目录（`q1.m`、`q1.py` 为示例）；附录B 用 `\lstinputlisting` 从这里拉入代码 |
| `figures/` | 图片目录（论文里 `\includegraphics{文件名}` 默认在此查找；`KingL.png` 为占位图） |
| `build.bat` / `build.sh` | 一键编译脚本（xelatex 跑两遍，使目录/交叉引用收敛） |
| `模板说明.md` | 保留了哪些图表格式、AI 声明位置等结构说明 |

## 与官方规范的对应关系

依据《2026 年第十六届 MathorCup 数学应用挑战赛论文格式及提交规范》（组委会 2026 年 4 月修订）与《MathorCup 数学应用挑战赛人工智能工具使用规定（试行）》：

| 官方要求 | 模板实现 | 改动位置 |
|----------|----------|----------|
| 论文题目、摘要、关键词写在第一页 | `abstract` 环境（首页顶部含官方模板的"队伍编号 / 题号"） | `main.tex` 摘要段 |
| **第二页为目录页** | `\mulu` 命令：另起一页出目录，行距自适应保证落在一页内 | 摘要之后一行 |
| 目录之后开始正文，**页码从 1 起** | `\mulu` 内自动 `\pagenumbering{arabic}` | 类文件 `\mulu` |
| 页码位于每页页脚中部 | `\pagestyle{plain}`（页脚居中阿拉伯数字） | 类文件 |
| **论文不能有页眉** | 全文未设页眉，前置页 `\pagestyle{empty}` | 类文件 `\AtBeginDocument` |
| 不能出现学校、个人信息 | 模板不含任何单位/姓名栏位 | — |
| 正文控制在 30 页左右，附录不限 | 单文件 main.tex，示例骨架约 8 页 | — |
| 参考文献按引用顺序编号，正文方括号标注 | `natbib` + 手工 `thebibliography`，上标方括号 | 类文件 + `main.tex` 参考文献段 |
| 附录须给出软件名称、命令、全部源程序 | 附录A（A.1 软件与环境 / A.2 文件明细 / A.3 运行命令）+ 附录B 代码 | `main.tex` 附录段 |
| **AI 声明放在参考文献之后** | `AI工具使用声明` 节位于参考文献与附录之间 | `main.tex` 参考文献之后 |

## 与国赛模板（`latex模板/`）的差异

只有四处，其余版式完全相同：

1. **多出目录页**：国赛模板无目录；本模板首页后固定一页目录，且目录页不编页码。
2. **页码从正文起算**：首页与目录页无页码，正文第一页显示"1"。
3. **AI 声明位置相反**：国赛要求在参考文献**之前**，MathorCup 要求在参考文献**之后**（并且使用 AI 时须在参考文献中增列工具条目）。
4. **首页多"队伍编号 / 题号"**：取自官方 Word 模板；不需要时在 `main.tex` 导言区写 `\renewcommand{\mukuai}{}` 隐藏。

## 环境要求

- **TeX 发行版**：TeX Live 2023 或更新（推荐 full 完整安装），或 MiKTeX（编译时自动装包）。用到的宏包：`ctex`、`fontspec`、`physics`、`siunitx`、`booktabs`、`tabularx`、`caption`、`subcaption`、`placeins`、`enumitem`、`natbib`、`listings`、`hyperref`、`mwe`、`longtable`、`threeparttable`、`pythonhighlight`。
- **编译引擎**：必须用 **XeLaTeX**（类文件依赖 fontspec 与 ctex）。
- **中文字体**：类文件自动判断——Windows 有宋体时直接用 **宋体/黑体/楷体/仿宋**（PDF 中的中文可复制、可检索，粗体用 `AutoFakeBold` 模拟），没有时回退到 ctex 自带的 Fandol 开源字体族，两条路径都能编译，**无需手动改字体**。
- **西文字体**：优先 Times New Roman，系统没有时自动回退到发行版自带的 TeX Gyre Termes。

## 编译方法（三选一）

```powershell
# 1) 一键脚本（推荐）
cd MathorCup模板
./build.bat        # Windows
./build.sh         # macOS / Linux / Git Bash

# 2) 命令行手动编译（必须连跑两遍，目录与页码才会收敛）
xelatex -interaction=nonstopmode main.tex
xelatex -interaction=nonstopmode main.tex

# 3) VS Code：装 LaTeX Workshop 插件，选择 "XeLaTeX" recipe 编译
```

看到 `build OK: main.pdf` 或日志末尾 `Output written on main.pdf` 即成功。

## 常见问题

| 现象 | 原因与处理 |
|------|-----------|
| 目录跑到了第 3 页 | 摘要超过一页（本版式首页约放得下 1000 字摘要 + 关键词行），把摘要压到一页内；或目录条目过多，减少 `\subsection`、或在导言区改用 `\setcounter{tocdepth}{1}` 只显示一级标题 |
| 正文第一页没有显示"1" | 忘记调用 `\mulu`。`\mulu` 同时负责出目录和把页码切到从 1 起算，必须在摘要之后调用 |
| 想改成官方 Word 模板的"第 X 页 共 Y 页"页脚 | 导言区加 `\usepackage{lastpage}\usepackage{fancyhdr}` 并 `\fancypagestyle{plain}{\fancyhf{}\fancyfoot[C]{第 \thepage 页 共 \pageref{LastPage} 页}\renewcommand{\headrulewidth}{0pt}}`；规范只要求"页脚中部阿拉伯数字"，默认的纯数字更稳妥 |
| 正文引用想用内联方括号（非上标） | 把类文件的 `\setcitestyle{square,super}` 改为 `\setcitestyle{square}` |
| `File 'MathorCupmodeling.cls' not found` | **main.tex 与 MathorCupmodeling.cls 必须在同一目录**编译；把 main.tex 复制到 `论文/` 时请把 cls 一并复制 |
| 代码块里的中文注释显示为空白 | 只在极旧的发行版上出现；类文件已用 `\setCJKmonofont` 指定等宽环境的中文字体。若仍异常，把该行改为本机存在的字体 |
| 图片找不到 | 图片放入 `figures/` 子目录，`\includegraphics{文件名}` 不带路径与扩展名 |
| 引用显示 "？?" | 需要**第二遍**编译解析交叉引用；脚本已自动跑两遍 |

## 论文工作区约定

`MathorCup模板/` 是**母本目录**，保持干净勿动。实际写作在项目根新建 `论文/` 目录进行：

1. 新建 `论文/`，把 `main.tex`、`MathorCupmodeling.cls` 复制进去，并把 `code/`、`figures/` 一并复制；
2. 在 `论文/` 目录内编译（可用相同脚本或命令）；
3. 提交前按官方命名：`#MC*******.pdf`（`#` 为题号），例如 `AMC2600001.pdf`。
