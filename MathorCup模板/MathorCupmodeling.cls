%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% github:https://github.com/liwen778/cumcm-agents
% MathorCup 论文类文件（MathorCupmodeling.cls）
% 由同仓库 JXUSTmodeling.cls（原作者 sikouhjw、XAjzh）改写而来：
%   · 字体、字号、行距、章节格式（一、1.1）、图表标题、代码附录样式与母本完全一致；
%   · 按《2026 年第十六届 MathorCup 数学应用挑战赛论文格式及提交规范》新增：
%       第 1 页    题目 + 摘要 + 关键词（不编页码）
%       第 2 页    目录（不编页码）
%       第 3 页起  正文，页脚中部阿拉伯数字页码，自 1 起连续编号
%     全文不设页眉（规范第 3 条）。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{MathorCupmodeling}[2026/10/27 version 1.0 MathorCup paper class]

\LoadClass[oneside,a4paper,UTF8,zihao=-4,fontset=fandol]{ctexart}

\RequirePackage{amsmath,amssymb}
\RequirePackage{esint}

% ==================== 字体 ====================
% 中文：Windows 下直接使用系统宋体/黑体/楷体/仿宋（PDF 文字可复制、可检索，
%   粗体用 AutoFakeBold 模拟，观感与母本的 FandolSong-Bold 一致）；
%   系统没有这些字体时（Linux/macOS 常见）自动沿用 ctex fontset=fandol 的
%   开源字体族（FandolSong/FandolHei/FandolKai/FandolFang），编译不会中断。
% 西文与数字：优先 Times New Roman；缺失时回退 TeX Gyre Termes（Times 同度量替身）。
\IfFontExistsTF{SimSun}{
	\setCJKfamilyfont{zhsong}[AutoFakeBold=2.5]{SimSun}
	\setCJKfamilyfont{zhhei}[AutoFakeBold=2]{SimHei}
	\setCJKfamilyfont{zhkai}{KaiTi}
	\setCJKfamilyfont{zhfs}{FangSong}
	% 等宽环境（代码块、\texttt）中的中文：宋体。
	% 若不指定，listings 会用 fontset 自带的等宽中文字体，中文注释可能显示为空白。
	\setCJKmonofont{SimSun}
}{}
\IfFontExistsTF{Times New Roman}
	{\setmainfont{Times New Roman}}          % Windows / 装有该字体的系统
	{\setmainfont{TeX Gyre Termes}}          % 开源回退，编译不因缺字体中断

% 行距：与母本一致（对齐常见数模论文的 Word 行距观感）
\linespread{1.38}

% 设置章节格式（一级标题宋体加粗 15pt/21pt 居中、编号“一、”；二三级标题宋体加粗 12pt/18pt 左对齐）
\ctexset{
	section={
		format={\centering\songti\bfseries\fontsize{15}{21}\selectfont},
		name={,、},
		number=\chinese{section},
		aftername={\hspace{0pt}},
		beforeskip=1.7\baselineskip,
		afterskip=0.9\baselineskip
	},
	subsection={
		format={\raggedright\songti\bfseries\fontsize{12}{18}\selectfont},
		aftername={\quad},
		number={\arabic{section}.\arabic{subsection}},
		beforeskip=1.25\baselineskip,
		afterskip=0.65\baselineskip
	},
	subsubsection={
		format={\raggedright\songti\bfseries\fontsize{12}{18}\selectfont},
		aftername={\quad},
		number={\arabic{section}.\arabic{subsection}.\arabic{subsubsection}},
		beforeskip=1.05\baselineskip,
		afterskip=0.55\baselineskip
	},
	appendix={
		name={附录,：},
		number=\arabic{section},
	}
}

% ==================== 首页信息 ====================
% \duiwu{参赛队号}\tihao{A}\biaoti{论文题目}\keyword{关键词}
\def\duiwu#1{\gdef\@duiwu{#1}}
\def\tihao#1{\gdef\@tihao{#1}}
\def\biaoti#1{\gdef\@biaoti{#1}}
\def\keyword#1{\gdef\@keyword{#1}}
\gdef\@duiwu{MC0000000}
\gdef\@tihao{A}
\gdef\@biaoti{（论文题目）}
\gdef\@keyword{}

