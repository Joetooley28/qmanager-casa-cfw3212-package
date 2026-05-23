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
- The Reconnect Network menu action now uses Casa's connection manager path instead of forcing a modem deregister/re-register.
- A handful of upstream modem-management actions stay blocked or limited on Casa because they'd let you push the modem into a state we don't want it in.

## v0.1.11-cfw3212.4

- Reconnect Network now asks Casa's own connection manager to refresh the cellular session instead of forcing the modem through a hard deregister/re-register cycle. This should make that menu action much gentler on the router.

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

## v0.1.10 Casa Updates

- Kept two v0.1.10 package releases available: `v0.1.10-cfw3212.16` as the router-verified checkpoint, and `v0.1.10-cfw3212.25` as the final v0.1.10 Casa package.
- Manual SIM Profile save, apply, delete, and deactivate works on Casa, including APN, TTL/HL, IMEI, and the modem reboot apply step. Blind auto-apply by ICCID stays off by default.
- Casa/RG520N ICCID handling was cleaned up so SIM Profiles do not show false SIM mismatch warnings from a missing trailing padding nibble.
- Dashboard freshness checks tolerate Casa boxes with a wrong wall clock as long as the router status timestamp keeps advancing.
- Web Console, Software Update Casa notes, Email Alerts `msmtp` install/remove, Discord Bot backend install, Tailscale, and Ookla Speedtest support were added or tightened during the v0.1.10 Casa series.
- Installs and GUI updates were made gentler on router flash: fewer unnecessary file writes, no duplicate full tarball extraction during online install/update, and GUI updates end in a reboot-required state instead of rebooting automatically.
- Casa package safety limits stayed in place around USB composition, upstream IP Passthrough modem writes, and blind SIM Profile auto-apply.

## Earlier Highlights

- Casa package releases go out through the two-repo builder/package flow, with protected prerelease publishing and a router-verified mark on releases.
- Cut down on router flash churn: skip frontend payloads that haven't changed, compare before copying, pace fresh installs, and don't extract the tarball twice during online installs/updates.
- GUI updates now end in a reboot-required state instead of rebooting on their own. You decide when the reboot happens.
- QManager install paths are mapped to Casa's writable storage at `/usrdata` and `/etc/systemd/system`, with lighttpd on HTTP `9080` and HTTPS `9000`.
- Kept the Casa safety lines drawn around USB composition, upstream IP Passthrough modem writes, and blind SIM profile auto-apply.
