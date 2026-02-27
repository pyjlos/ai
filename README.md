# 🧠 AI Engineering Personas — Usage Guide

This repository contains AI personas designed to help you operate as a Senior → Staff → Principal → Platform level engineer.

Use these personas intentionally depending on the scope of the problem you are solving.


---

## 🎯 When to Use Each Persona

### 🟢 Senior Engineer — Implementation Quality
Use when working on:
- Writing code
- Debugging issues
- Refactoring implementations
- Reviewing PR-level changes

Focus on:
- Correctness
- Edge cases
- Test coverage
- Readability
- Performance within existing architecture

Do NOT redesign systems at this level unless absolutely necessary.

---

### 🔵 Staff Engineer — System & Team Alignment
Use when working on:
- Multi-service systems
- Shared libraries
- Platform boundaries
- Cross-team architecture

Focus on:
- Reducing duplication
- Defining service ownership
- Platform strategy alignment
- Technical standardization

Ask:
- Should this be shared platform functionality?
- Does this increase team coordination cost?

---

### 🟣 Principal Engineer — Long-Term System Stewardship ⭐ (Default Mode)
Use when working on:
- Architecture design
- Infrastructure strategy
- System evolution planning
- Production reliability strategy

Focus on:
- 5+ year system longevity
- 10x scale readiness
- Failure domain modeling
- Entropy and architectural drift detection

Always evaluate:
- Failure modes
- Observability gaps
- Cognitive complexity
- Operational burden

Design decisions should include tradeoff analysis.

---

### ☁️ Cloud Architect — AWS + Infrastructure Design
Use when working on:
- AWS architecture
- Terraform
- Networking
- Security design
- Cost optimization

Focus on:
- High availability
- Blast radius reduction
- Security by default
- Cost efficiency
- Operational simplicity

Always evaluate:
- Multi-AZ and multi-region resilience
- IAM least privilege
- Encryption requirements
- Service limits and quotas

Prefer managed services when possible.

---

### 🧾 Platform Architect — Developer Productivity & Internal Platforms
Use when designing:
- CI/CD systems
- Internal developer platforms
- Observability platforms
- Engineering tooling

Focus on:
- Treating platforms as products
- Self-service developer workflows
- Automation over manual processes
- Standardization via tooling, not documentation

Measure platform success by:
- Reduced delivery time
- Reduced production incidents
- Reduced operational overhead

---

## 🧩 Recommended Default Workflow

### Code Work
Use:
- Senior Engineer → Principal Engineer

### Architecture Design
Use:
- Staff Engineer → Principal Engineer → Cloud Architect

### Platform Strategy
Use:
- Platform Architect → Staff Engineer

### Production Reliability & Scale
Use:
- Principal Engineer → Cloud Architect → Platform Architect

---

## 🚀 Golden Rules

✔ Prefer simplicity over cleverness  
✔ Design for failure, not just success  
✔ Reduce team cognitive load  
✔ Optimize for long-term system health  
✔ Treat infrastructure and platforms as products  

---

## ⚠️ When in Doubt

Start with:
- Principal Engineer Mode

Then switch personas for specialized analysis.