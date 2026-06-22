<MASTER_VERIFICATION_PROMPT version="1.0" repo="vps-launchpad">

<mission>
Pre-build agentic engineering verification gate.
ROLE: agent:eval | MODE: read-only | HITL: 🟢 AUTO
EXECUTE ALL tasks in order. DO NOT implement. DO NOT modify files.
OUTPUT: single JSON block conforming to <output_schema>. Nothing else after JSON.
</mission>

<rules priority="ABSOLUTE">
R1: Read files — never write, never execute shell on prod
R2: If a file is missing, status=FAIL, do not infer its contents
R3: If uncertain → status=WARN, not PASS
R4: Community research = web search required; if unavailable, status=SKIP with note
R5: Output JSON must be valid — no trailing commas, no comments inside JSON
R6: build_ready=true ONLY if zero FAIL items exist
</rules>

<context_load order="STRICT">
1. CLAUDE.md
2. context/snapshot.md
3. context/stack.md
4. context/decisions-index.md
5. AGENTS.md (root)
6. agents/hitl/gates.md
7. governance/rules/core-rules.md
8. agents/tools/architect.md
9. agents/tools/devops.md
10. agents/tools/security.md
11. agents/tools/eval.md
12. agents/memory/session-init.md
13. agents/memory/context-budget.md
14. agents/evals/baseline.md
15. governance/policies/token-efficiency.md
16. ports/mappings/master-port-map.md
17. .github/workflows/hitl-governance.yml
18. .github/workflows/context-freshness.yml
</context_load>

<verification_tasks>

<!-- ═══════════════════════════════════════════════════════ -->
<!-- CATEGORY A: CONTEXT INTEGRITY                          -->
<!-- ═══════════════════════════════════════════════════════ -->

<task id="A01" name="Context files present">
CHECK: All 4 always-loaded context files exist
FILES: CLAUDE.md | context/snapshot.md | context/stack.md | context/decisions-index.md
PASS: all 4 exist and non-empty
FAIL: any missing or empty
</task>

<task id="A02" name="Token budget compliance">
CHECK: Estimate token count for each context file (1 token ≈ 4 chars)
LIMITS: CLAUDE.md≤600 | snapshot.md≤400 | stack.md≤300 | decisions-index.md≤500 | any AGENTS.md≤400
PASS: all within limit
WARN: within 10% over limit
FAIL: any file >10% over limit
FINDING: list each file with estimated token count
</task>

<task id="A03" name="No content duplication across context files">
CHECK: Facts stated in one context file must not be restated verbatim in another
LOOK FOR: stack choices, VPS IP, port numbers, decision IDs repeated across files
PASS: no duplication found
WARN: minor overlap (1-2 facts)
FAIL: significant duplication (same section copied across files)
</task>

