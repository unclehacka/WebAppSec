# WebAppSec — DevSecOps Lab

[![Security Gates](https://github.com/unclehacka/WebAppSec/actions/workflows/security.yml/badge.svg?branch=main)](https://github.com/unclehacka/WebAppSec/actions/workflows/security.yml)

A small, reproducible lab that gates PRs with **SAST/SCA/DAST/IaC** on GitHub Actions. PRs **fail on High/Critical**;
SARIF goes to **Security → Code scanning**.

---

## CI

- **SAST**: Semgrep (`p/owasp-top-ten` + `./semgrep.yml`) → `semgrep.sarif`
- **Secrets**: Gitleaks (PR diff or full repo) → `gitleaks.sarif`
- **SCA (filesystem)**: Trivy FS — **fails** on `HIGH,CRITICAL` → `trivy-fs.sarif`
- **SBOM**: Syft → JSON SBOM.
- **SCA (SBOM)**: Grype on SBOM — **fails** on `high`.
- **IaC**: tfsec (Terraform) and Checkov (Terraform/K8s/CFN) → `checkov.sarif`
- **DAST**: OWASP ZAP **Baseline** (Docker) vs `http://waf:8080`, rules from `.zap/rules.conf`
- [**GitHub Pages**](https://unclehacka.github.io/WebAppSec/zap/index.html) - Latest baseline report HTML.
- **Triggers**: `pull_request`, push to `main`, nightly schedule, manual.

---

## Fail policy

- Semgrep: `--severity ERROR --error`.
- Gitleaks: `exit-code=2`.
- Trivy FS: `--severity HIGH,CRITICAL --exit-code 1`.
- Grype: `--fail-on high`.
- tfsec & Checkov: hard-fail.
- ZAP Baseline: **FAIL** with rules `.zap/rules.conf`;
