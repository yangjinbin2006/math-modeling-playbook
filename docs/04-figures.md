# 数学建模 画图规范与美化指南（比赛时提醒 AI 用）

> 本文件是**赛时画图的唯一权威依据**。开赛后任何画图需求，先把本文件路径贴给 AI：
> - 仓库内路径：`docs/04-figures.md`
> - 一句话触发：**"按《画图规范与美化指南》出图"**
>
> 创建日期：2026-09-09（赛前，与本机`docs/00-environment.md`同步核对）

---

## 0. 三条铁律（先读）

1. **所有比赛图只能用 Windows Anaconda 的 python 画**：
   `python`（Python 3.13）。
   不要用 WSL python3（只有 matplotlib 3.6.3，且环境说明里明确禁止混用）。
2. **图必须代码画、自己调**（可复现 .py 存档），不用 PPT/PS 拼图改图。
3. **赛时无网，禁止临时 `pip install`** —— 美化库已在 2026-09-09 全部预装完毕（见 §1），比赛期间不换机器、不动环境。

---

## 1. 已装环境（本机实测）

| 包 | 版本 | 用途 |
|---|---|---|
| matplotlib | 3.10.0 | 主力绘图（Anaconda 自带） |
| seaborn | 0.13.2 | 统计图/热力图（Anaconda 自带） |
| **scienceplots** | 2.2.2 | ⭐ 论文级一键风格（science/ieee/nature） |
| **mplcyberpunk** | 0.7.6 | 发光霓虹惊艳风（答辩/展示页） |
| **pyecharts** | 2.1.0 | 交互图表：地图/桑基/漏斗/雷达（中文 ECharts） |
| **cmocean** | 4.0.3 | 高质量连续色板（热图/曲面/地形） |
| numpy 2.1.3 / pandas 2.2.3 / scipy 1.15.3 / scikit-learn 1.6.1 | — | 基础（Anaconda 自带） |

验证命令（Anaconda Prompt）：
```bash
python -c "import scienceplots, mplcyberpunk, pyecharts, cmocean; print('OK')"
```
可复现安装命令（仅赛前需要，已装）：
```bash
python -m pip install scienceplots mplcyberpunk pyecharts cmocean
```

---

## 2. 选型决策表（先查这张表再动手）

| 要画的图 / 目的 | 首选 | 说明 |
|---|---|---|
| 论文**正文图**（绝大多数） | matplotlib + `science` 风格基线（§3） | 干净、规范、评委友好 |
| 统计/相关性热力、分布 | seaborn（§6） | 叠加在 science 基线上 |
| 连续色板需求的热图/曲面/地形 | cmocean（§5） | 色带专业不刺眼 |
| 地图（省市/分布）、桑基（流量/转移）、漏斗、雷达 | pyecharts（§7） | 中文界面化首选 |
| 想抓眼球的展示图（答辩页/美赛风封面图） | mplcyberpunk（§4） | 一张图最多用 1–2 张 |
| 多维对比、子图排版 | matplotlib 多子图 + 统一轴（§3 模板） | 别用默认五颜六色 |
| 空间数据散点/插值面 | matplotlib + cmocean | 需 geopandas 时先确认已装 |

规则：**同一篇论文所有图共用同一基线风格 + 同一色板**，图例顺序、字号、边框风格全篇一致。

---

## 3. matplotlib 全局基线（每张图的起点）

