# 隔离复跑 + 证据链核验 SOP 模板（阶段 7 强制）

> 用途：做题仿真每个题的"代码实测真实性"终审——数字能否复现、脚本是否真实可执行、文档声称与产出是否一致。
> 版本：v1.0（2025-08 沉淀，2024A 试点首创 + 4 个 B 题批量实战校准）
> 适用范围：2026 国赛备赛所有新题的阶段 7；旧题补核验同法。
> 已落地范例：`2024A/.pilot_verify/`（完整）、`2022B/.pilot_verify/`、`2023B/.pilot_verify/`（绝对路径改写最严案例）、`2021B/.pilot_verify/`、`2024B/.pilot_verify/`。

---

## 一、核验目标（为什么做）

| 验证点 | 说明 |
|---|---|
| 脚本真实性 | 冻结版 .py 是否真实可执行、退出码 0 |
| 结果可复现 | 重跑产出 res JSON 与冻结版**逐字段一致**（容差 1e-9） |
| 文档诚实性 | 01/02/03 卷声称的关键数字能从 res JSON 追溯 |
| 冻结区零污染 | 复跑全程不改动 code/ 原目录任何文件 |

## 二、目录约定

```
<题目目录>/
├── code/                    # 冻结区（V1 脚本 + res JSON + 数据，永不改动）
└── .pilot_verify/           # 复跑隔离区
    ├── run_verify.py        # 一键核验脚本（幂等，可重复执行）
    ├── baseline_sha256.txt  # 冻结区逐文件 SHA256 基线
    ├── verify_summary.json  # 机器可读汇总（verdict: ALL PASS / FAIL）
    ├── 04_试点核验报告.md     # 人工报告（逐脚本表 + 文档声称核对表）
    └── work/                # 脚本副本 + 重跑产出（输出全部落这里）
```

## 三、run_verify.py 模板要点（参照 2022B/.pilot_verify/run_verify.py）

### 1. 基线哈希
- 对 code/ **全部文件**（.py/.json/.xlsx/.npz/.csv）逐文件 SHA256 → baseline_sha256.txt。
- 头部注释注明基线日期与是否含 P1/P2 新增文件。

### 2. 脚本复制 + 路径改写（本题最关键的一步）
**先侦察**：grep 所有 .py 的 `open(` / `save(` / `np.load` / `to_csv` / `to_excel`，分类：
- 相对路径输出（cwd 决定）→ 无需改写，cwd=work 自动落入 work/；
- **绝对路径写冻结区**（如 2023B 的 `E:\...\code\res_*.json`、2024B 的 4 个脚本）→ 必须改写，否则复跑会**污染冻结区**；
- **绝对路径读题面附件**（如 2021B 的 `...\题目\附件1.xlsx`）→ 把附件复制进 work/，再改写。

**改写方法：精确替换表**（不要全局前缀替换——全局替换会把附件路径改到不存在的子目录）：

```python
DATA_COPY = [r'E:\...\题目\附件1.xlsx', ...]           # 只读输入复制进 work/
REPLACEMENTS = [(src, os.path.join(WORK, os.path.basename(src))) for src in DATA_COPY]
REPLACEMENTS.append((r'E:\...\题目目录\code', WORK))    # 写冻结区前缀 → work/
for fn in os.listdir(WORK):
    if fn.endswith('.py'):
        src = open(os.path.join(WORK, fn), encoding='utf-8').read()
        for old, new in REPLACEMENTS:
            src = src.replace(old, new)
        open(os.path.join(WORK, fn), 'w', encoding='utf-8').write(src)
```

### 3. 逐脚本重跑
- SCRIPTS 列表按**依赖顺序**（如 q1_fit → q2 → q3 读 res_q1 → q4 读 res_q3）。
- 子进程 `cwd=WORK`，`env` 加 `PYTHONIOENCODING=utf-8`（Windows GBK 控制台中文/数学符号会 UnicodeEncodeError）。
- 每脚本 stdout+stderr 落盘 `log_<脚本名>.txt`；退出码非 0 立即报 FAIL。