% ==================== 摘要（第 1 页） ====================
% 规范：题目、摘要、关键词写在论文第一页上；本页不编页码。
% 首页顶部的“队伍编号/题号”取自官方 Word 模板；不需要时在 main.tex 导言区写
% \renewcommand{\mukuai}{} 即可整块隐藏。
\newcommand{\mukuai}{%
	\begingroup\centering\zihao{5}\songti
		队伍编号\quad\@duiwu\hspace{3em}题号\quad（\@tihao）\par
	\endgroup
	\vspace{1.4cm}%
}
\renewenvironment{abstract}%
{%
	\thispagestyle{empty}%
	\mukuai
	\begingroup\centering\bfseries\fontsize{16}{22}\selectfont\@biaoti\par\endgroup%
	\vspace{0.55cm}%
	\begingroup\centering\bfseries\fontsize{14}{20}\selectfont 摘\hspace{0.35em}要\par\endgroup%
	\vspace{0.18cm}%
}{%
	\par\vspace{0.25cm}\noindent{\heiti\bfseries 关键词：}{\songti\bfseries\@keyword}\newpage%
}

% ==================== 目录（第 2 页）+ 正文页码 ====================
% 用法：摘要环境结束后调用 \mulu，随后直接写正文 \section{...}。
% \mulu 依次完成：另起一页出目录（不编页码）→ 另起一页 → 页码从 1 起重新编号（页脚中部）。
% 目录深度默认 2 级（章、节）；需要显示三级标题时在正文导言区加 \setcounter{tocdepth}{3}。
\renewcommand\contentsname{目\hspace{0.35em}录}
\newcommand{\mulu}{%
	\clearpage
	\pagestyle{empty}%
	\begingroup
	\linespread{1.15}\selectfont% 目录行距略收紧，保证目录稳定落在一页内
	\tableofcontents
	\endgroup
	\clearpage
	\pagenumbering{arabic}%
	\pagestyle{plain}%
}
% 目录条目：一级编号“一、”至“十一、”最宽占 3 个汉字（3em），故编号盒取 3.5em，
% 避免编号与标题文字重叠；二级用五号字，与母本标题层级观感一致。
\renewcommand*\l@section[2]{%
	\begingroup\zihao{-4}\bfseries\@dottedtocline{1}{0em}{3.5em}{#1}{#2}\endgroup}
\renewcommand*\l@subsection[2]{%
	\begingroup\zihao{5}\bfseries\@dottedtocline{2}{3.5em}{2.9em}{#1}{#2}\endgroup}

% 全文默认无页眉、无页码（首页与目录页），正文由 \mulu 切回 plain（页脚中部页码）
\AtBeginDocument{\pagestyle{empty}}

% 浮动环境设置默认情况下, \LaTeX{} 要求每页的文字至少占据 20%,否则该页就只单独放置一个浮动环境,而这通常不是我们想要的, 我们将这个要求降低到 5%.
\renewcommand*{\textfraction}{0.05}
% 有时如果多个浮动环境连续放在一起, \LaTeX{}会将它们分在几个不同页，即使它们可在同一页放得下. 我们可以通过修改 |\topfraction| 和 |\bottomfraction| 分别设置顶端和底端的浮动环境的最大比例.
\renewcommand*{\topfraction}{0.9}
\renewcommand*{\bottomfraction}{0.8}
% 有时\LaTeX{}会把一个浮动环境单独放在一页,我们要求这个环境至少要占据 85% 才能单独放在一页.注意:  |\floatpagefraction| 的数值必须小于 |\topfraction|
\renewcommand*{\floatpagefraction}{0.85}

% 设置页面边距（与母本一致）
\RequirePackage[textwidth=444bp,vmargin=2.5cm]{geometry}

% 加载物理、国标宏包
\RequirePackage{physics,siunitx}

\renewcommand{\leq}{\leqslant}
\renewcommand{\geq}{\geqslant}

% 载入表格宏包和插图宏包
\RequirePackage{booktabs,tabularx,multirow,makecell}
\RequirePackage{mwe}
\RequirePackage{caption,subcaption}
\renewcommand\thesubfigure{(\alph{subfigure})}
\captionsetup[sub]{labelformat=simple}
% \captionsetup{skip=0pt}% 将图表标题与图表之间的纵向间距取消掉
\captionsetup{format=hang}% 设置浮动体标题悬挂缩进
\DeclareCaptionLabelSeparator*{sspace}{\ \ }
\captionsetup[figure]{labelsep=sspace}
\captionsetup[table]{labelsep=sspace}
\DeclareCaptionFont{heiti}{\heiti}
\DeclareCaptionFont{5hao}{\zihao{5}}
\captionsetup{labelfont={heiti,5hao},textfont={heiti,5hao}}% 设置图表标题为5号、黑体
\RequirePackage[section]{placeins}

% 定义居中的X列格式
\newcolumntype{Y}{>{\centering\arraybackslash}X}

% 设置图片路径
\graphicspath{{figures/}}

% 载入列表宏包
\RequirePackage{enumitem}
\setlist[enumerate,1]{leftmargin=0pt,labelsep=0pt,itemindent=3\ccwd+0.2cm,parsep=0pt,itemsep=0pt,topsep=0pt,partopsep=0pt,listparindent=2\ccwd}
\def\labelenumi{\theenumi、}
\setlist[itemize,1]{leftmargin=0pt,itemindent=3\ccwd,parsep=0pt,itemsep=0pt,topsep=0pt,partopsep=0pt,listparindent=2\ccwd}


% 载入参考文献宏包，设置引用格式（正文中为上标方括号编号，如“文献[1]”）
\RequirePackage{natbib}
\setcitestyle{square,super}

% 载入代码宏包
\RequirePackage{xcolor,listings}
% 设置代码的默认样式
\lstset{
	frame=none,% 取消边框
	breaklines=true,% 允许自动断行
	% breakatwhitespace=true,% 使用此命令仅允许在空格处自动断行
	showstringspaces=false,% 不显示字符串中的空格
	basicstyle=\small\ttfamily,% 设置代码基本样式
	flexiblecolumns=true,% 改善字母间距
	keywordstyle=\color{blue},% 设置关键词样式
	stringstyle=\color[rgb]{0.75,0,0.75},% 设置字符串样式
	commentstyle=\songti\color[rgb]{0,0.5,0},% 设置注释样式
	tabsize=2,% 设置制表符缩进
}

% 设置matlab代码环境
\lstnewenvironment{matlab}[1][]{
	\lstset{
		language=Matlab,
		% deletekeywords={disp},% 可在此行去除特定关键词的语法高亮
		keywordstyle=\color{blue},% 设置关键词样式
		stringstyle=\color[rgb]{0.75,0,0.75},% 设置字符串样式
		commentstyle=\songti\color[rgb]{0,0.5,0},% 设置注释样式
		#1
	}
}{}

\RequirePackage{etoolbox}
\newenvironment{appendixx}{%
	\newpage%
	\appendix%
	\ctexset{section={%
		format={\zihao{-4}\heiti\raggedright}%
	}}%
	\zihao{5}%
	\begingroup\centering\heiti\zihao{4}附　录\par\endgroup%
}{}
% 参考文献进目录
\AtBeginEnvironment{thebibliography}{\phantomsection\addcontentsline{toc}{section}{参考文献}}

% 页脚页码：正文起 plain 样式即为页脚中部阿拉伯数字；全文无页眉
\pagestyle{plain}

\labelformat{figure}{图~#1}
\labelformat{table}{表~#1}
\labelformat{equation}{(#1)~式}

% 载入超链接宏包
\RequirePackage{hyperref}
\hypersetup{breaklinks,colorlinks}% 允许超链接断行,取消超链接的边框,使链接文字带颜色
\hypersetup{hidelinks,bookmarksnumbered=true,bookmarksopen=true,pdfstartview=Fit}% 取消超链接的颜色，书签目录增加编号
