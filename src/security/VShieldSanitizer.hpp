// SPDX-License-Identifier: GPL-3.0-or-later
#pragma once

#include "core/Interfaces.hpp"
#include <unordered_set>
#include <regex>

namespace velocity::security {

class VShieldSanitizer : public ISecuritySanitizer {
public:
    VShieldSanitizer();
    ~VShieldSanitizer() override = default;

    SanitizedPathResult sanitizePath(const std::filesystem::path& downloadRoot, 
                                     const std::string& rawRelativePath) const override;
    bool isSafeFilename(const std::string& filename) const override;

    static bool isReservedDeviceName(const std::string& name);
    static std::string sanitizeComponent(const std::string& component);

private:
    std::unordered_set<std::string> m_reservedDeviceNames;
};

} // namespace velocity::security
