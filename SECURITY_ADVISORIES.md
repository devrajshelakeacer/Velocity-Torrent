# Security Advisories

This document records published security advisories, vulnerability disclosures, CVE identifiers, and remediation details for VELOCITY.

---

## Advisories Log

### VELOCITY-ADV-2026-0001 (Baseline Security Hardening)
- **Date**: 2026-11-11
- **Severity**: Informational / Baseline
- **Affected Versions**: < 1.0.0
- **Summary**: Implemented proactive architectural safeguards against historical BitTorrent client vulnerability vectors.
- **Remediations**:
  - `VShieldSanitizer` eliminates path traversal via directory containment and NTFS Alternate Data Stream suppression.
  - `BencodeGuard` enforces a 64-level recursion depth limit and a 15 MiB file size ceiling to prevent parser stack overflow.
  - Microsoft Defender CLI and AMSI integration scans completed downloads to quarantine suspicious files prior to access.
  - User-Controlled Thermal Guardian alerts users of elevated thermals without forced speed cuts, preserving user control.
