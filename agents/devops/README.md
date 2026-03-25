---
model: claude-sonnet-4-6
---

# DevOps Agents

DevOps-focused agent instruction files for container packaging, Kubernetes, observability, CI/CD pipelines, infrastructure-as-code, and DevOps strategy.

## Available Agents

| File | Role | Focus |
|---|---|---|
| `docker.md` | Container Packaging Engineer | Dockerfiles, multi-stage builds, image security, Docker Compose |
| `kubernetes.md` | Kubernetes Engineer | Workload design, Helm charts, RBAC, network policies, HPA |
| `observability.md` | Observability Engineer | OpenTelemetry, Prometheus, SLOs, structured logging, alerting |
| `cicd-architect.md` | CI/CD Architect | GitHub Actions, deployment strategies, artifact promotion, rollback |
| `terraform.md` | Infrastructure Engineer | Terraform modules, remote state, testing, IaC best practices |
| `devops-architect.md` | Principal DevOps Architect | Platform engineering, GitOps, SRE practices, DORA metrics, incident management |

## Usage

Reference a file directly in your prompt to load that agent's persona and standards:

```bash
claude --agent devops/docker.md "review this Dockerfile for security and size issues"
claude --agent devops/kubernetes.md "design the Kubernetes manifests for a stateless HTTP service"
claude --agent devops/observability.md "define SLOs and alerting for the payment service"
claude --agent devops/cicd-architect.md "design a GitHub Actions pipeline with blue/green deployment"
claude --agent devops/terraform.md "write a Terraform module for an ECS Fargate service"
claude --agent devops/devops-architect.md "assess our delivery pipeline against DORA metrics"
```

Or paste the file contents as a system prompt when building with the API.

## Setting Up Named Agents

To call agents by name from anywhere in Claude Code, symlink or copy these files into `~/.claude/agents/`:

```bash
mkdir -p ~/.claude/agents

# Symlink all DevOps agents
for f in ~/repos/ai/agents/devops/*.md; do
  name=$(basename "$f" .md)
  ln -sf "$f" ~/.claude/agents/"${name}.md"
done
```

This makes them available as subagent types: `docker`, `kubernetes`, `observability`, `cicd-architect`, `terraform`, `devops-architect`.

## Model Default

All agents in this directory default to `claude-sonnet-4-6` (Sonnet 4.6). To override for a specific agent, add a `model` field to that file's frontmatter.

## Agent Pairing

These agents work well in combination for end-to-end delivery concerns:

```bash
# New service delivery pipeline
claude --agent devops/docker.md           "review and harden the container image"
claude --agent devops/kubernetes.md       "generate production-ready Kubernetes manifests"
claude --agent devops/cicd-architect.md   "wire up the GitHub Actions pipeline"
claude --agent devops/observability.md    "define SLOs, dashboards, and alerts"

# Infrastructure delivery
claude --agent devops/terraform.md        "write the ECS service Terraform module"
claude --agent devops/cicd-architect.md   "build the Terraform plan/apply pipeline"

# Platform review
claude --agent devops/devops-architect.md "assess current state and prioritize improvements"
claude --agent devops/observability.md    "audit the alerting setup for noise and coverage"
```
