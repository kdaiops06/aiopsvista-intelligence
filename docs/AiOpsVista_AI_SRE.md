# AI-SRE Discussion --- Edge Delta

## Quick Reference for Conversation with Ozan Unlu

**Purpose:** Discuss the evolution from traditional observability + AI
assistants toward telemetry-native, agentic AI-SRE.

------------------------------------------------------------------------

## 1. My 30-Second Opening

> I've been working on an AiOpsVista Intelligence reference platform
> focused on AI infrastructure and AI-SRE. The foundation is primarily
> GCP/GKE with OpenTelemetry, Prometheus, Grafana, Langfuse and OpenLIT,
> with BigQuery as an analytics layer.
>
> What I'm exploring now is the jump from traditional observability plus
> an AI assistant to true agentic SRE --- where an agent can correlate
> telemetry, deployment and application context, investigate an incident
> across systems, form a hypothesis, validate it, and eventually take a
> controlled remediation action.
>
> I'm particularly interested in your view of where MCP fits versus a
> telemetry-native architecture, and where you see the biggest practical
> gains.

------------------------------------------------------------------------

# 2. Question 1 --- What tools are you currently using for observability?

### Answer

**Current/reference stack:**

-   GCP / GKE
-   OpenTelemetry
-   Prometheus
-   Grafana
-   Langfuse --- LLM/application observability
-   OpenLIT --- AI/LLM observability
-   BigQuery --- analytics/correlation layer
-   GCP-native observability capabilities where appropriate

### Key point

> **The problem isn't really lack of telemetry. We can collect a huge
> amount of telemetry. The harder problem is turning telemetry into
> operational context and a reliable investigation workflow.**

### Architecture

``` text
Applications / AI Workloads
          |
          v
   OpenTelemetry
          |
   +------+------+------+
   |      |      |      |
 Metrics Logs  Traces  AI/LLM
   |      |      |      |
   +------+------+------+
          |
   Observability Layer
          |
   +------+------+------+
   |             |
Grafana      Langfuse/OpenLIT
          |
          v
       Analytics
       BigQuery
```

------------------------------------------------------------------------

# 3. Question 2 --- Is Claude/Codex connected via MCP?

### Recommended answer

> **Not yet in production. I've been evaluating the architecture and MCP
> is something I'm actively exploring. My current work has focused first
> on establishing the telemetry and observability foundation.**

Then make this point:

> **MCP solves the tool-access problem; it doesn't necessarily solve the
> context problem.**

### Explain

If Claude/Codex connects to Grafana through MCP:

``` text
Claude / Codex
      |
     MCP
      |
   Grafana
      |
Telemetry
```

The agent can query the observability system, but it is still largely
dependent on:

-   What Grafana exposes
-   Dashboard structure
-   Available queries
-   Context available through that interface
-   The agent's ability to correlate information across other systems

### Better question

> **How do we give an agent a unified operational model across
> telemetry, Kubernetes, deployments, GitHub, incidents, architecture
> and historical incidents?**

------------------------------------------------------------------------

# 4. MCP vs Telemetry-Native AI-SRE

## Model A --- AI on top of observability

``` text
Claude / Codex
      |
     MCP
      |
Grafana / Datadog
      |
Logs / Metrics / Traces
```

**Benefit:** Fast way to make existing observability AI-accessible.

**Limitation:** The AI is still querying the existing observability
tool.

------------------------------------------------------------------------

## Model B --- AI connected to multiple tools

``` text
                 +-- Grafana
                 +-- Datadog
Claude / Codex --+-- GitHub
                 +-- Kubernetes
                 +-- PagerDuty
```

**Benefit:** More context.

**Limitation:** The agent has to perform the correlation itself.

------------------------------------------------------------------------

## Model C --- Telemetry-Native AI-SRE

``` text
             +-- Logs
             +-- Metrics
             +-- Traces
             +-- Kubernetes
             +-- Deployments
             +-- GitHub
             +-- Incidents
             +-- Historical incidents
                      |
                      v
             +------------------+
             | Operational      |
             | Context / Graph  |
             +------------------+
                      |
                      v
                AI SRE Agents
                      |
          +-----------+-----------+
          |           |           |
          v           v           v
       Detect     Investigate    Act
          |           |           |
          +-----------+-----------+
                      |
                      v
                   Validate
```

### Core discussion question

> **What makes a telemetry-native agent materially better than an LLM
> connected to multiple observability tools through MCP?**

------------------------------------------------------------------------

# 5. Question 3 --- Biggest Incident Response Gaps

I would describe four major gaps.

## A. Signal fragmentation

Today:

``` text
Logs       -> one system
Metrics    -> another
Traces     -> another
Deployments -> GitHub
Kubernetes -> another
Incidents  -> another
```

The SRE has to mentally connect them.

### Problem

> **Are these signals actually part of the same incident?**

------------------------------------------------------------------------

## B. Too much telemetry, not enough context

> We can collect enormous amounts of telemetry. Giving an AI agent more
> raw telemetry doesn't automatically make the investigation better.

