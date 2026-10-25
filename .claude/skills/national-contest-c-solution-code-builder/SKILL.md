---
name: national-contest-c-solution-code-builder
description: 国赛C题解题代码生成技能。当已完成读题分析且需要生成求解代码时触发。触发关键词：写代码、生成代码、建模代码、按报告写代码、求解代码、分小问写代码、跑代码。核心铁则：自锚定路径（不依赖工作目录）、生成后必须实际运行验证、结果与报告交叉核对、交付审查清单供裁判复核。
---

# 国赛C题代码生成（V4）

## 前置条件

- 读题分析已完成：`题目报告/` 下有 task_split.md 与 model_suggest.md（本技能以报告为准，不擅自换模型）。
- 数据已清洗：使用 `数据预处理/clean/` 下的文件（如未清洗，先让用户运行数据清洗技能）。
- 本机具备 MATLAB（`matlab` 命令在 PATH 中）或 Python 3.9+（`python` 在 PATH 中，pandas/numpy/matplotlib/openpyxl 可用）；两者都没有时无法实际运行验证，必须明确告知用户。

## 五条铁则（违反任何一条即返工）

1. **自锚定路径**：所有读写路径必须从「代码文件自身位置」向上推导项目根 ROOT 再用 fullfile 拼接（模板见下节），代码放在任何目录、任何盘符、任何工作路径下运行都成功；禁止写死 `C:\`、`D:\` 等机器相关盘符路径，禁止依赖启动时的工作目录（cwd）。
2. **先跑后交**：每份代码生成后**必须实际运行**（`matlab -batch "run('...')"` 或 `python xxx.py`），报错→修复→重跑直到通过。禁止交付未运行验证的代码，禁止用"脑内仿真"代替真实运行。
3. **报告为准**：模型选型、实现平台、约束条件完全以 `题目报告/` 为准，禁止擅自换模型/换平台。
4. **结果核对**：运行后逐项核对输出——数值范围、单位、正负号、数量级与题目条件及数据常识比对；出现全0/全NaN/inf/越界/趋势反转立即定位修复。
5. **交付审查**：每问交付时输出《审查清单》（见文末模板），供裁判智能体复核；裁判退回的问题必须全部修复、重跑验证后再交付。

## 平台选择（MATLAB 优先，Python 可用）

- 用户熟悉 MATLAB：**能用 MATLAB 搞定的就用 MATLAB**；Python 仅在以下情况使用：报告指定 Python、需要 MATLAB 生态缺失的库（如 networkx 网络分析、geopandas 地图、seaborn 统计图）、或算法在 Python 侧明显更简洁。
- 无论哪个平台，可视化均按下方「图表规范」执行，产出质量对齐。
- Python 环境：使用 PATH 中的 `python`（建议 3.9+，需 pandas/numpy/matplotlib/openpyxl）；不要在代码里写死解释器的绝对安装路径。

## 路径规范（自锚定，消灭"首次运行失败"与"换机器就崩"）

项目根 = 本仓库克隆目录（内含 题目/、题目报告/、数据预处理/、代码/、论文/ 等）。生成的代码**从自身文件位置向上推导 ROOT**，而不是假设任何固定安装路径：

```matlab
% MATLAB：本文件位于 代码/QN/ 下，向上一级即项目根
thisFile = mfilename('fullpath');
ROOT     = fileparts(fileparts(thisFile));            % 代码/QN -> 代码 -> 项目根
dataDir  = fullfile(ROOT, '数据预处理', 'clean');
outDir   = fullfile(ROOT, '代码', '问题N');            % N=题号
if ~exist(outDir,'dir'), mkdir(outDir); end
resultPath = fullfile(outDir, 'result_qN.xlsx');
```

```python
# Python：本文件位于 代码/QN/ 下，向上两级即项目根
from pathlib import Path
ROOT     = Path(__file__).resolve().parents[2]        # 代码/QN -> 代码 -> 项目根
data_dir = ROOT / '数据预处理' / 'clean'
out_dir  = ROOT / '代码' / '问题N'
out_dir.mkdir(parents=True, exist_ok=True)
result_path = out_dir / 'result_qN.xlsx'
```

- 依赖前问结果：`fullfile(ROOT,'代码','问题M','result_qM.xlsx')`；文件不存在时报中文错误并说明需先跑哪一问，禁止静默用默认值继续算。
- 运行无需 cd：自锚定路径保证任意 cwd 可运行；agent 验证命令示例 `matlab -batch "run('D:/任意路径/代码/Q1/Q1_1.m')"` 或 `python 代码/Q1/Q1_1.py`。
- 若层级不确定（代码不在 `代码/QN/` 两级结构下），在代码开头用 `disp(ROOT)` / `print(ROOT)` 自检一次，确认指向项目根后再继续。

## 工作流（每问顺序执行）

1. **读报告**：完整读取 `题目报告/` 相关文档，提取该问首选模型、平台、全部约束（显性+隐性+边界）、必须输出项、与前问依赖关系。
2. **读数据**：确认所用 `数据预处理/clean/` 文件存在、列名与代码一致。
3. **写代码**：单文件、分节注释（数据加载→可选前序结果→参数→模型求解→核心结果可视化→Excel输出），关键步骤中文注释，固定随机种子（MATLAB `rng(42)` / Python `random.seed(42)` 或 `np.random.seed(42)`，实际使用的种子值写进审查清单），优化/迭代设最大次数与收敛阈值。
4. **实际运行**：立即运行→修复→重跑，直到无报错且输出齐全（Excel 生成、图窗弹出）。
5. **结果核对**：对照报告约束与数据常识核对数值（铁则4），输出自检结论。
6. **交付**：代码 + result_qN.xlsx + review_qN.md 审查清单。

## 图表规范（顶刊级，直接套用，禁止 MATLAB/Python 默认样式）

依据 Nature/Science 级视觉规范提炼：数据至上、少即是多、色彩克制（全图 3-5 种主色）、对比鲜明（深灰轴线文字替代纯黑）、字体一致（全图 ≤2 种字体）。

### MATLAB 绘图模板

```matlab
C = [0.122 0.227 0.576;   % C1 皇家蓝 #1F3A93
     0.953 0.612 0.071;   % C2 金黄   #F39C12
     0.153 0.682 0.376;   % C3 森林绿 #27AE60
     0.753 0.224 0.169;   % C4 深红   #C0392B
     0.459 0.439 0.702;   % C5 紫罗兰 #7570B3
     0.549 0.337 0.294];  % C6 棕     #8C564B