```python
import matplotlib as mpl
import matplotlib.pyplot as plt
import numpy as np

# ---------- 全局基线：全篇统一，放在脚本最顶部 ----------
plt.rcParams.update({
    # 字体：西文 Times New Roman，中文自动回退 SimHei（Windows 自带）
    "font.family": ["Times New Roman", "SimHei"],
    "font.sans-serif": ["SimHei", "Microsoft YaHei"],
    "axes.unicode_minus": False,          # 负号不显示成方块（必设）
    "mathtext.fontset": "stix",
    # 尺寸与字号
    "figure.dpi": 100,
    "savefig.dpi": 300,
    "font.size": 10,
    "axes.labelsize": 11,
    "axes.titlesize": 12,
    "xtick.labelsize": 9,
    "ytick.labelsize": 9,
    "legend.fontsize": 9,
    # 论文风：去上/右边框、细轴、浅网格
    "axes.linewidth": 0.8,
    "axes.spines.top": False,
    "axes.spines.right": False,
    "axes.grid": True,
    "grid.alpha": 0.3,
    "grid.linewidth": 0.6,
    "lines.linewidth": 1.6,
    "figure.constrained_layout.use": True,
    # 矢量输出不糊
    "pdf.fonttype": 42,
    "ps.fonttype": 42,
})

# 尺寸参考：大图(7.2,4.6) 中图(5.8,3.8) 小图/半栏(3.6,3.2)
fig, ax = plt.subplots(figsize=(7.2, 4.6))

# ---------- 导出模板：每张图交付 PNG(300dpi) + SVG(矢量) 双份 ----------
def save_fig(fig, stem):
    """stem 不含扩展名，例如 '问题A/结果/图1_数据分布'"""
    fig.savefig(stem + ".png", dpi=300, bbox_inches="tight")
    fig.savefig(stem + ".svg", bbox_inches="tight")
```

> SVG 进论文/PPT 放大不糊；PNG 用于 Word/预览。文件名 = `图N_语义.png`，
> 放 `问题X/结果/` 下，与论文图号一一对应。文件名/图内**不得出现队名、学校**（红线）。

### 3.1 SciencePlots 论文风格（推荐主力）

```python
import scienceplots          # 导入即自动注册风格（必须在 style.use 之前 import）
plt.style.use(["science", "no-latex"])   # no-latex 必须叠加：本机 Anaconda 未配 LaTeX
```

可用风格速查（本机实测已注册）：`science` `ieee` `nature` `high-vis`（高对比，审阅/打印友好）
`high-contrast` `grid` `no-latex` `retro` `muted` `vibrant` `light` `sans` …（共 76 个，
含 seaborn 全部旧名）。验证：
```python
print([s for s in plt.style.available if s.startswith(("science", "ieee", "nature"))])
```

叠加用法（链式、顺序即优先级）：
```python
plt.style.use(["science", "no-latex"])             # 基础论文风
plt.style.use(["science", "no-latex", "ieee"])     # 想要更紧凑的期刊排版
plt.style.use(["science", "no-latex", "high-vis"]) # 色板更鲜艳（适合展示）
plt.style.use(["science", "no-latex", "grid"])     # 想要网格线
```
注意：`science` 风格默认 `text.usetex=True`，无 LaTeX 环境会报错，所以**永远带 `no-latex`**；
若中文显示异常，可再叠加 `cjk-sc-font` 或手动设 §3 的 font.sans-serif。

### 3.2 多子图统一风格示例

```python
fig, axes = plt.subplots(1, 3, figsize=(7.2, 2.6), sharey=True)
for ax in axes:
    ax.plot(x, y)              # 共用 rcParams，天然统一
fig.suptitle("...", fontsize=13)
save_fig(fig, "问题A/结果/图2_多方案对比")
```

---

## 4. mplcyberpunk 惊艳风（答辩/封面，全篇≤2张）

```python
import mplcyberpunk
plt.style.use("cyberpunk")               # 整图霓虹深色风

# 只在已有图上加特效（不换全局风格）：
mplcyberpunk.add_glow_effects()          # 线条发光
mplcyberpunk.add_underglow_effects()     # 线下辉光
mplcyberpunk.make_scatter_glow()         # 散点光晕
```

> 用途：答辩 PPT 页、论文首页/摘要点缀。评委打印看的是黑白/灰度，**别把关键信息
> 只靠颜色表达**；这类图不进正文做论据图。

---

## 5. cmocean 专业色板（热图/曲面）

```python
import cmocean as cmo

# 顺序色（数值从小到大，推荐）：thermal（暖） / deep（蓝深） / turbid / amp
plt.imshow(Z, cmap=cmo.cm.thermal, aspect="auto")
plt.colorbar(label="...")

# 发散色（有正负/相关系数，0 居中）：balance
import seaborn as sns
sns.heatmap(corr, cmap=cmo.cm.balance, center=0, annot=True, fmt=".2f",
            annot_kws={"size": 8})

# 地形/海拔风格：topo、haline
```
常用选择：相关性矩阵 → `cmo.cm.balance`；误差/残差热力 → `cmo.cm.curl`；
连续趋势面/灵敏度 → `cmo.cm.thermal` 或 `cmo.cm.deep`。
别用 matplotlib 默认 `jet`（视觉误导、打印难看）。