Potential problems:

-   High investigation cost
-   Large context windows
-   Irrelevant signals
-   Slow investigations
-   False correlations
-   Difficult evidence tracking

### Desired capability

**Reduce the search space before asking the agent to reason.**

------------------------------------------------------------------------

## C. Human-built correlation

An experienced SRE often builds this graph mentally:

``` text
Incident
   |
   v
Service
   |
   +--> Pod
   |
   +--> Dependency
   |
   +--> Database
   |
   +--> Recent Deployment
   |
   +--> Error / Trace
   |
   +--> Customer Impact
```

### Opportunity

> **I'd like the platform to build that operational context
> automatically.**

------------------------------------------------------------------------

## D. Root cause vs validated root cause

I'm less interested in:

> "I think this is the root cause."

I'm more interested in:

``` text
Hypothesis
    |
    v
Evidence
    |
    v
Proposed remediation
    |
    v
Validation criteria
    |
    v
Execute safely
    |
    v
Verify outcome
```

### Key point

> **AI-SRE should not stop at root-cause analysis. It should be able to
> validate whether the proposed explanation and remediation are actually
> correct.**

------------------------------------------------------------------------

# 6. Question 4 --- Biggest Opportunity for Improvement

My answer:

> **Correlation first, then automated validation.**

I would describe the maturity path as:

### Stage 1 --- Noise Reduction

``` text
10,000 signals
      |
      v
1 meaningful incident
```

### Stage 2 --- Correlation

``` text
Incident
   |
   +--> Service
   +--> Dependency
   +--> Deployment
   +--> Infrastructure
   +--> Telemetry
   +--> Historical incidents
```

### Stage 3 --- Investigation

``` text
Evidence
   |
   v
Hypothesis
   |
   v
Root Cause
```

### Stage 4 --- Validation

``` text
Root Cause
    |
    v
"What evidence would prove this?"
    |
    v
Validate
```

### Stage 5 --- Controlled Remediation

``` text
Recommend
    |
Approval
    |
Execute
    |
Verify
    |
Rollback if needed
```

------------------------------------------------------------------------

# 7. Questions I Want to Ask Ozan

## Highest priority

### 1. Telemetry-native differentiation

> **When you say "telemetry-native," what context does Edge Delta
> maintain that an MCP-connected Grafana or Datadog agent fundamentally
> doesn't have?**

------------------------------------------------------------------------

### 2. Knowledge graph

> **How are relationships between telemetry signals, services,
> dependencies, deployments and incidents represented? Is this
> explicitly maintained as a knowledge graph, or dynamically
> reconstructed during investigation?**

------------------------------------------------------------------------

### 3. Investigation scope

> **How do you prevent an AI agent from investigating the entire
> universe of telemetry? What mechanisms narrow the investigation
> context?**

This is particularly important for:

-   Cost
-   Speed
-   Accuracy
-   Agent reliability

------------------------------------------------------------------------

### 4. Measuring AI-SRE effectiveness

> **How do you measure whether the AI investigation is actually better
> than a senior SRE?**

Potential metrics:

-   MTTR
-   Time to root cause
-   Investigation duration
-   Number of investigation steps
-   False hypotheses
-   Evidence quality
-   Remediation success
-   Human intervention rate

------------------------------------------------------------------------

### 5. Autonomy boundary

> **Where do you draw the autonomy boundary? What can the AI safely
> execute versus what requires human approval?**

------------------------------------------------------------------------

### 6. Financial-services applicability

> **For a regulated environment like financial services, how do you
> maintain auditability of the agent's investigation --- evidence,
> hypotheses, actions and approvals?**

Relevant to environments like:

-   Banking
-   Credit
-   Financial services
-   Regulated production environments

------------------------------------------------------------------------

# 8. Important Discussion Theme --- Context Engineering

A useful phrase:

> **"The future problem isn't just model intelligence. It's operational
> context engineering."**

An AI-SRE agent needs context from:

``` text
Telemetry
+
Topology
+
Infrastructure
+
Code
+
Deployments
+
Configuration
+
Incidents
+
Historical knowledge
+
Business/customer impact
```

The more accurately these relationships are represented, the less the
agent has to infer.

------------------------------------------------------------------------

# 9. Agentic Investigation Lifecycle

A useful target architecture:

``` text
                    INCIDENT
                       |
                       v
                 Detect / Alert
                       |
                       v
               Context Gathering
                       |
        +--------------+--------------+
        |              |              |
        v              v              v
     Metrics         Logs          Traces
        |              |              |
        +--------------+--------------+
                       |
                       v
                Correlation Engine
                       |
                       v
              Operational Context
                       |
                       v
               AI Investigation
                       |
             +---------+---------+
             |                   |
             v                   v
        Hypothesis A        Hypothesis B
             |                   |
             +---------+---------+
                       |
                       v
                   Evidence
                       |
                       v
                Root Cause?
                       |
                       v
              Remediation Plan
                       |
                 Human Approval
                       |
                       v
                  Execute
                       |
                       v
                   Validate
                       |
                       v
                Incident Closed
```