GRAY = [0.2 0.2 0.2];     % 轴线/刻度深灰，替代纯黑
figure('Color','w','Position',[100 100 920 620]); hold on; box off;   % box off = 去顶/右边框
ax = gca;
ax.FontName='Microsoft YaHei'; ax.FontSize=10; ax.LineWidth=0.8;  % 无中文字符的图改 'Arial'；非 Windows 系统改系统可用中文字体
ax.XAxis.Color=GRAY; ax.YAxis.Color=GRAY;
ax.TickDir='in'; ax.TickLength=[0.015 0.015];
grid on; ax.GridLineStyle='--'; ax.GridAlpha=0.4; ax.GridColor=[0.8 0.8 0.8];
plot(x, y1, '-'  , 'Color',C(1,:), 'LineWidth',2.0);
plot(x, y2, '--o', 'Color',C(2,:), 'LineWidth',1.5, 'MarkerSize',5, 'MarkerFaceColor',C(2,:));
xlabel('自变量（单位）','FontWeight','bold','FontSize',11);
ylabel('因变量（单位）','FontWeight','bold','FontSize',11);
title('问题N：<对象+变量+区间/方法>','FontWeight','bold','FontSize',14);
lg = legend({'系列1（物理含义）','系列2（物理含义）'},'Location','northeast');
lg.Box='off'; lg.FontSize=9;
```

### Python (matplotlib) 绘图模板

```python
import matplotlib.pyplot as plt
from matplotlib import rcParams
rcParams.update({
    'font.family': 'sans-serif',
    'font.sans-serif': ['Microsoft YaHei', 'SimHei', 'Arial'],  # 无中文字体的系统会自动回退 Arial，中文标签改为英文
    'font.size': 10, 'axes.linewidth': 0.8, 'axes.unicode_minus': False,
    'axes.labelsize': 11, 'axes.titlesize': 14,
    'xtick.labelsize': 9, 'ytick.labelsize': 9, 'legend.fontsize': 9,
})
PALETTE = ['#1F3A93', '#F39C12', '#27AE60', '#C0392B', '#7570B3', '#8C564B']