<task id="A04" name="Snapshot freshness">
CHECK: context/snapshot.md → parse "Last updated: YYYY-MM-DD"
COMPUTE: days since last update (compare to today's date in <mission> scope)
PASS: ≤7 days old
WARN: 8-30 days old
FAIL: >30 days old OR "Last updated" line missing
FINDING: include date and age in days
</task>

<task id="A05" name="Decisions index completeness">
CHECK: every row in context/decisions-index.md has: ID | Decision | Status | Source
VALIDATE: Status ∈ {✅ LOCKED | 🟡 PROPOSED | ⏳ PENDING}
VALIDATE: Source path exists in repo
PASS: all rows complete, all source paths valid
FAIL: any row missing a column OR source path doesn't exist
</task>

<task id="A06" name="Stack lock anti-hallucination guards">
CHECK: context/stack.md contains explicit "DO NOT propose alternatives" or equivalent guard
CHECK: context/decisions-index.md contains "DO NOT re-debate" or equivalent guard
CHECK: CLAUDE.md anti-hallucination rules section exists and has ≥4 rules
PASS: all three guards present
FAIL: any guard missing
</task>

<!-- ═══════════════════════════════════════════════════════ -->
<!-- CATEGORY B: AGENT ISOLATION & SCOPE                    -->
<!-- ═══════════════════════════════════════════════════════ -->

<task id="B01" name="Agent roles have tool specs">
CHECK: for each role in AGENTS.md root table (architect|devops|security|eval|hitl)
REQUIRE: corresponding file agents/tools/{role-id}.md exists
PASS: all roles have tool spec files
FAIL: any role missing its tool spec
</task>

<task id="B02" name="No overlapping write permissions">
CHECK: across agents/tools/*.md, extract all "file:write" allowed paths per agent
DETECT: any path writable by 2+ agents without explicit co-review requirement
PASS: no unguarded overlaps
WARN: overlap exists but co-review is documented
FAIL: overlap with no coordination mechanism
FINDING: list any overlaps found
</task>

<task id="B03" name="HITL gate coverage — all operation types">
CHECK: agents/hitl/gates.md defines gate level for these operation types:
  [file:read | file:write:brainstorm | file:write:infra | file:write:governance |
   github:pr | github:merge | ssh:exec | ufw:change | db:migrate | secret:write]
PASS: all 10 types have explicit gate assignment
FAIL: any type missing
FINDING: list any uncovered operation types
</task>

<task id="B04" name="Sub-agent context isolation documented">
CHECK: agents/memory/context-budget.md has explicit "Sub-agent token isolation" section
CHECK: agents/prompts/handoff.md exists and has "Files to read at session start" section
PASS: both present
FAIL: either missing
</task>

<task id="B05" name="Session init protocol complete">
CHECK: agents/memory/session-init.md has ≥3 phases (bootstrap | role | lazy-load)
CHECK: Phase 1 lists all 4 context/ files
CHECK: overflow/handoff protocol described
PASS: all present
FAIL: any missing
</task>

<!-- ═══════════════════════════════════════════════════════ -->
<!-- CATEGORY C: GOVERNANCE & CI INTEGRITY                  -->
<!-- ═══════════════════════════════════════════════════════ -->

<task id="C01" name="Core rules enforced in CI">
CHECK: governance/rules/core-rules.md defines rules R01–R08
FOR EACH rule, identify if CI workflow enforces it:
  R01(no secrets) → hitl-governance.yml secrets-scan job
  R02(hitl label) → hitl-governance.yml hitl-label-required job
  R03(no push main) → assumed GitHub branch protection (note: not in CI file)
  R04(AGENTS.md) → hitl-governance.yml agents-md-check job
  R05(port map) → manual only (PR checklist)
  R06(OSS-first) → manual only (PR checklist)
  R07(RAM ceiling) → monitoring (not in CI)
  R08(Docker caps) → manual only (PR checklist)
PASS: R01, R02, R04 have CI jobs; others documented as manual
FAIL: R01/R02/R04 missing from CI
WARN: R03 not in CI file (should be branch protection)
</task>

<task id="C02" name="CI workflow syntax check">
CHECK: .github/workflows/hitl-governance.yml — verify YAML structure:
  - has "on: pull_request: types:" trigger
  - has 3 jobs: hitl-label-required | secrets-scan | agents-md-check
  - secrets-scan uses run: (not uses: gitleaks-action) after latest edit
  - agents-md-check uses git rev-parse to filter pre-existing directories
PASS: all above present
FAIL: any structural issue
</task>

<task id="C03" name="PR checklist covers all rules">
CHECK: governance/checklists/pr-checklist.md
VERIFY: items map to R01–R08 in core-rules.md
VERIFY: agent-authored PR section exists
VERIFY: BLOCK PR section exists
PASS: all present
FAIL: any missing
</task>

<task id="C04" name="AGENTS.md in every directory">
CHECK: list all directories currently in repo
VERIFY: each has an AGENTS.md file
EXCEPTION: .git/ | .github/ | .github/workflows/ (CI config, not agent-operated)
PASS: all non-excepted dirs have AGENTS.md
FAIL: any non-excepted dir missing AGENTS.md
FINDING: list any missing
</task>

<!-- ═══════════════════════════════════════════════════════ -->
<!-- CATEGORY D: EVAL COVERAGE                              -->
<!-- ═══════════════════════════════════════════════════════ -->

<task id="D01" name="Failure mode coverage in evals">
CHECK: agents/evals/baseline.md
REQUIRED eval categories (≥1 question each):
  [HITL gate classification | stack lock compliance | context freshness |
   secret handling | memory/session continuity | sub-agent scope isolation |
   anti-hallucination unknown state | context overflow handling]
PASS: all 8 categories covered
FAIL: any category missing
FINDING: map each eval to its category
</task>

<task id="D02" name="Eval scoring criteria defined">
CHECK: each eval in baseline.md has:
  - Input (quoted string)
  - Expected behaviour (bullet list, not prose)
  - Score 5 criteria
  - Score 1 criteria (worst case)
PASS: all evals have all 4 components
WARN: missing score 3 (intermediate) — not blocking
FAIL: any eval missing Input OR Score 5 OR Score 1
</task>

<!-- ═══════════════════════════════════════════════════════ -->
<!-- CATEGORY E: COMMUNITY RESEARCH (web search required)  -->
<!-- ═══════════════════════════════════════════════════════ -->
<!-- If web search unavailable: status=SKIP for all E tasks -->

<task id="E01" name="Coolify — current version and issues">
SEARCH: "Coolify latest release 2025 self-hosted"
CHECK: latest stable version vs any version pinned in plugins/coolify/install.sh
CHECK: any known breaking changes in Coolify releases last 6 months
CHECK: Coolify GitHub issues for "Traefik SSL" or "GitHub OAuth" regressions
OUTPUT: version, known issues, compatibility with our stack
</task>

<task id="E02" name="FastAPI — security advisories">
SEARCH: "FastAPI security advisory 2025" OR "FastAPI CVE 2025"
CHECK: any critical CVEs affecting FastAPI + Pydantic v2 + Python 3.11+
OUTPUT: version range affected, mitigation if any
</task>

<task id="E03" name="SvelteKit — compatibility notes">
SEARCH: "SvelteKit breaking changes 2025" OR "SvelteKit 2.x migration"
CHECK: any breaking changes that would affect new project setup
OUTPUT: recommended version, any gotchas
</task>

<task id="E04" name="KeyDB — Redis compatibility">
SEARCH: "KeyDB vs Redis compatibility 2025" OR "KeyDB production issues 2025"
CHECK: any known compatibility gaps with Redis clients
CHECK: KeyDB maintenance status (active vs abandoned)
OUTPUT: status, recommendation
</task>

<task id="E05" name="Qdrant — API stability">
SEARCH: "Qdrant API breaking changes 2025" OR "Qdrant self-hosted stability"
CHECK: REST API stability (v1.x vs v2.x)
CHECK: Docker image size and resource requirements
OUTPUT: recommended version, API stability notes
</task>

<task id="E06" name="Langfuse — self-hosted requirements">
SEARCH: "Langfuse self-hosted 2025 requirements" OR "Langfuse docker compose"
CHECK: minimum RAM/CPU for self-hosted
CHECK: database dependencies (PostgreSQL version required)
CHECK: any known issues with self-hosted vs cloud version feature parity
OUTPUT: requirements, issues
</task>

<task id="E07" name="Agentic engineering anti-hallucination patterns">
SEARCH: "agentic AI hallucination prevention 2025" OR "LLM agent context management best practices"
CHECK: any community-documented patterns we're missing
CHECK: CLAUDE.md / AGENTS.md pattern used in OSS projects
OUTPUT: top 3 patterns not yet in our implementation
</task>

<task id="E08" name="Claude Code AGENTS.md and CLAUDE.md spec">
SEARCH: "Claude Code AGENTS.md specification" OR "Claude Code CLAUDE.md format 2025"
CHECK: official Anthropic documentation for CLAUDE.md structure
CHECK: any required fields or anti-patterns documented
CHECK: max file size recommendations from Anthropic
OUTPUT: compliance status vs official spec
</task>

</verification_tasks>

<output_schema>
EMIT EXACTLY this JSON structure. No markdown outside the JSON block.

```json
{
  "verification_run": {
    "date": "YYYY-MM-DD",
    "agent": "agent:eval",
    "repo": "rahlplx/vps-launchpad",
    "commit": "HEAD sha or 'unknown'",
    "prompt_version": "1.0"
  },
  "checks": [
    {
      "id": "A01",
      "category": "CONTEXT_INTEGRITY | AGENT_ISOLATION | GOVERNANCE_CI | EVAL_COVERAGE | COMMUNITY_RESEARCH",
      "name": "string",
      "status": "PASS | FAIL | WARN | SKIP",
      "finding": "one concise sentence — specific facts, not vague summaries",
      "action_required": "null OR imperative sentence describing exact fix needed",
      "hitl_gate": "AUTO | REVIEW | BLOCK | null"
    }
  ],
  "summary": {
    "total_checks": 0,
    "pass": 0,
    "fail": 0,
    "warn": 0,
    "skip": 0,
    "build_ready": false,
    "blockers": ["list of check IDs with status=FAIL"]
  },
  "community_research": [
    {
      "technology": "Coolify | FastAPI | SvelteKit | KeyDB | Qdrant | Langfuse",
      "version_in_stack": "from context/stack.md or 'unspecified'",
      "latest_stable": "string or 'unknown'",
      "known_issues": ["string"],
      "compatibility_notes": ["string"],
      "recommendation": "KEEP | UPGRADE | INVESTIGATE | REPLACE",
      "source_urls": ["string"]
    }
  ],
  "missing_patterns": [
    {
      "pattern": "string — community pattern not yet implemented",
      "why_needed": "string — which failure mode it prevents",
      "implementation_hint": "string — where in repo it would live",
      "priority": "HIGH | MEDIUM | LOW"
    }
  ],
  "recommended_actions": [
    {
      "priority": "HIGH | MEDIUM | LOW",
      "check_id": "A01",
      "action": "imperative sentence — what exactly to do",
      "file": "path/to/file or null",
      "hitl_gate": "AUTO | REVIEW | BLOCK",
      "estimated_effort": "MINUTES | HOURS | DAYS"
    }
  ]
}
```
</output_schema>

<execution_rules>
1. Run all A + B + C + D tasks from files — no web search needed
2. Run E tasks only if web search tool available; else status=SKIP with finding="web search unavailable"
3. Sort checks by category then ID
4. Populate recommended_actions ONLY for FAIL and WARN items
5. missing_patterns populated from E07 findings; if E07 SKIP → empty array
6. build_ready=true ONLY when summary.fail=0
7. After JSON: STOP. No explanation, no commentary.
</execution_rules>

</MASTER_VERIFICATION_PROMPT>
