# 安装代理执行合同

> 读者是 agent。人类的分层介绍在 [guide.md](guide.md)。人类把本文交给你，即授权你按下述程序执行安装。逐节执行，不跳步。

## 0. 角色与边界

你是这套 workflow 的**安装代理**。职责链：确认层级 → 选件 → 接线 → 调用 workflow-setup 完成配置 → 验证 → 汇报。

硬边界：

- **不改 skill 正文。** 你的合法写入面只有：符号链接 / 组件副本、新写的 adapter 文档、经明示批准的 harness 全局设置。
- **配置块归 workflow-setup。** `<!-- workflow-setup:begin/end -->` 标记之间的内容一律由 workflow-setup 程序填写；本文不复述其逻辑，你也不得绕过它手填。权责一句话讲死：**本文管装什么和接到哪，workflow-setup 管配置块里写什么。**
- **全局变更必须人批。** 注册 Stop hook、改 harness settings / env，先出示确切目标文件与 diff，拿到明示同意再动。
- **不发明能力。** harness 没有的强制点不假装有；人类没有的 worker 不写进座位表。缺失是合法配置（prose-only、席位 unfilled），不是待填的空。

## 1. 输入：确定层级

人类通常直接说「按 Lx 装」「升级到 Lx」或「加装 L4」。没说时，用 guide.md「Ask yourself」一节的三个问题**原话**问一次，按其速查表映射。不追加问题，不自由发挥。

- **升级安装**（低层已装，现在补高层）：只装增量组件，已有配置不动，workflow-setup 只处理新组件。
- **越级请求**（人类坚持装超出其层级的组件）：照办，但在汇报里记一行「越级安装，升层信号未出现」。
- **纯重配置**（组件已装齐，只是路径 / 模型 / 座位变了）：本文不适用，直接走 workflow-setup。

## 2. 层级→组件映射（权威表）

| 层 | 安装组件（累积） |
|---|---|
| L0 | workflow-setup、decode |
| L1 | + track-project、handoff |
| L2 | + doc-setup |
| L3 | + orchestration |
| L4（备用件） | + batch-hook |

- workflow-setup 任何层都装：它是后续一切配置与重配置的入口。
- L4 是备用件，不是梯级：只在人类要跑无人值守批次时加装，任何层都可以直接加。
- **硬规则：不装高于所选层级的组件。**「装了反正不用」不成立——多装的组件进入 harness 的 skill 索引，白占触发面和上下文。
- 维护注记：本表与 guide.md 各层清单为有意双写，改一处同步另一处。

## 3. 安装程序

1. **识别 harness**：名称与版本，以本地命令（`--version`、help、settings 文件存在性）为证据，不猜。
2. **有 adapter**（`adapters/` 下有对应目录）：按该 adapter 的 README 接线。
3. **无 adapter**：按 [adapters/README.md](adapters/README.md) 的三个接线问题——指令发现 / end-of-turn 强制点 / 环境变量通道——从该 harness 的**本地**文档与 help 输出取答案，写一份新 adapter 到 `adapters/<harness>/README.md`，然后照你自己写的执行。未加装 batch-hook（L4）时，第二问可以标「未验证」——只有它需要。
4. **symlink 还是 copy**：默认 symlink。以下情况改 copy：(a) 人类不希望配置写进这份 checkout（它是共享目录或上游 clone）；(b) harness 的发现机制不跟随符号链接。选了 copy 要向人类说明升级语义：上游更新不会自动到达，升级 = 重新安装。
5. 只链接 / 复制第 2 节映射表中所选层级的组件。

## 4. 配置

安装完成后调用 workflow-setup：harness 的 skill 机制可用则直接调用；不可用则读 `skills/workflow-setup/SKILL.md` 并按其执行——它自带完整程序，包括发现、询问与验证。

**发现范围注意**：workflow-setup 把套件 `skills/` 目录下所有存在的组件视为待配置对象，而你可能只装了子集。调用时明确限定：只配置第 3 节实际接线的组件，其余按 absent 跳过——配置未安装的组件不造成损害，但浪费人类的回答并留下误导性状态。

按层的注意事项：

- **L1**：track-project 无既有 cards root 时走其 Init mode。Obsidian 是可选项：人类不用 Obsidian，就用普通目录，并说明 dashboard 视图不可用、其余功能完整。
- **L3**：座位表按人类实际拥有的 worker 填。只有一个 worker、某些席位留空，都如实记录为 unfilled。
- **L4**：hard-gate 注册是全局变更，走第 0 节批准流程；人类犹豫时保持 prose-only——那是合法且可用的模式，不是失败。

## 5. 改写面

允许：

- **薄脚本移植**：stop-gate 按本地 shell 移植（已有 bash 与 PowerShell 版），契约不变——exit 0 放行，exit 2 + stderr 拒绝。
- **新 adapter**：第 3 节程序的产物。
- **面向人类的输出语言**跟随人类。

禁止：

- skill 正文规则、reference 文档、模板的语义。发现正文与本地现实冲突 → 向人类报告冲突与建议，不就地改文。

## 6. 验证清单

按层累积，全部通过才算装完：

**通用**

- [ ] 已装组件在 harness 的 skill 发现机制下可见（列出发现路径为证）。
- [ ] workflow-setup 报告中，每个已装组件状态为 configured，或带明示的 unfilled / prose-only / pending。
- [ ] 所选模式的必需字段无 `UNCONFIGURED` 残留。

**L0**

- [ ] 无新增谓词（decode 免配置）。

**L1**

- [ ] cards root 已解析且含 `SCHEMA.md` 与 `INDEX.md`（或 Init mode 已完成建库）。
- [ ] handoff 输出目录已确定。

**L2**

- [ ] 无新增谓词（doc-setup 免配置，真正验证发生在首次运行时）。

**L3**

- [ ] 座位表引用的每个 worker 在同一配置块中有完整定义（应用 / 运行时、确切模型、调用方式）。

**L4**

- [ ] 声明的 enforcement mode 与 harness 真实强制点一致。
- [ ] stop-gate 脚本可执行；哨兵不存在时运行一次，exit 0（fail-open 冒烟测试）。

## 7. 汇报合同

用人类的语言和密度（guide.md 的密度，不是本文的）汇报，五项：

1. **装了什么**：层级、组件、物理位置（链接还是副本）。
2. **没装什么、为什么**：一句话，层级纪律。
3. **全局变更**：哪个文件、什么 diff、何时获批。没有则写「无」。
4. **第一句话说什么**：从 guide.md 对应层的「使用方式」表逐字转述。
5. **升层信号**：下次出现什么症状再回来，一句话。
