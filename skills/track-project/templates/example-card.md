---
project: agent-orchestration
title: 跨模型 Agent 编排 / Opus-Codex-agy 三 family 执行
type: infra
phase: building
activity: cold
status_line: 跨模型任务编排已改为按需唤醒；依赖任务链仍待常驻服务启用后验证
next_action: daemon 激活后，在真实环境验证依赖任务链
blocked_by:
  - runtime-daemon
unblocks:
  - mobile-agent-bridge
  - device-lab
tags:
  - agent
  - orchestration
  - cross-model
  - error-diversity
started: 2026-06-08
last_touched: 2026-07-06
local_paths:
  - /path/to/llm-gateway
  - /path/to/device-lab
artifacts:
  - /path/to/playbooks/orchestration-playbook.md
  - /path/to/playbooks/spec-playbook.md
  - /path/to/playbooks/worker-profiles.md
  - /path/to/llm-gateway/README.md
---

# 跨模型 Agent 编排

这个项目维护一套让多个不同模型协同工作的本地执行方法：一个主模型负责拆解和判断，其他模型在隔离任务中实现、复核或提出问题。目标是让并行任务的状态可见、结果可审计、异常能停下来请求裁决，同时减少主模型反复轮询造成的上下文浪费。

## 人类视图

**状态**：跨模型编排已从强调流程训练，转为给具备编排能力的主模型提供低噪声、可审计、可取消的执行基建。任务派发、静默等待、异常提问和答复续跑已经形成闭环，默认只在需要裁决时唤醒编排者。当前还缺两类实战证据：依赖任务链在常驻服务启用后的真机验证，以及真实提问场景的完整答复链路。后续会继续观察多任务并发的唤醒次数，以及不同编排入口是否需要更简洁的封装。

**等你的**：

- 无，当前全自动推进中。

## 整体和路线

用 Opus 做 orchestrator，Codex 和 agy 做 execution workers，形成跨模型分层执行架构。核心价值来自 error diversity 和 context 效率。
