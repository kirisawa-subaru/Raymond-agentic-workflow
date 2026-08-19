# Raymond Agentic Workflow

## 使用方式

纯 Markdown 文档 + 薄脚本，脚本可使用本地 agent 重新编写以适配环境。

安装到 `.claude`、`.codex` 等 agent 目录中即可使用，**推荐成套使用**。

内有部分项目或文件路径内联。强烈建议第一次运行时先用 `/workflow-setup` 进行配置，将本机目录写入 skill 中，方便 agent 使用。

### 通常使用流程

#### 立项时

```mermaid
flowchart LR
    A["/track-project"] --> B["/doc-setup"] --> C["/orchestration"]
```

#### 施工中

```mermaid
flowchart LR
    A["/orchestration"] --> B["/track-project"] --> C["/batch-hook"]
```
人读报告:           `/decode`
换窗或 compact ：   `/handoff`

## Skill 介绍（排名分先后）

### [`/track-project`](skills/track-project/)

> 给人用的项目仪表盘 + 最小化的长期记忆
>
> **非常之关键的重要 skill，推荐写进 `CLAUDE.md`/ `agent.md`，每次运行时前置加载，避免忘记。**

建议在 Obsidian 中搭配 Dataview 使用。

人只需要看 `INDEX + 人类视图`, 就能够快速抓住项目的进行状态、历史记录、下一步要做的事，尤其适合同时推进多个不同项目。


### [`/orchestration`](skills/orchestration/)

> 规定项目里各agent的角色,分工和协调方式

简单地说：**user + 车头（可用的最强 model）+ workers**。

workers 在项目的不同阶段有不同职责：有后端代码民工（Implementation）、前端民工（Style），也有各种保证质量的角色（Review、QA……）。26年中旬的 AI 写代码本身问题不大，但 review 代码压力很大。

按照这个编排运作起来，理想状态下，人可以不看 worker 的输出，一切压力和问题交给车头（Orchestrator）解决。看不懂就用 `/decode` 讲解。

在这个架构下，在方向正确的前提下，人基本不需要看实现细节，但需要花费更多精力为 agent 提供多样性。只要你能想得出来的方面，agent 就能把洞补得无比结实。但不管用什么 prompt，目前 agent 都很难跳出局部最优。人还是要时时看着的。

具体结构：

| 角色 | 职责 |
| --- | --- |
| Operator（通常是 user） | 确定方向、品味把控、危险决策、升级响应、真机验收 |
| Orchestrator（编排者、车头） | 冻结契约、编写对抗性测试、生成 prompts、合并裁决与抽检、保持上下文连贯性 |
| Implementation（实现） | 逻辑 / 数据 / API / 构建 / 测试执行，可恢复的会话线程（resumable threads） |
| QA（质量保证） | 验证脚本、部署、基于证据的报告、独立会话线程 |
| Review A（审查 A） | 大型设计规范审查：每次使用全新实例，防止被既有风格同化 |
| Review B（审查 B） | 互补维度规范审查：不同模型家族，侧重机制与边界 |
| Style（样式） | 纯 CSS / 视觉 / 布局 / 动画 / 响应式工作 |

### [`/handoff`](skills/handoff/)

> 用于保留默认 `/compact` 易丢失的重要信息
>
> 教 compact 后的 Orchestrator 如何调整交互方式，以最大化协作

`user` 就算 coding 的时候也是个人，而不是一团信息或者程序。

默认 compact 很容易把上下文压成信息摘要，丢失和 交互/思路 相关的信息。
为了避免 compact 后协作效率下降，单独使用 `/handoff` skill 以保留协作相关信息。

理想效果是让 Orchestrator 在 user 累时少问决策、多做执行；兴奋时趁热推进高创造性的工作；frustration 高时先解决 blocker，再谈方向。

和默认 `/compact` 对比：

| 维度 | `/compact` | 举例 |
| --- | --- | --- |
| 事实（what） | ✓ | “改了 `llm.py` 第 42 行” |
| 关系（register） | ✗ | “这个 session 说中文，用户喜欢被 push back” |
| 因果（why） | ✗ | “选 timeout 而不是 signal reaping，是因为……” |
| 临时态（ephemeral） | ✗ | “subagent X 还活着，里面缓存了 Y” |
| 情绪（user state） | ✗ | “用户在这个点上有挫败感” |
| 置信度（calibration） | ✗ | “这个 fix SHIPPED，但 production 场景未验证” |
| 框架（meta） | ✗ | “我们正在用方法 X 做实验” |

### [`/doc-setup`](skills/doc-setup/)

> 给 AI 的项目文档指南，立项必备

和一般的项目文档最大的区别在：

- **`principle.md`：** 专写和 agent 直觉相反的设计准则（比如我不要磨砂玻璃风格，就要 98 年代怀旧 UI）。
- **Partition by lifecycle, not by topic：** 让 agent 一眼就知道该看哪、该写哪。

### [`/decode`](skills/decode/)

> 黑话翻译指南

将 agent 输出报告转换为人类易读的样式和版本：

- 肥波（Fable）语：超高概念密度，充满黑话，且默认读者自带完整项目上下文。
- Codex 语：极为完整、详细的报告，内含大量执行细节，长度超过人类能够记忆和理解的极限。

用户粘贴输出报告片段，agent 识别这两种类型，按照针对性的方式将黑话翻译成较为符合人类认知习惯的报告。

推荐 model：`claude-opus-4-6`

### [`/batch-hook`](skills/batch-hook/)

> loop 的另一种方式，允许合理停工，但不允许自我欺骗 / 幻觉

Opus 比较懒，当车头时总容易半路停下来，可以在跑过夜任务之前用这个 skill 设 loop。

## 许可证

Copyright © 2026 kirisawa-subaru

本项目采用 [GNU General Public License v3.0 only](LICENSE)，SPDX 标识：`GPL-3.0-only`。
