# VELOCITY — Known Issues & System Limitations

## 1. Operating System & Platform Constraints
1. **Windows 10 Long Path Limitation**: On Windows 10 machines where the `LongPathsEnabled` registry key is disabled, file paths exceeding 260 characters (`MAX_PATH`) may fail to open. VELOCITY uses the `\\?\` prefix for Win32 API calls where possible to mitigate this limitation.
2. **WMI Thermal Zone Desktop OEM Variations**: Some desktop motherboards do not expose standard ACPI thermal zones under `root\wmi` (common on custom desktop builds). In this scenario, Thermal Guardian detects that the sensor is unavailable and reports status gracefully without crashing or fabricating numbers.
3. **VPN Adapter Dynamic GUID Rotation**: Certain third-party VPN clients regenerate adapter GUIDs upon update or server reconnect. Users using Network Lock must verify the active adapter selection if their VPN updates.

## 2. BitTorrent Protocol Realities
1. **Swarm Seeder Upload Limits**: VELOCITY cannot download faster than the collective upload bandwidth offered by connected seeders. Low-speed torrents with 1–2 slow seeders are constrained by swarm supply, which V200 accurately reports as `SWARM_CAPACITY_CONSTRAINED`.
2. **uTP vs Aggressive TCP Traffic**: On home routers with aggressive TCP download streams running concurrently, uTP (LEDBAT) may yield bandwidth to preserve web browsing latency. Switching to V-FORCE MAX enables TCP preference for users wanting full priority.
