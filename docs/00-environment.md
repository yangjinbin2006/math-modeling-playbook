# 比赛环境说明（2026-09-09 实测 · 开赛前最后环境核对）

> 目的：赛时一切工具问题赛前解决。本文件记录本机实测的环境状态与**用哪套**的决策，开赛后只按此执行，不临时折腾环境。

## 1. 编程环境（唯一指定：Windows Anaconda）

- **位置**：`python`（Python 3.13，base 环境）
- **实测已装**：
  - numpy 2.1.3 / pandas 2.2.3 / scipy 1.15.3 / matplotlib 3.10.0 / scikit-learn 1.6.1 / openpyxl ✅
- **实测未装**：gurobipy ❌、xgboost ❌
- **铁律**：开赛后**所有代码统一用 Anaconda Prompt 运行**；不要混用 WSL 的 python3（缺 sklearn/gurobipy）。
- **wsl python3**（numpy/pandas/matplotlib 3.6.3，无 sklearn）仅可用作工具脚本，不进比赛代码。

## 2. 求解器决策（Gurobi 去留）

- **决策**：比赛优化以 **scipy 内置 HiGHS / scipy.optimize** 为默认求解器（零许可、已就绪）。
  - MILP/整数规划 → `scipy.optimize.milp` / `linprog(method="highs")`
  - NLP → `scipy.optimize.minimize`（SLSQP/trust-constr）
- **Gurobi 教育版**：需要学校邮箱申请 license（申请入口 mathorcup 资料页 / gurobi.com 学术许可）；**今晚无法完成申请就用 scipy 路线并在论文里交代理由**（"小规模问题用 scipy，满足精度与时间要求"）。
- gurobipy 裸装无 license 不能求解，**不装**。

## 3. 排版路线（LaTeX vs Word）

- **✅ LaTeX 路线已就绪（2026-09-09 实测通过）**：
  - 安装位置：WSL `~/.TinyTeX`（TeX Live 2026，XeTeX 3.141592653-2.6）
  - 编译命令：`export PATH="$HOME/.TinyTeX/bin/x86_64-linux:$PATH" && xelatex -interaction=nonstopmode 论文.tex`（需编译两次处理交叉引用）
  - **`templates/paper.tex` 已用本机编译成功**（4 页 PDF，中文 Fandol 字体正常加载，无错误）→ 产物 `templates/paper.pdf`
  - 已装宏包：ctex/fandol/xecjk/booktabs/multirow/caption/algorithms/algorithm2e/float/xcolor/anyfontsize 等
  - ⚠️ 注意：编译在 **WSL 侧**；比赛文件放 WSL 可访问的目录下编译即可，或同步到 Overleaf（模板同源）。
- **Word 路线（备选）**：按下面列出的排版规格执行（宋体小四 22 磅正文、黑体三号题目、黑体四号一级标题、公式编辑器）。
- **决策记录**：____________（本次微模拟已验证 LaTeX 可编译；若队伍无 LaTeX 熟练成员，Word 更稳妥）
- 选 LaTeX 的核对项：✅ 已完成——`xelatex 建模_论文模板.tex` 编译通过 + PDF 中文正常。

## 4. 提交环境（deadline 关键路径）

- 客户端：提交 MD5 用官方"作品提交客户端"；**提前 2–3 小时做一次试提交**。
- 文件双备份：代码/数据/tex 在比赛结束前留双份（本地 + U 盘/云盘）。
- 关键时间锚（2026）：MD5 码 **9-13 20:00** 前（提交后不再打开论文文件，一动保存 MD5 就变）；电子文档窗口 **9-13 20:30 – 9-14 14:00**；支撑材料 RAR/ZIP ≤20MB。

## 5. 合规红线速记（开赛日贴第一屏）

1. 竞赛期间**不得浏览/发布/讨论**赛题相关内容于任何平台（含知乎/小红书/CSDN/GitHub/QQ 群/直播间）——"浏览"也违纪，群聊全关。
2. 竞赛期间指导教师不介入。
3. 参考文献前加"AI 工具使用声明"二选一；用 AI 必须附 `AI工具使用详情.pdf`。
4. 论文/支撑材料任何位置（含文件名、文档属性）不得出现队名/学校/赛区。
5. 相似度 ≥25% 不送全国、≥20% 无国奖——文字防撞优先级：表述 > 方案 > 代码。

## 6. 开赛后每周期的工具落点（对照速查表）

| 周期 | 用哪套 | 备注 |
|---|---|---|
| 读题/选题 | 纸 + 三色笔 + 题目打印件 | 三人一起读 |
| 建模 | 白板/纸 + Anaconda 交互式 | 先结构后代码 |
| 求解 | Anaconda + scipy | 软件名+版本写进论文（Python 3.13/scipy 1.15.3） |
| 画图 | matplotlib/seaborn（Anaconda） | 图必须代码画、自己调 |
| 写作 | Word（或 LaTeX 若编译通过） | 见第 3 节 |
| 附件 | openpyxl 读写 result*.xlsx + 读回校验脚本 | 附件=评分，约束逐项重检 |
| 提交 | 官方客户端 + 双备份 | 见第 4 节 |