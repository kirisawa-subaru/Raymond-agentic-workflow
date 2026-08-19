---
project: podcast-archiver
title: Podcast archive pipeline
type: pipeline
phase: building
activity: active
status_line: Feed ingestion and transcription stable; episode search index half-built
next_action: Wire the transcript index into the search endpoint and run the 50-episode backfill
blocked_by: []
unblocks: []
tags: [audio, search]
---

# Podcast archive pipeline

Fetches the podcasts I follow, transcribes new episodes, and builds a locally searchable archive — so quotes I half-remember can be found again without scrubbing through audio. Deliverable: a nightly pipeline plus a search endpoint. Terms used below: "backfill" = one-time processing of pre-existing episodes, as opposed to the nightly incremental run.

## Human View

**State**: New episodes are fetched and transcribed automatically every night, and that part has been stable for two weeks. Search is the remaining half: the index builds locally but isn't hooked up to the query endpoint yet, so the archive exists but can't be searched. No data has been lost; old episodes wait on a one-time backfill that runs after the endpoint works.

**Waiting on you**:
- Decide whether transcripts of paywalled feeds may be stored locally (storage is private, but you wanted to rule on it explicitly).

## Overview & Route

Three stages, each independently restartable: fetch (RSS poll → audio files), transcribe (local whisper run, one JSON per episode), index (transcript JSON → search index). Design bias: boring and restartable over clever — every stage is idempotent and can re-run from its inputs.

## Current Threads

### Thread: search endpoint

Status: active
Scope: query endpoint over the existing index + 50-episode backfill. Not in scope: ranking quality, UI.

#### Problem

Index format is settled but the endpoint returns raw index rows; needs the episode-metadata join before it's usable.

#### Approach

Join at query time (metadata is small); benchmark only if latency exceeds ~200ms.

#### To-do

- [ ] Metadata join in the query path
- [ ] Backfill the 50 pre-existing episodes
- [ ] Smoke-test: find three known quotes end-to-end

## Trajectory

- 2026-08-10 21:15 — Switched transcription from API to local whisper: cost was the blocker for backfill, and local quality proved sufficient on a 5-episode sample.
- 2026-08-03 18:40 — Split fetch and transcribe into separate stages after a feed outage corrupted a combined run; idempotent stages made the outage a non-event.

## Future Work

- Speaker diarization, only if search proves useful in practice.

> [!success]- Completed: feed ingestion + transcription stages (2026-08)
> - RSS poller with per-feed state files; survives feed outages by design.
> - Local whisper transcription; 5-episode quality sample archived in the history file.

## History

![[HISTORY/pipeline/podcast-archiver.history]]
