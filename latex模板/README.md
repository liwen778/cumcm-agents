# LaTeX 模板使用说明

## 文件构成

| 文件/目录 | 作用 |
|-----------|------|
| `JXUSTmodeling.cls` | 论文类文件（控制版式：标题、摘要、章节编号"一、"、图表标题黑体等），基于开源 [sikouhjw/JXUSTmodeling](https://github.com/sikouhjw/JXUSTmodeling) |
| `main.tex` | 干净骨架：各章节占位 + TODO 引导注释，含官方要求的"AI工具使用声明"章节；比赛时逐问填充 |
| `code/` | 附录代码目录（`q1.m`、`q1.py` 为示例）；附录B 用 `\lstinputlisting` 从这里拉入代码 |
| `figures/` | 图片目录（论文里 `\includegraphics{文件名}` 默认在此查找；`KingL.png` 为占位图） |
| `build.bat` / `build.sh` | 一键编译脚本（xelatex 跑两遍，使目录/交叉引用收敛） |
| `模板说明.md` | 保留了哪些图表格式、AI 声明位置等结构说明 |

## 环境要求

- **TeX 发行版**：TeX Live 2023 或更新（推荐 full 完整安装），或 MiKTeX（编译时自动装包）。模板用到的宏包：`ctex`、`fontspec`、`physics`、`siunitx`、`booktabs`、`tabularx`、`caption`、`subcaption`、`placeins`、`enumitem`、`natbib`、`listings`、`hyperref`、`mwe`、`longtable`、`threeparttable`、`pythonhighlight`。
- **编译引擎**：必须用 **XeLaTeX**（类文件依赖 fontspec 与 ctex 的 fontset=fandol，pdfLaTeX 无法编译）。
- **中文字体**：`main.tex` 导言区的 `\setCJKmainfont[BoldFont={SimHei}, ItalicFont={KaiTi}]{SimSun}` 使用 Windows 自带字体（宋体/黑体/楷体）。**Windows 用户无需任何设置**；Linux/macOS 用户请将该行替换为本机可用的中文字体，或直接删除该行（删除后由类文件的 Fandol 开源字体族接管，均可正常编译）。
- **西文字体**：优先 Times New Roman，系统没有时（常见于 Linux/macOS）自动回退到发行版自带的 TeX Gyre Termes，两种情况都能编译。

## 编译方法（三选一）

```powershell
# 1) 一键脚本（推荐）
cd latex模板
./build.bat        # Windows
./build.sh         # macOS / Linux / Git Bash

# 2) 命令行手动编译（必须连跑两遍）
xelatex -interaction=nonstopmode main.tex
xelatex -interaction=nonstopmode main.tex

# 3) VS Code：装 LaTeX Workshop 插件，选择 "XeLaTeX" recipe 编译
```

看到 `build OK: main.pdf` 或日志末尾 `Output written on main.pdf` 即成功。

## 常见问题

| 现象 | 原因与处理 |
|------|-----------|
| `File 'JXUSTmodeling.cls' not found` | **main.tex 与 JXUSTmodeling.cls 必须在同一目录**编译。把 main.tex 复制到别处（如论文工作区 `论文/`）时，请把 cls 一并复制过去 |
| `Fatal error occurred, no output PDF` 且日志有 `font` 字样 | 用错了引擎（pdfLaTeX）。改用 xelatex；或在非 Windows 系统上未处理中文字体设置，见上文字体说明 |
| 中文出现乱码 | 文件必须保存为 UTF-8 编码（本模板默认如此） |
| 引用显示 "？?" | 正常现象：需要**第二遍**编译解析交叉引用；脚本已自动跑两遍 |
| 图片找不到 | 图片放入 `figures/` 子目录，`\includegraphics{文件名}` 不带路径与扩展名 |
| 附录代码缺失/报错找不到 q1.m | `main.tex` 附录B 从 `code/` 目录取代码；把你的代码文件放入该目录或修改附录B 中两处路径 |
| MiKTeX 停下来问装包 | 选择"总是安装"（或改用 TeX Live full 一次装齐） |

## 论文工作区约定

`latex模板/` 是**母本目录**，保持干净勿动。实际写作在项目根的 `论文/` 目录进行：

1. 新建 `论文/`，把 `main.tex`、`JXUSTmodeling.cls` 复制进去，并把 `code/`、`figures/` 一并复制（或新建同名目录）；
2. 在 `论文/` 目录内编译（可用相同脚本或命令）；
3. 论文写作技能（national-c-paper-writer）会自动执行以上步骤。
