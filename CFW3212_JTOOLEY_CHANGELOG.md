# Casa CFW-3212 Joetooley Changelog

## What's Working

- Web Console works. On installs with internet, `ttyd` gets pulled in and started automatically, and `/console/` is live once that helper is in place.
- System Health Check has been pointed at the Casa paths, services, lighttpd ports, and the `/usrdata/opt/bin` helper locations it actually needs to look at.
- Tailscale runs from the QManager UI. You do your own Tailscale login from the UI.
- Ookla Speedtest works once the `speedtest` helper is installed. install handles if connected to internet.
- Email Alerts can install and remove `msmtp` through the Casa Entware package flow. The Gmail app-password setup and an actual test send are the last things to confirm working on your end. (wired up, not tested yet) 
- Discord Bot backend is now part of the Casa package, so you can plug in your own Discord bot token and user ID and try the UI. (wired up, not tested yet)
- SIM Profiles can be saved, applied, deleted, and deactivated by hand on Casa. That includes APN, TTL/HL, IMEI, and the modem reboot apply step. The blind "auto-apply by ICCID" behavior is still off by default.
- Custom DNS works from the QManager UI, including custom upstream resolvers for LAN clients without changing DHCP leases or rebooting the router.
- A handful of upstream modem-management actions stay blocked or limited on Casa because they'd let you push the modem into a state we don't want it in.

## v0.1.11-cfw3212.3

- Custom DNS availability detection is now more reliable on Casa CFW-3212, so the page correctly unlocks when the router's DNS proxy is available.
- Saving Custom DNS settings is now more reliable on Casa CFW-3212 and no longer fails with a staging-file error on affected installs.
- The IP Passthrough disable cleanup is now applied to the installer-written Casa CGI too, so turning IP Passthrough off clears both the profile flag and the persistent service handover state.

## v0.1.11-cfw3212.2

- Custom DNS (Local Network → Custom DNS) works on Casa CFW-3212 now. You can set custom upstream DNS resolvers for LAN clients from the QManager UI without changing DHCP leases or rebooting the router.
- IP Passthrough bypass detection is hooked up to the right place on Casa (`link.profile.1.ip_handover.*` RDB keys). The Custom DNS page can now correctly tell you when a device in IP Passthrough mode is getting carrier DNS straight from the modem and skipping the resolver settings.
- attempted another fixed the long-running "device info missing after boot" problem (blank IMEI, IMSI, ICCID, manufacturer, model, firmware in the dashboard). The poller's boot-identity AT check was stripping newlines and then trying to match `^OK$`, which can never match a multi-line modem response. It now strips carriage returns instead, so the anchored matches work and the dashboard fills in on the first try.
- Turning off IP Passthrough now also clears `service.ip_handover.enable` and the cached last WAN IP. Before this fix, those flags stayed set across reboots and the modem kept its data session bound to the Casa handover placeholder (`192.0.0.1`), which left the router with no real WAN until a manual reconnect.

## v0.1.11-cfw3212.1

- First Casa CFW-3212 build of upstream QManager v0.1.11.

## v0.1.10-cfw3212.26

- Casa/RG520N ICCID values now get a trailing `F` padding nibble added when needed, so SIM Profiles stop showing a fake SIM mismatch right after apply.
- The same ICCID matching cleanup is applied in both the backend profile manager and the router status UI, so they agree on what the SIM is.
- The dashboard's "is this data fresh?" check tolerates Casa boxes with a wrong wall clock. As long as the router status timestamp is still moving forward, we treat the data as fresh.

## v0.1.10-cfw3212.25

- Manual SIM Profile save/apply/delete/deactivate is turned on for Casa now that we've walked the profile apply path against the Casa modem safety rules.
- A manual SIM Profile apply can set APN, the QManager TTL/HL firewall state, and IMEI, followed by `AT+CFUN=1,1`.
- The blind "auto-apply by ICCID" behavior stays off by default on boot, SIM switch, and watchdog paths. Builder maintainers who want the upstream auto-apply behavior back can flip `CASA_PROFILE_AUTO_APPLY=1`.
- Upstream USB composition / IP Passthrough modem-write paths stay blocked: ECM, MBIM, RNDIS, `AT+QCFG="usbnet"`, and the upstream QMAP MPDN/IPPT controls.

## v0.1.10-cfw3212.24

- Tightened up the public changelog's optional-feature section: Web Console now auto-installs `ttyd` on internet-connected installs, and Tailscale and Ookla Speedtest are expected to work once they're installed/configured.
- Said clearly that Email Alerts can install and remove `msmtp` through the Casa Entware flow, and that the Gmail app-password setup plus an actual send are still on the user to verify.
- Software Update's upstream changelog toggle is now labeled `Rus | Ame / Dr. D`.
- Cleaned up the generated GitHub release credit line so it mentions Joetooley's Casa converter/package flow and the small UI compatibility changes, while leaving upstream QManager credit with Rus | Ame / Dr. D.
- The Casa package now installs the built `qmanager_discord` helper so the Discord Bot UI can enable and start the backend for anyone who wants to try Discord DM alerts.

## v0.1.10-cfw3212.23

- The optional Web Console backend (`ttyd`) gets installed and started during internet-connected Casa installs, so `/console/` works without a separate manual helper step.
- If the `ttyd` download fails, the rest of QManager still installs cleanly. You just don't get the Web Console page until `ttyd` can be pulled.
- The `--purge` uninstall cleans up more thoroughly: QManager-installed optional tools like Tailscale state/symlinks/services and the Ookla CLI config get removed with the rest of the package.
- During GUI updates, after the service restart drops the poll, the browser goes back to the main QManager screen instead of trying to reload the stale Software Update route.
- Email Alerts `msmtp` install/uninstall on Casa uses the direct Entware IPK extraction flow instead of relying on a missing `opkg` command, and the misleading manual `opkg` command is gone from the UI.
- Renamed the Software Update upstream changelog toggle from `Dr. D` to `Rus | Ame / Dr. D`. The upstream release notes it shows are unchanged.

## v0.1.10-cfw3212.22

- Added a small Software Update changelog toggle so the router UI can show Casa-specific Joetooley notes separately from the upstream QManager notes.
- The install now creates `/opt -> /usrdata/opt` so Entware setuid tools like `sudo` find their native loader and library paths.
- The QManager health-check worker was reworked for Casa paths, the remapped lighttpd ports, Casa service names, and the `/usrdata/opt/bin` CGI paths.
- v21 follow-up: install now only normalizes CRLF on shebang text files, leaving Rust ELF binaries alone. This stops `qmanager_ping` from getting corrupted on install.
- v21: the Casa-tested Rust `qmanager_ping` binary is now vendored, and CI verifies the packaged binary's SHA before publishing.
- v20/v21: `qmanager-ping` stays on with a bounded Rust-first wrapper and a shell fallback, and the boot path retries modem identity reads.

## Earlier Highlights

- Casa package releases go out through the two-repo builder/package flow, with protected prerelease publishing and a router-verified mark on releases.
- Cut down on router flash churn: skip frontend payloads that haven't changed, compare before copying, pace fresh installs, and don't extract the tarball twice during online installs/updates.
- GUI updates now end in a reboot-required state instead of rebooting on their own. You decide when the reboot happens.
- QManager install paths are mapped to Casa's writable storage at `/usrdata` and `/etc/systemd/system`, with lighttpd on HTTP `9080` and HTTPS `9000`.
- Kept the Casa safety lines drawn around USB composition, upstream IP Passthrough modem writes, and blind SIM profile auto-apply.