------------------------------------------------------------------------

# 10. Where I See AiOpsVista Going

Current foundation:

``` text
GCP / GKE
Terraform
OpenTelemetry
Prometheus
Grafana
Langfuse
OpenLIT
BigQuery
```

Next evolution:

``` text
Telemetry
    |
    v
Operational Context
    |
    v
AI Investigation Agents
    |
    +--> Root Cause Analysis
    +--> Dependency Analysis
    +--> Deployment Correlation
    +--> Cost Analysis
    +--> Incident Summarization
    +--> Remediation Recommendation
    +--> Automated Validation
```

Longer term:

``` text
              AI SRE
                 |
      +----------+----------+
      |          |          |
    Detect    Investigate   Act
      |          |          |
      +----------+----------+
                 |
              Validate
                 |
             Learn / Update
                 |
          Historical Context
```

------------------------------------------------------------------------

# 11. Strong Statements I Can Use

### Statement 1

> **"Telemetry isn't the scarce resource anymore. Context is."**

### Statement 2

> **"MCP solves how an agent accesses tools. It doesn't necessarily
> solve how the agent understands the operational system."**

### Statement 3

> **"I don't want an AI that can query Grafana. I want an AI that
> understands why the Grafana signals, Kubernetes events, deployment
> changes and application traces are related."**

### Statement 4

> **"Root-cause generation is useful; root-cause validation is where I
> think AI-SRE becomes much more powerful."**

### Statement 5

> **"The real SRE workflow is not search. It's hypothesis → evidence →
> validation → action → verification."**

### Statement 6

> **"The goal isn't to replace the SRE. It's to compress the
> investigation time of a senior SRE and make that expertise available
> consistently."**

------------------------------------------------------------------------

# 12. What NOT to Claim

Be precise about current implementation.

Don't say:

> "We already have a production AI-SRE platform."

Instead:

> **"We've built the observability and AI-infrastructure foundation and
> are exploring the agentic SRE layer."**

Don't claim MCP integration is production-ready if it isn't.

Say:

> **"MCP is an architecture I'm evaluating, particularly for tool access
> and agent integration."**

This positions the conversation as a genuine technical exploration.

------------------------------------------------------------------------

# 13. If Ozan Asks "What Would You Want From Edge Delta?"

Possible answer:

> **"I'd like to understand three things. First, how your
> telemetry-native approach creates operational context across logs,
> metrics, traces and the surrounding infrastructure. Second, how your
> agents narrow an investigation and avoid simply throwing huge volumes
> of telemetry into an LLM. And third, how you move from investigation
> to safe, auditable remediation and validation."**

Then add:

> **"If those three pieces are strong, that's where I see a meaningful
> difference versus simply connecting Claude or Codex to Grafana through
> MCP."**

------------------------------------------------------------------------

# 14. If the Conversation Turns Commercial

Ask:

> **What part of the stack would Edge Delta replace versus complement?**

> **Does Edge Delta become the system of investigation while
> Grafana/Datadog remain visualization systems?**

> **How does telemetry ingestion affect existing observability costs?**

> **What does the architecture look like if an enterprise already has
> OpenTelemetry?**

> **Can Edge Delta operate without forcing an organization to replace
> its existing observability stack?**

> **Where is the 50%+ cost improvement actually realized --- ingestion,
> storage, querying, licensing, investigation time, or all of these?**

------------------------------------------------------------------------

# 15. My Desired Takeaway From the Meeting

I should leave the meeting understanding:

1.  **What "telemetry-native" really means technically**
2.  How Edge Delta's architecture differs from:
    -   Grafana + MCP
    -   Datadog + MCP
    -   Claude/Codex + MCP
    -   Traditional AIOps
3.  How their knowledge graph/context layer works
4.  How agents perform investigations
5.  How investigation context is narrowed
6.  How they measure AI-SRE effectiveness
7.  How remediation is controlled
8.  How auditability works
9.  How Edge Delta integrates with OpenTelemetry/GCP/GKE
10. Where it could fit into the AiOpsVista architecture

------------------------------------------------------------------------

# Final 10-Second Mental Model

If you get lost during the call, come back to this:

``` text
Traditional Observability
        |
        v
Collect Telemetry
        |
        v
Human Correlation
        |
        v
Human Investigation
        |
        v
Human Remediation


AI-Assisted Observability
        |
        v
Collect Telemetry
        |
        v
MCP / AI Queries
        |
        v
AI-Assisted Investigation
        |
        v
Human Remediation


Telemetry-Native AI-SRE
        |
        v
Unified Telemetry + Context
        |
        v
Operational Knowledge Graph
        |
        v
Agentic Investigation
        |
        v
Hypothesis + Evidence
        |
        v
Validation
        |
        v
Controlled Remediation
        |
        v
Verification
```

## One question to anchor the whole conversation

> **"What is the architectural boundary between an AI assistant that
> queries observability tools and an AI-SRE system that actually
> understands the operational state of the environment?"**