def style_axes(ax):
    ax.spines['top'].set_visible(False); ax.spines['right'].set_visible(False)
    ax.spines['left'].set_color('#333333'); ax.spines['bottom'].set_color('#333333')
    ax.grid(axis='y', linestyle='--', linewidth=0.5, color='#CCCCCC', alpha=0.5)
    ax.set_axisbelow(True)
```

### 图表选型（高级感优先，清晰为前提）

核心原则：**图要能反映问题**。动笔前先回答"读者 10 秒内要从这张图看懂什么结论"，再选图型。同一篇论文图表类型必须多样化，禁止清一色柱状/折线图；柱状图是保底选项，仅当类别对比且无更合适图型时使用。高级图型若导致信息表达不清，果断退回基础图——清晰 > 高级。

| 分析场景 | 首选高级图型 | 保底图型 |
|---------|-------------|---------|
| 多维指标综合对比 | 雷达图（≤4 组、先标准化） | 分组柱状图 |
| 排名对比 | 棒棒糖图；两时点/两方案用哑铃图 | 条形图 |
| 相关性/关联 | 相关矩阵热力图（带显著性星号） | 数值表格 |
| 比例构成 | 环形图 / 树状图 treemap | 饼图 |
| 流量/状态转移 | 桑基图 | 堆叠柱状图 |
| 网络/关系 | 网络图（节点大小=度，颜色=社区） | 邻接矩阵 |
| 分布对比 | 小提琴图（内嵌箱线） | 箱线图 |
| 两变量关系+分布 | 散点+边际分布联合图 | 散点图 |
| 多序列时间演化 | 堆叠面积图 / 河流图 | 多条折线 |
| 迭代/优化过程 | 收敛曲线（目标值含阴影带） | 单折线 |
| 灵敏度/参数分析 | 热力图 / 龙卷风图 | 逐参数折线 |
| 空间分布 | 分级/散点地图、热力地图 | 表格 |
| 调度/时间安排 | 甘特图 | 时间表 |
| 聚类结果 | 散点+置信椭圆 / 轮廓系数图 | 着色散点 |
| 3D 函数/曲面 | 曲面图+底部等高线投影 | — |
| 层次/决策结构 | 树状图 / 决策流程图 | 文字描述 |

平台支持：
- MATLAB 直接实现：雷达图(polarplot)、热力图(heatmap/pcolor)、曲面+等高线、气泡图(bubblechart)、网络图(digraph+plot)、甘特图(barh 组合)、小提琴图(violinplot，低版本无则 boxplot+KDE 填充替代)。
- MATLAB 缺库的图型（桑基图、弦图、河流图、treemap、联合分布图）：按「平台选择」规则转 Python 用 matplotlib/plotly 实现，风格仍按本规范对齐。

### 分图表类型要点

- **柱状图**：柱宽=间距的 60-80%、描边深灰 0.8pt、柱顶数值标签 8pt、Y 轴从 0 开始；单系列用一种主色，重点柱主色+其余浅灰衬托；禁 3D 柱图。
- **折线图**：主线 1.5-2.0pt；数据点 ≤50 全加标记、>50 只标关键点；拟合/预测用虚线，R²、p 值标在图内；置信带同色 alpha 0.15-0.25；>5 条线改分面子图。
- **散点/气泡**：alpha 0.6-0.8 防遮挡、点缘深灰 0.3-0.5pt；第三变量映射点大小(20-2000)或颜色+colorbar；点数 >500 改密度图（hexbin/KDE）。
- **热力图/相关矩阵**：正方形单元、格内标数值(7-9pt)；相关系数用蓝-白-红（center=0, vmin=-1, vmax=1），连续数据用 viridis/parula；colorbar 标注单位；禁 jet。
- **箱线/小提琴图**：箱体主色填充 alpha 0.5-0.7、中位线加粗、均值菱形标记；图注标样本量 n 与检验方法。
- **饼图/环形图**：类别 ≤7、startangle=90 顺时针、最关键扇区突出(explode 0.05)；环形图中心放总量；仅用于 100% 占比数据，非占比用柱状图。
- **雷达图**：维度 3-8、轮廓 2.0pt+填充 alpha 0.15-0.25、对比组 ≤4、量纲必须先标准化。
- **3D 曲面**：视角 elev 20-30°/azim 30-60°、底部等高线投影、colorbar 含单位、shade 立体感；禁 3D 柱图。
- **流程图**（问题分析/方法框架必备）：分区配色——输入蓝(#E3F2FD/#1565C0)、过程绿(#E8F5E9/#2E7D32)、决策橙(#FFF3E0/#E65100)、模块紫(#F3E5F5/#6A1B9A)、输出红(#FCE4EC/#AD1457)；节点圆角矩形、文字 ≤8 词动词开头；主流程方向全图统一（上→下或左→右）；箭头标注语义（输入/输出/反馈/迭代），反馈回路用虚线；节点 >20 拆分图。
- **空间分布图**：底图浅灰填充、colorbar 标单位；中国地图必须含台湾省与南海九段线。

### 通用硬规则

- 多系列必须「颜色 + 线型/标记」双重区分；图例写清物理含义（禁 series1/2），无边框、不遮数据、面积 ≤ 图区 25%。
- 轴标签必带单位；仅主网格、虚线浅灰；标题=对象+变量+区间/方法，禁无信息量标题。
- 字号梯度：标题 14 > 轴标签 11 > 刻度/图例 9 > 数据标签 8，全图最小 7pt。
- 数据保真：只改视觉不改数据——禁为美观改坐标范围、删数据点、更换图表类型。
- 禁用色板：jet、rainbow、hsv 及一切彩虹色；双向数据禁 RdYlGn。
- **出图数量：每一小问至少 3 张图**，每张必须有直接进论文的分析价值，禁止凑数空图。三类覆盖建模全流程：
  1. 输入/依据图：数据分布、预处理前后对比、相关性热力图等，支撑论文"分析先行"与模型选择依据
  2. 过程/方法图：收敛曲线、误差变化、参数敏感性、方案对比等，支撑求解过程可信度
  3. 结果/结论图：题目要求回答的最终结论可视化（核心结果强制出图要求不变）
- 某小问确实产不出 3 张有意义的图：在 review_qN.md 写明原因，由裁判裁定；禁止生成无信息量的重复图凑数。
- 每张图在图窗 Name 属性（MATLAB figure('Name',...)）或窗口标题中标注建议文件名（如 fig_q1_1_核心结果对比），用户按名保存到 `论文/figures/`，论文侧按名引用。
- **禁止任何自动保存图片语句**（saveas/print/exportgraphics/savefig/plt.savefig），图形仅弹窗，由用户手动保存；手动导出时选 300 DPI PNG。

## Excel 输出

- `result_qN.xlsx` 双 Sheet：Sheet1「核心结果」= 题目要求回答的最终结论与关键指标；Sheet2「模型参数」= 权重/系数/超参数/聚类中心。带表头与字段说明。
- MATLAB 用 writetable（第二张表 'WriteMode','append'），Python 用 pandas.ExcelWriter。

## 审查清单模板（每问随代码输出 `代码/QN/review_qN.md`）

```
# 第N问审查清单
- 模型/平台：与报告首选是否一致
- 数据来源：所用 clean/ 文件与关键列
- 关键假设：标签构造、映射关系、折算系数等（每条写明依据，禁止无依据推断）
- 约束核对：报告约束逐条覆盖情况
- 运行状态：已实际运行 通过 / 修复了什么问题
- 随机种子：实际使用的固定种子值
- 图表选型：各图图型与对应场景；选型表首选图型未采用时说明退回保底的理由；全篇无清一色柱状/折线
- 出图清单：每图的建议文件名、图型、展示内容（每小问 ≥3 张；供论文撰写直接引用）
- 结果范围：主要输出数值区间 + 与题目逻辑一致性说明
```

## 裁判流程（审查方按此执行）

裁判读取：代码 + review_qN.md + result_qN.xlsx + 报告对应小问，核对五项：
1. 模型实现与报告一致；2. 路径全部自锚定（无机器相关盘符、不依赖 cwd）且数据文件真实存在；3. 假设合理性（重点审标签构造与映射，是否存在数据泄露）；4. 数值范围与单位常识；5. Excel 双 Sheet 与图表规范完整。
裁决输出 `代码/诊断报告/verdict_qN.md`：通过 / 退回（问题清单+可执行修改指令）。退回项由生成方修复、重跑验证后再审。
