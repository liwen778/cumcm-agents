# 贡献指南（CONTRIBUTING）

感谢关注本项目！欢迎通过 Issue 反馈问题、通过 Pull Request 提交改进。

## 提交 Issue

- 反馈 LaTeX 编译问题时，请附上：操作系统、TeX 发行版与版本（`xelatex --version`）、`main.log` 中以 `!` 开头的报错行；
- 反馈 Skill 行为问题时，请附上你给智能体的原话指令与异常表现。

## 提交 Pull Request

1. Fork 后从 `main` 拉取分支；
2. **修改任一 Skill 时，必须同步 `.claude/skills/` 与 `.hermes/skills/` 两侧对应文件并保持一致**（两个智能体各自从自己的目录加载）；
3. 修改 LaTeX 模板后，请在 `latex模板/` 目录运行 `./build.bat` 或 `./build.sh` 自测编译通过（0 Error）；
4. 文档与 Skill 均为中文，请保持既有的行文风格：相对路径、无个人化表述；
5. 提交信息建议格式：`模块: 变更摘要`（如 `skill: 修正数据清洗技能的缺失值规则`）。

## 约定

- 遵循仓库根目录 `README.md` 的路径约定：全部使用项目内相对路径，禁止引入机器相关绝对路径；
- 不得提交任何比赛真题、数据附件、他人论文 PDF 等版权内容；
- 新增功能请同步更新 `README.md` 与相关文档。
