# WebAppSec — DevSecOps Lab

[![Security Gates](https://github.com/unclehacka/WebAppSec/actions/workflows/security.yml/badge.svg?branch=main)](https://github.com/unclehacka/WebAppSec/actions/workflows/security.yml)

A small, reproducible lab that shows how to gate Pull Requests with **SAST/SCA/DAST/IaC** on GitHub Actions.
PRs **fail on High/Critical**; SARIF reports are uploaded to **Security > Code scanning**.  

---

## What’s inside (CI)

- **SAST**: Semgrep (`p/owasp-top-ten` + `./semgrep.yml`) → `semgrep.sarif` (uploaded).
- **Secrets**: Gitleaks (PR diff or full repo) → `gitleaks.sarif` (uploaded).
- **SCA (filesystem)**: Trivy FS — **fails** on `HIGH,CRITICAL`.
- **SBOM**: Syft → JSON SBOM.
- **SCA (SBOM)**: Grype on SBOM — **fails** on `high`.
- **IaC**: tfsec (Terraform) and Checkov (Terraform/K8s/CFN) → `checkov.sarif` (uploaded).
- **DAST**: OWASP ZAP **Baseline** against a temporary target.
- **Image SCA**: Trivy **image** on `bkimminich/juice-shop` — **fails** on `HIGH,CRITICAL`.

**Triggers**: on `pull_request`, on push to `main`, scheduled nightly, and manual (workflow_dispatch).

---
## Fail policy (high level)
- Semgrep: `--severity ERROR --error` (PR fails on ERROR findings).
- Gitleaks: `exit-code=2` on leaks.
- Trivy FS: `--severity HIGH,CRITICAL --exit-code 1`.
- Grype on SBOM: `--fail-on high`.
- ZAP Baseline: `fail_action: true` + rules in `.zap/rules.tsv` (e.g., CSP/Anti-CSRF).
- Trivy image: `--severity HIGH,CRITICAL --exit-code 1`.
- tfsec & Checkov: hard-fail on findings.
---
