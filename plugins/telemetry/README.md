# Telemetry Stack — Lightweight Observability

Two-layer observability optimized for a single VPS with R07 constraints (20GB RAM ceiling).

**Total RAM budget: ~384MB** (vs Langfuse's 2GB+)

## Why not Langfuse?

Langfuse requires PostgreSQL + ClickHouse + Redis + app server = 5 services, ~2GB RAM minimum. For a single VPS that's 10% of our hard ceiling wasted on observability alone.

## Layers

### Layer 1: System metrics — Netdata (256MB cap)
- RAM, CPU, disk, network, Docker container stats
- Real-time dashboard at `http://localhost:19999` (internal only)
- Zero config, auto-discovers Docker containers

### Layer 2: LLM/agent traces — MLflow (128MB cap)
- SQLite backend — no external database needed
- Built-in UI for experiment tracking and trace visualization
- Agent session traces, token usage, latency, model versions
- Dashboard at `http://localhost:5000` (internal only)
- Can scale to PostgreSQL + S3 later if needed

### Layer 3: CI/CD + pipeline metrics — JSON snapshots (0MB overhead)
- Collected via `collect-telemetry.sh` script
- Git log, PR metrics, CI pass/fail rates
- Stored as timestamped JSON in `telemetry/snapshots/`
- Fed into weekly retro pipeline

## Alert thresholds

| Metric | Warning | Critical | Auto-action |
|--------|---------|----------|-------------|
| RAM used | >16GB (67%) | >20GB (83%) | Stop low-priority containers |
| CPU sustained | >70% 5min | >90% 5min | Scale down workers |
| Disk used | >80% | >90% | Prune Docker images + logs |
| Container restart | >3/hour | >10/hour | Alert + investigate |

## Snapshot format

```json
{
  "timestamp": "2026-06-22T12:00:00Z",
  "system": { "ram_used_gb": 12.4, "cpu_pct": 35, "disk_pct": 62 },
  "containers": [{ "name": "postgres", "ram_mb": 256, "cpu_pct": 5, "restarts": 0 }],
  "ci": { "runs_24h": 8, "pass_rate": 0.875, "avg_duration_s": 45 }
}
```

## Alternatives evaluated

| Tool | RAM | Why not |
|------|-----|---------|
| Langfuse | ~2GB | Too heavy, needs 5 services |
| Phoenix (Arize) | ~1-3GB | Still needs PostgreSQL |
| Evidently | ~128MB | Good, but MLflow has better experiment tracking + wider ecosystem |
| Plain JSON logs | 0MB | No dashboard, no tracing UI |
