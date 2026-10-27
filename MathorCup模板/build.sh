#!/usr/bin/env bash
# ============================================================
# LaTeX 一键编译脚本（macOS / Linux / Git Bash）
# 用法：在 MathorCup模板 目录运行 ./build.sh
# 依赖：TeX Live 2023+（full）或 MiKTeX，xelatex 在 PATH 中
# ============================================================
set -e
cd "$(dirname "$0")"

if ! command -v xelatex >/dev/null 2>&1; then
    echo "[ERROR] 未找到 xelatex。请安装 TeX Live 2023+ 或 MiKTeX，并确保其在 PATH 中。" >&2
    exit 1
fi

echo "[1/2] 第一遍编译（生成交叉引用）..."
xelatex -interaction=nonstopmode -halt-on-error main.tex

echo "[2/2] 第二遍编译（解析交叉引用）..."
xelatex -interaction=nonstopmode -halt-on-error main.tex

echo ""
echo "build OK: main.pdf"