---

## 6. seaborn 统计图（在基线上叠加即可）

```python
import seaborn as sns
sns.set_theme(context="paper", style=None)   # 只调上下文，风格交给 rcParams
# 分布/箱线/回归
sns.histplot(df["x"], kde=True)
sns.boxplot(data=df, x="g", y="v")
sns.regplot(x=df["a"], y=df["b"])
sns.heatmap(df.corr(), cmap=cmo.cm.balance, center=0, annot=True, fmt=".2f")
```

---

## 7. pyecharts（地图/桑基/漏斗/雷达，中文交互）

```python
from pyecharts.charts import Line, Bar, HeatMap, Sankey, Map, Funnel, Radar
from pyecharts import options as opts
from pyecharts.globals import ThemeType

line = (Line(init_opts=opts.InitOpts(theme=ThemeType.LIGHT, width="900px", height="500px"))
        .add_xaxis(x_list)
        .add_yaxis("方案A", ya, is_smooth=True)
        .add_yaxis("方案B", yb, is_smooth=True)
        .set_global_opts(title_opts=opts.TitleOpts(title="..."),
                         tooltip_opts=opts.TooltipOpts(trigger="axis")))
line.render("问题A/结果/图4_对比.html")
```

**PNG 导出的现实提醒**：
- `render()` 只出 HTML。出 PNG 需要额外渲染器（snapshot-selenium + Chrome 等），**赛时无网未预装**。
- 稳妥路径：浏览器打开 html → 整页截图存 PNG；或正文关键图用 matplotlib 画，pyecharts 用于答辩展示。
- 中国地图（Map）需各省份名称匹配，注意国名规范写法（如"内蒙古自治区"），赛前先跑通一张样例图。

---

## 8. 常见坑速查（写图时逐条过）

- [ ] 中文变方块/乱码 → 设 `font.sans-serif` + `axes.unicode_minus=False`（§3）。
- [ ] 用 science 风格报 LaTeX 错 → 必须叠加 `"no-latex"`。
- [ ] 负号变方块 → `axes.unicode_minus=False`。
- [ ] 图糊 → `savefig(dpi=300)`；要放大不糊 → 存 SVG/PDF（`pdf.fonttype=42` 已设）。
- [ ] 图太大撑爆版面 → 用 §3 三档 figsize，正文图单栏别超 3.6in 宽。
- [ ] 每张图都换一种五颜六色 → 全篇同一基线 + 同一色板 + 固定图例顺序。
- [ ] 图与结果对不上 → 图上关键数值必须与 `结果_锁定.json` 一致（红线）。
- [ ] 色盲不友好 → 尽量 `high-vis` / cmocean / colorblind 色板，避免红绿并列。
- [ ] 想临时装包 → 禁止（无网）；只用在 §1 清单里的包。
- [ ] 导出文件名含队名/学校 → 违规，一律 `图N_语义.png`。

---

## 9. 给 AI 的画图指令模板（比赛中直接贴这段）

> 现在要画一张图。请严格按 `docs/04-figures.md`（本仓库的画图规范）执行：
> 1) 先问我三个问题：数据在哪个文件、想说明哪个结论、图放论文哪一节；
> 2) 按 §2 决策表选库与风格；
> 3) 用 Windows Anaconda python（`python`）跑；
> 4) 以 §3 science+no-latex 基线为起点，必要时叠加 seaborn/cmocean；
> 5) 输出 PNG(300dpi)+SVG 到 `问题X/结果/图N_语义.png`，并给出可复现的 .py；
> 6) 图上关键数值与结果锁定 json 一致；最后用 §8 清单自查一遍再交付。

---

## 10. 快速自查（画完一张图 30 秒）

1. 风格：`science+no-latex` 基线上做的？
2. 图号文件名：`图N_语义.png`，放 `问题X/结果/`？
3. 双份导出：PNG + SVG 都在？
4. 字体：中文没方块、负号正常？
5. 色板：全篇一致、无 jet 彩虹、关键信息不只看颜色？
6. 数据：与结果锁定一致？
7. 合规：无队名/学校痕迹？
