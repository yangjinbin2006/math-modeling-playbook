# Math Modeling Playbook（数学建模作战手册）

国赛 74 小时赛程用的一套准备文件。包括一页作战卡、四类模型检验清单、AI 使用记录模板、
隔离复跑 SOP 和一份 LaTeX 论文模板。

写给已经在建模、但总觉得差一口气的队伍。

## 为什么整理这些

数学建模的资料不缺。缺的通常是下面几件事：

**什么时候该放弃。** 一个模型三四小时不出结果就该换，但这个阈值赛场上没人提醒你。

**AI 用完之后怎么交代。** 国赛要提交《AI 工具使用详情》，很多队伍是赛后补的。

**评委五分钟里看哪几行。** 摘要、数字、图。其余部分算支撑材料。

**换个目录还能不能跑。** 支撑材料里的代码跑不出论文上的数字，是最常见的翻车方式。

这套文件针对的就是这四件事，每一份都对应一个具体的翻车点。

## 内容

### 赛前

| 文件 | 作用 |
|---|---|
| [`docs/00-environment.md`](docs/00-environment.md) | 环境清单：装什么、什么版本、哪些不能碰（求解器许可、字体、编译链） |
| [`docs/02-idea-selection.md`](docs/02-idea-selection.md) | 创新候选圈选表，把"这个思路新不新"变成可以打分的表 |
| [`docs/11-sample-index.md`](docs/11-sample-index.md) | 优秀论文的选篇索引：读哪几篇、读哪几节，而不是通读一百篇 |

### 开赛

| 文件 | 作用 |
|---|---|
| [`docs/01-battle-card.md`](docs/01-battle-card.md) | 一页作战卡：时间轴、评分权重、一票否决的红线、每问必须走完的闭环。建议打印 |
| [`templates/modeling-notes.md`](templates/modeling-notes.md) | 建模笔记模板：留接口给队友、防数据泄漏、结果锁定 |

### 赛中

| 文件 | 作用 |
|---|---|
| [`docs/06-prompts.md`](docs/06-prompts.md) | 赛时提示词清单：从读题到填 AI 使用记录，9 个阶段可以直接复制的指令 |
| [`docs/09-model-checks.md`](docs/09-model-checks.md) | 四类模型各该做什么检验，做到什么程度算够 |
| [`docs/04-figures.md`](docs/04-figures.md) | 画图规范：图的数量、类型怎么选、美化到什么程度 |
| [`docs/08-tier-upgrade.md`](docs/08-tier-upgrade.md) | 省一和国一差在哪，按什么顺序补 |

### 收尾

| 文件 | 作用 |
|---|---|
| [`docs/10-reproducibility.md`](docs/10-reproducibility.md) | 隔离复跑 SOP：换目录重跑一遍，证明数字不是凑的 |
| [`docs/07-aigc-compliance.md`](docs/07-aigc-compliance.md) | 论文自然化改写与 AIGC 合规，声明式 AI 辅助的完整操作规范 |
| [`templates/ai-usage-log.md`](templates/ai-usage-log.md) | AI 使用记录模板，对标《AI 工具使用详情》的栏目 |
| [`templates/paper.tex`](templates/paper.tex) + [`scripts/compile-paper.sh`](scripts/compile-paper.sh) | 国赛格式 LaTeX 模板与编译脚本 |

## 几个关键判断

**评分权重大致是模型 30、求解 20、检验 15、摘要 10。** 也就是说，多塞一个算法不如
把现有的结果证明清楚。检验比模型更值钱，这一点和直觉相反。摘要只占 10 分却最要命，
因为它是唯一被完整读过的部分，每问的具体数字都得出现在里面。

**止损要提前写成动作。** "一个模型三四小时不出结果就换"这句话写进作战卡，是因为赛场上
很难承认自己卡住了。第三天上午第三问做不完，是走止损还是硬扛，如果赛前没定，赛中一定
判断错。

**AI 可以用，但要能交代。** 这个仓库的立场是声明式辅助：

- 用了就如实记录。《AI 工具使用详情》里写清工具名、版本、用在哪一步、提示词、采纳情况。
- 不碰规避检测的工具。[`docs/07-aigc-compliance.md`](docs/07-aigc-compliance.md) 把"降 AIGC 率"
  这类工具列为不使用项，理由不是道德，是风险：整篇统一改写会留下改写痕迹，反而更容易被看出来。
- 改稿一次只改一节，全程本地。整篇论文不要放进任何在线工具，一旦被收录就等于提前泄露。

## 使用顺序

赛前两周读 `00`、`02`、`11`，把环境配好，按索引读论文。

开赛前一晚打印 `01`，贴在桌上。

赛中按作战卡的时间轴走，不要临场重新规划。每问结束跑一遍 `09` 的检验清单。

收尾按 `10` 做隔离复跑，按 `07` 和 `templates/ai-usage-log.md` 写 AI 声明。

```bash
git clone https://github.com/yangjinbin2006/math-modeling-playbook.git
cp -r math-modeling-playbook/templates/* ./你的工作目录/
```

## 合规说明

本仓库不包含任何赛题内容、赛题解法、参赛论文或竞赛期间产生的材料。它只有赛前准备和
通用方法论。国赛规则明确禁止在竞赛期间于任何平台浏览、发布或讨论赛题，这里的内容与
此无关，也请不要在竞赛期间用它讨论任何在赛题目。

使用时以当届竞赛规则为准。格式要求、页数限制、提交方式、AI 使用规定每年都在变，这里
写的是 2026 届的口径。与当届规则冲突时一律以当届为准。

关于 AI：本仓库主张如实声明、逐项人工复核，不提供任何规避检测的方法。是否允许使用 AI、
允许到什么程度，由当届规则和你所在学校的规定决定。

## 适用与不适用

适用：参加国赛、美赛或各类数学建模竞赛的队伍；带队的指导老师；想把建模从个人手艺变成
团队流程的人。

不适用：找赛题答案的人；找绕过查重办法的人；想要一条自动生成论文流水线的人。这套文件
讲的恰恰是不要那样做。

## 致谢

`templates/modeling-notes.md` 与 `docs/05-directory.md` 的目录骨架参考了
[Mr-Potato-123/cumcm-paper-hand-skill](https://github.com/Mr-Potato-123/cumcm-paper-hand-skill)，
在此基础上按竞赛红线做了增补。

## 许可

文档采用 [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.zh)：
可复制、修改、分发，需署名、非商业用途、相同方式共享。

`scripts/` 下的代码采用 MIT。

---

觉得有用的话，转给队友就行。