### 4. res JSON 逐字段 diff（数值容差 1e-9）
- 递归比较 dict/list；数值 `|a-b| <= 1e-9*max(1,|a|,|b|)`；字段缺失/多余/类型不同均记录路径。
- 这是**证据链核心**：文档声称的每个数字都应能在 res JSON 中找到同名字段。

### 5. xlsx 逐格数值比对（如有 result*.xlsx）
- openpyxl 逐格；float 容差 1e-9；**zip 时间戳差异不计**（哈希不同≠数值不同）。
- 冻结版 xlsx 若在题目目录（非 code/），在 xlsx_pairs 里写绝对路径。

### 6. 汇总
- verify_summary.json：`{scripts_exit, json_diff, xlsx_diff, verdict, note}`；`sys.exit(0 if all_ok else 1)`。

## 四、04_试点核验报告.md 模板（参照 2024A/.pilot_verify/04_试点核验报告.md）

```markdown
# <年份题号> 试点核验报告 · 隔离复跑审计（阶段 7）

> 目的：……隔离复跑核验——脚本是否真实可执行、res JSON 能否逐字段复现。
> 日期：YYYY-MM-DD · 执行环境：Windows Python 3.10.9（numpy 2.2.6 / scipy 1.15.3 / pandas 2.3.3 / openpyxl 3.1.5）
> 红线遵守：冻结版文件（code/ 原目录）零修改；所有复跑在隔离区 .pilot_verify/work/ 完成。

## 一、基线封存          # 冻结区文件数、baseline 路径、work 区说明（含路径改写清单）
## 二、逐脚本复跑结果    # 表：脚本/退出码/冻结版产出/复跑比对/判定（✅ REPRODUCED）
## 三、关键数字与文档声称的一致性核对  # 表：文档声称 ↔ 复跑实测 ↔ 一致
## 四、SOP 校准备注      # 本题特殊点（绝对路径、附件、慢脚本）、复跑命令
```

## 五、锚点 OCR 复核（论文侧证据链，02 报告用）

1. 从一等奖论文 OCR md 直接**正则提取锚点数字**（如 "8.8"、"412.47"、"13.621"）；
2. 与我方 res JSON 逐项对照，标签：REPRODUCED（逐位一致）/ NEAR（<5%）/ DIFF；
3. 写入 02 报告"论文侧锚点独立复核"表；**每篇论文的数字必须能从原文追溯，禁止凭记忆**；
4. 多篇分歧时如实记录"五方无共识"（如 2024A Q5：1.246/1.33/1.406）。

## 六、实战教训（2024A 试点 + 2025-08 B 题批量）

1. **写死绝对路径是最常见污染源**：2023B 5/5 脚本写绝对路径（含写入题目目录的 result*.xlsx）——侦察先行，精确替换表；
2. **慢脚本必须预判**：>10 分钟脚本按"探索性"单独排队，不阻塞主线复现；逐对 Python 循环先向量化（verify_q3b_vectorized 先例）；
3. **依赖顺序**：链式脚本（q3 读 res_q1 等）按依赖序跑，先跑上游；
4. **GBK 控制台**：PYTHONIOENCODING=utf-8 统一加；
5. **确定性优先**：求解器/仿真避免 RNG；必须随机时固定 seed 并在 JSON 记录 seed 列表；
6. **新脚本（P1/P2 整改产物）不入冻结基线复跑清单**，其运行日志单独留存（log_*.txt），baseline 注释标注"V1 冻结 + P1 新增"。

## 七、一键执行

```powershell
cd <题目目录>\.pilot_verify
python run_verify.py      # 幂等：重跑即重新生成 baseline + work + summary
```

检查清单（新题首日启用）：□ 冻结区哈希 □ 路径侦察 □ 数据复制 □ 依赖排序 □ 逐脚本日志 □ JSON diff □ xlsx 比对 □ 04 报告 □ 锚点 OCR 复核 □ verify_summary ALL PASS
