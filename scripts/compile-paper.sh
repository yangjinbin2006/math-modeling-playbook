#!/bin/bash
# 一键编译国赛 LaTeX 论文（WSL 侧，TinyTeX 已装）
# 用法（在 WSL 里）：
#   bash scripts/compile-paper.sh /path/to/论文目录/主文件.tex
# 说明：编译两次处理交叉引用；错误时给出提示，不静默失败。

set -u
TEX="${1:?用法: bash 编译论文.sh 论文文件.tex}"
cd "$(dirname "$TEX")" || exit 1
BASE="$(basename "$TEX" .tex)"
export PATH="$HOME/.TinyTeX/bin/x86_64-linux:$PATH"

if ! command -v xelatex >/dev/null 2>&1; then
  echo "❌ xelatex 未找到。请先安装 TinyTeX（见 00_比赛环境说明.md 第 3 节）。"
  exit 1
fi

echo "== 第 1 遍编译 =="
xelatex -interaction=nonstopmode -halt-on-error "$BASE.tex" > /tmp/xelatex1.log 2>&1
if [ ! -f "$BASE.pdf" ]; then
  echo "❌ 编译失败。关键错误："
  grep -E "^!" /tmp/xelatex1.log | head -5
  exit 1
fi
echo "  1st pass OK ($(ls -la "$BASE.pdf" | awk '{print $5}') bytes)"

echo "== 第 2 遍编译（交叉引用）=="
xelatex -interaction=nonstopmode -halt-on-error "$BASE.tex" > /tmp/xelatex2.log 2>&1
grep -E "Warning: (Citation|Reference).*undefined" /tmp/xelatex2.log | head -5 && echo "  ⚠️ 有未定义引用，请检查"

echo "✅ 编译完成：$(pwd)/$BASE.pdf"
echo "  警告数: $(grep -c 'LaTeX Warning' /tmp/xelatex2.log || true)"
echo "  错误数: $(grep -cE '^!' /tmp/xelatex2.log || true)"