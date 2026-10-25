# 更新日志（CHANGELOG）

本项目的所有重要变更将记录在此文件中。
格式参考 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/)，版本遵循语义化版本。

## [1.0.0] - 2026-10-25

### 新增

- 双智能体协作工作流：选手（Claude Code）与裁判（Hermes）分工、信任与审查机制；
- 6 个流程 Skill（读题分析、数据清洗、代码生成、论文撰写、裁判审查，`.claude/skills/` 与 `.hermes/skills/` 双侧同步）；
- `CLAUDE.md` 去AI味写作规范与代码规范；
- 《双智能体工作流使用手册》《比赛日速查》两份流程文档；
- LaTeX 论文模板：JXUSTmodeling 类（西文字体开源回退）+ 干净骨架 main.tex（含官方要求的"AI工具使用声明"章节）+ `code/` 附录代码管理（`\lstinputlisting`）+ 一键编译脚本 build.bat / build.sh；
- `AI使用报告模板/`：按《全国大学生数学建模竞赛人工智能工具使用规定（2026年试行）》编制的 Word 报告模板与配套使用说明；
- 《优秀论文/写作规范.md》写作范式文档。
