# VELOCITY — Security Architecture & Threat Model

## 1. Trust Boundaries & Security Objectives

VELOCITY treats all incoming BitTorrent swarm data, `.torrent` metadata files, and remote peer packets as **untrusted external input**.

```
[ UNTRUSTED ZONE ]                           [ TRUSTED ZONE ]
Remote Swarm Peers    --- (BitTorrent Packets) --> [ libtorrent Socket Pipeline ]
Untrusted .torrent    --- (Raw Bencode File)   --> [ BencodeGuard (Depth/Size Limit) ]
Malicious Filenames   --- (Path Strings)       --> [ VShieldSanitizer (Canonicalization) ]
                                                            |
                                                   [ Isolated Safe Disk Root ]
                                                            |
Completed Files       --- (Integrity Verified) --> [ Microsoft Defender / AMSI Scan ]
```

---

## 2. Threat Analysis & Mitigation Matrix

| Threat ID | Threat Vector & Scenario | Impact | V-SHIELD Mitigation Strategy | Verification Mechanism |
| :--- | :--- | :--- | :--- | :--- |
| **TH-01** | **Path Traversal Escape**: `.torrent` metadata specifies filenames like `../../../../Windows/System32/evil.dll`. | Arbitrary file overwrite / System compromise | `VShieldSanitizer` strips leading drive letters, slashes, and `..` tokens. Resolves canonical path and verifies it resides inside the designated download directory root. | Automated security test suite with 250 traversal payloads. |
| **TH-02** | **NTFS Alternate Data Streams (ADS)**: Filenames like `payload.exe:hidden.vbs` or `file.txt::$DATA`. | Evasion of extension filters / Execution masking | Strips any colon (`:`) character sequence from filenames, neutralizing alternate data stream attacks. | Unit tests verifying rejection/sanitization of ADS syntax. |
| **TH-03** | **Reparse Point / Symlink Hijacking**: Pre-created symbolic link or directory junction pointing outside download directory. | Overwrite of targeted host files | Win32 `FILE_FLAG_OPEN_REPARSE_POINT` flag checks whether path is a link; writing is rejected if destination leaves safe root. | Test fixture creating directory junction to `%TEMP%`. |
| **TH-04** | **Win32 Reserved Device Names**: Torrents containing files named `CON`, `PRN`, `AUX`, `NUL`, `COM1-9`, `LPT1-9`. | Win32 kernel/filesystem hangs or process crash | V-SHIELD automatically prepends `_` to any reserved device name (e.g. `_CON.txt`). | Test validating handling of all 22 reserved device names. |
| **TH-05** | **Bencode Recursive Bomb**: Malicious `.torrent` with 10,000 nested dictionaries to cause stack overflow. | Denial of Service (Process crash) | `BencodeGuard` enforces maximum recursion depth limit of 64 and max file size of 15 MiB. | libFuzzer target mutator and deeply nested fixtures. |
| **TH-06** | **Automatic Binary Execution**: Client automatically launching downloaded executables upon completion. | Zero-click malware execution | VELOCITY enforces strict **Zero Automatic Execution**. Manual execution displays high-priority warning modal. | End-to-end verification that completed files are never launched. |
| **TH-07** | **Malware in Torrent Content**: Downloaded file contains virus, ransomware, or trojan. | Host system infection | Direct Microsoft Defender CLI (`MpCmdRun.exe`) and AMSI integration scans completed files, automatically quarantining threats. | EICAR test string quarantine verification. |
| **TH-08** | **VPN Disconnect IP Leak**: VPN connection drops mid-download, causing packets to leak over physical Wi-Fi/Ethernet. | Loss of privacy / IP exposure | `NetworkLock` binds sockets strictly to the selected adapter GUID; instantly drops all sockets if adapter status drops. | Hardware interface disconnect simulation. |
| **TH-09** | **Plaintext Proxy Credentials**: Storing SOCKS5/HTTP proxy passwords in plain-text JSON config. | Credential theft by unprivileged local malware | Passwords encrypted via Windows Data Protection API (`CryptProtectData`) tied to current user logon session. | Inspection of persistent configuration file on disk. |

---

## 3. Security Limitations & Disclaimers

1. **Integrity vs Safety**: Cryptographic hash checks (SHA-1 / SHA-256) confirm that the received file is bit-for-bit identical to what the swarm uploader published. They do **not** guarantee that the file itself is safe or virus-free.
2. **Public BitTorrent Protocol Realities**: Participating in a public BitTorrent swarm inherently advertises your IP address to connected peers. True IP shielding requires a reputable VPN with VELOCITY's `NetworkLock` active.
3. **Firmware Hardware Safeguards**: Thermal Guardian monitors temperature and alerts users, but does not replace motherboard/CPU hardware thermal throttling.
