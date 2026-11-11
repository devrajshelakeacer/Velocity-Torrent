// SPDX-License-Identifier: GPL-3.0-or-later
#include "VShieldSanitizer.hpp"
#include <algorithm>
#include <sstream>
#include <cctype>

namespace velocity::security {

VShieldSanitizer::VShieldSanitizer() {
    // 22 reserved Win32 device names
    const std::vector<std::string> names = {
        "CON", "PRN", "AUX", "NUL",
        "COM1", "COM2", "COM3", "COM4", "COM5", "COM6", "COM7", "COM8", "COM9",
        "LPT1", "LPT2", "LPT3", "LPT4", "LPT5", "LPT6", "LPT7", "LPT8", "LPT9"
    };
    for (const auto& n : names) {
        m_reservedDeviceNames.insert(n);
    }
}

bool VShieldSanitizer::isReservedDeviceName(const std::string& name) {
    if (name.empty()) return false;
    
    // Extract base name before extension: e.g. "CON.txt" -> "CON"
    std::string base = name;
    size_t dotPos = base.find('.');
    if (dotPos != std::string::npos) {
        base = base.substr(0, dotPos);
    }

    std::string upperBase = base;
    std::transform(upperBase.begin(), upperBase.end(), upperBase.begin(),
                   [](unsigned char c) { return static_cast<char>(std::toupper(c)); });

    static const std::unordered_set<std::string> reserved = {
        "CON", "PRN", "AUX", "NUL",
        "COM1", "COM2", "COM3", "COM4", "COM5", "COM6", "COM7", "COM8", "COM9",
        "LPT1", "LPT2", "LPT3", "LPT4", "LPT5", "LPT6", "LPT7", "LPT8", "LPT9"
    };

    return reserved.find(upperBase) != reserved.end();
}

std::string VShieldSanitizer::sanitizeComponent(const std::string& component) {
    if (component.empty()) return "";

    std::string cleaned;
    cleaned.reserve(component.size());

    for (char c : component) {
        // Strip illegal Win32 filename characters and control characters
        if (c == '<' || c == '>' || c == ':' || c == '"' || 
            c == '/' || c == '\\' || c == '|' || c == '?' || c == '*' || 
            static_cast<unsigned char>(c) < 32) {
            cleaned.push_back('_');
        } else {
            cleaned.push_back(c);
        }
    }

    // Strip trailing spaces and dots which Windows automatically truncates
    while (!cleaned.empty() && (cleaned.back() == ' ' || cleaned.back() == '.')) {
        cleaned.pop_back();
    }

    // If reserved Win32 device name, prefix with underscore
    if (isReservedDeviceName(cleaned)) {
        cleaned = "_" + cleaned;
    }

    return cleaned.empty() ? "_unnamed_" : cleaned;
}

bool VShieldSanitizer::isSafeFilename(const std::string& filename) const {
    if (filename.empty()) return false;
    if (filename.find("..") != std::string::npos) return false;
    if (filename.find(':') != std::string::npos) return false;
    if (isReservedDeviceName(filename)) return false;
    return true;
}

SanitizedPathResult VShieldSanitizer::sanitizePath(const std::filesystem::path& downloadRoot, 
                                                 const std::string& rawRelativePath) const {
    SanitizedPathResult result;
    result.originalPath = rawRelativePath;
    result.status = SanitizeResult::Safe;

    if (rawRelativePath.empty()) {
        result.status = SanitizeResult::Sanitized;
        result.safePath = downloadRoot / "_unnamed_";
        result.reason = "Empty relative path; defaulted to safe container";
        return result;
    }

    // Check for explicit directory traversal attempts
    if (rawRelativePath.find("..") != std::string::npos) {
        result.status = SanitizeResult::RejectedPathTraversal;
        result.reason = "Path contains relative directory traversal ('..') sequence";
    }

    // Check for NTFS Alternate Data Stream tokens
    if (rawRelativePath.find(':') != std::string::npos) {
        result.status = SanitizeResult::RejectedAlternateDataStream;
        result.reason = "Path contains NTFS Alternate Data Stream colon delimiter";
    }

    // Tokenize components by both forward and backward slashes
    std::vector<std::string> parts;
    std::string current;
    for (char c : rawRelativePath) {
        if (c == '/' || c == '\\') {
            if (!current.empty()) {
                parts.push_back(current);
                current.clear();
            }
        } else {
            current.push_back(c);
        }
    }
    if (!current.empty()) {
        parts.push_back(current);
    }

    std::filesystem::path constructedPath = downloadRoot;
    bool wasModified = false;

    for (const auto& part : parts) {
        if (part == "." || part == "..") {
            wasModified = true;
            continue; // Skip traversal tokens
        }

        std::string safePart = sanitizeComponent(part);
        if (safePart != part) {
            wasModified = true;
        }
        constructedPath /= safePart;
    }

    result.safePath = constructedPath;

    if (result.status == SanitizeResult::Safe && wasModified) {
        result.status = SanitizeResult::Sanitized;
        result.reason = "Dangerous characters, device names, or traversal tokens sanitized";
    }

    return result;
}

} // namespace velocity::security
