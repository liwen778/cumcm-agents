# 项目 Skills 目录

把 skill 放进这个目录（`.claude/skills/`），Claude Code 会自动加载它们。

## 目录结构

每个 skill 是一个文件夹，里面必须有一个 `SKILL.md` 文件：

```
.claude/skills/
└── 你的skill名/
    ├── SKILL.md          # 必填：skill 入口
    ├── scripts/          # 可选：可执行脚本
    ├── references/       # 可选：按需加载的参考文档
    └── assets/           # 可选：模板、图标等资源
```

## SKILL.md 基本格式

```markdown
---
name: 你的skill名
description: 何时触发、做什么。写清楚触发场景，宁可"激进"一点。
---

## 具体指令

写清楚让 Claude 做什么、怎么做。
```

- `name` 和 `description` 是必填字段（frontmatter）。
- `description` 决定 Claude 会不会调用这个 skill，要同时写"做什么"和"什么时候用"。
- 正文用祈使句，控制在 500 行以内；大量内容拆到 `references/` 里按需加载。

## 快速开始

1. 在本目录下新建一个以 skill 命名的文件夹。
2. 在文件夹里写 `SKILL.md`（格式见上）。
3. 保存后重启会话（或 `/clear`）即可被识别。

对选手智能体说"帮我创建一个 skill"即可按上述格式新建。
