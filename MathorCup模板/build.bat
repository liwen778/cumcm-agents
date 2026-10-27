@echo off
rem ============================================================
rem LaTeX 一键编译脚本（Windows）
rem 用法：在 MathorCup模板 目录双击或命令行运行 build.bat
rem 依赖：TeX Live 2023+（full）或 MiKTeX，xelatex 在 PATH 中
rem ============================================================
cd /d "%~dp0"
where xelatex >nul 2>nul
if errorlevel 1 (
    echo [ERROR] 未找到 xelatex。请安装 TeX Live 2023+ 或 MiKTeX，并确保其在 PATH 中。
    pause
    exit /b 1
)
echo [1/2] 第一遍编译（生成交叉引用）...
xelatex -interaction=nonstopmode -halt-on-error main.tex
if errorlevel 1 (
    echo.
    echo [ERROR] 编译失败，请查看上方报错或 main.log 定位问题。
    pause
    exit /b 1
)
echo [2/2] 第二遍编译（解析交叉引用）...
xelatex -interaction=nonstopmode -halt-on-error main.tex
if errorlevel 1 (
    echo.
    echo [ERROR] 编译失败，请查看上方报错或 main.log 定位问题。
    pause
    exit /b 1
)
echo.
echo build OK: main.pdf
pause
