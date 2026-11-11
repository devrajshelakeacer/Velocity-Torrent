# Contributing to VELOCITY

Thank you for your interest in contributing to VELOCITY. We welcome contributions from developers worldwide to keep VELOCITY fast, secure, and genuinely free.

---

## Developer Certificate of Origin (DCO 1.1)
All commits must be signed-off using `git commit -s` to certify compliance with the Developer Certificate of Origin:

```
Developer Certificate of Origin
Version 1.1

By making a contribution to this project, I certify that:
(a) The contribution was created in whole or in part by me and I
    have the right to submit it under the open source license
    indicated in the file; or
(b) The contribution is based upon previous work that, to the best
    of my knowledge, is covered under an appropriate open source
    license...
```

---

## Coding Standards
1. **Language**: Modern C++20 (`/std:c++20` or `-std=c++20`). Use RAII, standard smart pointers, and `<concepts>`. Avoid manual `malloc`/`free` or raw pointer ownership.
2. **Formatting**: Adhere to `.clang-format` (LLVM base style with 4-space indentation and 100-character line limit).
3. **Threading**: Never block the Qt GUI thread. All disk, network, and hashing logic must execute on background worker threads.
4. **Security**: All paths originating from torrent metadata must be sanitized through `VShieldSanitizer`.
5. **Testing**: Any new logic or bugfix must be accompanied by relevant GoogleTest unit or integration tests.

---

## Pull Request Process
1. Fork the repository and create your feature branch from `main`.
2. Ensure all tests pass cleanly: `ctest --test-dir build --output-on-failure`.
3. Open a Pull Request with a clear description of the problem solved and test evidence.
