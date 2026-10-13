# Casa CFW-3212 Joetooley Changelog

## What's Working

- Web Console works. On installs with internet, `ttyd` gets pulled in and started automatically, and `/console/` is live once that helper is in place.
- System Health Check has been pointed at the Casa paths, services, lighttpd ports, and the `/usrdata/opt/bin` helper locations it actually needs to look at.
- QManager now installs on a clean, stock router with no internet and no pivot/overlay filesystem prep. The installer bundles everything it needs (the web server, `sudo`, and their support libraries) inside the package, and the stock install path runs entirely from `/usrdata`.
- Tailscale runs from the QManager UI using the lighter Tiny Tailscale build. You do your own Tailscale login from the UI. It stays optional: QManager updates never install or change it, and the Tailscale page has **Check for updates** and **Update Tiny Tailscale** buttons.
- Ookla Speedtest works. The installer adds the `speedtest` helper when the router has internet.
- Email Alerts can install and remove `msmtp` through the Casa Entware package flow. The Gmail app-password setup and an actual test send are the last things to confirm working on your end. (wired up, not tested yet) 
- Discord Bot backend is now part of the Casa package, so you can plug in your own Discord bot token and user ID and try the UI. (wired up, not tested yet)
- Tower Locking and Frequency Locking (Cellular menu) come from upstream QManager and are wired up on Casa, but locking has not been tested on the CFW-3212 yet. The Tower Lock schedule's timers arm and disarm correctly. (wired up, locking not tested yet)
- SIM Profiles can be saved, applied, deleted, and deactivated by hand on Casa. That includes APN, TTL/HL, IMEI, and the modem reboot apply step. ICCID-matched auto-apply is available as an explicit on/off setting in the SIM Profiles page and stays off until you turn it on.
- Custom DNS works from the QManager UI, including custom upstream resolvers for LAN clients without changing DHCP leases or rebooting the router.
- DNS for the router and the devices behind it is kept working automatically: whenever the router's own DNS is broken (which happens after reconnects, especially with IP Passthrough), QManager points it at the carrier DNS servers that answer, or at public DNS if none do, within a few seconds. IP Passthrough is off by default (you can turn it back on); the dashboard shows whether it is on and where the router/LAN DNS is currently coming from.
- The Watchdog works on Casa: when the connection stops answering it reconnects through the router's connection manager, waits 120 seconds, and only reboots the router if that did not help (tested on a CFW-3212 with a simulated outage).
- The Reconnect Network menu action now uses Casa's connection manager path instead of forcing a modem deregister/re-register.
- Reconnect Network now keeps a small progress window open so you can watch elapsed time, network registration, WAN IP, and internet status while the router comes back online.
- Cellular → Radio Information shows every active band's details at once, so you can compare signal across carriers.
- Software Update → Version Management can install a different version (including rollbacks). After the download verifies, the button switches to **Install now**, the install finishes without signing you out, and the page shows **Reboot required** with a **Reboot now** button.
- Software Update from the last public build (`v0.1.12-cfw3212.21`) to this version was tested on both CFW-3212 firmware lines (`1.1.x` and `1.2.24.0`), keeping your password and settings. Uninstalling and reinstalling QManager were tested too.
- Video Optimizer in **Narrow** mode was field-tested on a ~600 Mbps connection: 4K YouTube through the optimizer while ordinary downloads kept their speed. See this version's notes for the limits.
- Scheduled Reboot saves, arms and disarms its timer from System Settings, and the installer re-arms saved schedules after an update.
- Carrier remote management (TR-069 / LwM2M) is turned off and blocked by default, so a carrier push cannot wipe QManager.
- A handful of upstream modem-management actions stay blocked or limited on Casa because they'd let you push the modem into a state we don't want it in.

## v0.1.16-cfw3212.1

- **Video Optimizer is available on Casa — Off by default; use Narrow.** It is hard on the CFW-3212's CPU: every optimized connection is relayed by the router's processor instead of its hardware fast path. If you want it on full-time or for several devices, you may get better results running a video optimizer on a more powerful router connected behind the CFW-3212 and leaving this one Off. In Local Network → Traffic Engine, pick Video Optimizer and use the **Narrow | Broad** switch on that row: **Narrow** sends only the video sites on your Optimizer targets list through the optimizer, so speed tests and ordinary downloads stay on the router's fast hardware path; **Broad** works like upstream QManager and sends all web traffic through it. Full Bypass is unchanged. Narrow learns video addresses from the router's DNS (IPv4 and IPv6), so devices using Secure DNS / DNS over HTTPS, Private DNS or a VPN are not detected; reopen the video app after changing settings. If the router's DNS gets slow, Narrow steps aside for a minute instead of breaking browsing. Enter bare domains in the targets list (for example `googlevideo.com`, `nflxvideo.net`), not web addresses. Optimized traffic is handled by the router's CPU: in testing, throttled video went from about 7 Mbps to about 60 Mbps with the CPU close to its limit, and CPU use and temperature rise while it runs. Field test on a ~600 Mbps connection: with **Narrow** on and 4K YouTube playing, ordinary downloads kept their speed (Ookla about 600 Mbps, Cloudflare HTTPS about 490 Mbps); one 4K stream used about 11 Mbps and 55–65% CPU, two 4K streams plus a speed test played smoothly, and four 4K streams pinned the CPU and took turns buffering, so plan on about three 4K streams at most. **Broad and Full Bypass are not recommended on the CFW-3212**: they send all web traffic through the CPU, and ordinary HTTPS downloads dropped to about 25–50 Mbps with the CPU near 100%. If you need Broad, run a video optimizer on a router behind the CFW-3212 instead. Speed tests such as Ookla (app, browser or Bing) use port 8080 and never go through the optimizer, so they look the same in every mode; fast.com shows the video speed and speed.cloudflare.com shows ordinary HTTPS. Choose Off to remove all optimizer rules.
- Updating QManager while the Video Optimizer is on now restarts it on the new version.
- The Narrow vs Broad card in Traffic Engine marks Narrow as recommended, shows the measured speeds for each scope, and notes that port-8080 speed tests don't show the optimizer's effect.
- **Carrier remote management is now blocked by default.** US Cellular no longer runs these routers, and a carrier TR-069 / LwM2M push (settings or firmware) would wipe QManager, so QManager now turns both off and blocks their ports for the router's own traffic. Your devices on the LAN are not affected. Uninstalling QManager removes the port blocks.
- **Band Locking now tells you when a network setting is the reason a lock won't apply.** If Settings → Network Mode has 5G Architecture set to NSA only (or SA only), or Preferred Network Type set to LTE only (or 5G only), the affected band card says so, links to that setting, and pauses its lock buttons. It no longer shows a misleading count such as "1 of 18 locked", and the "No 5G carrier" tile names the setting when it is the cause.
- The Joetooley / Rus | Ame / Dr. D switch on the Software Update release notes now clearly shows which notes you are reading.
- **Router lookups no longer stall for 10 seconds when the carrier hands out a dead DNS server first.** Some connections list DNS servers that never answer ahead of working ones; every lookup the router made itself (Software Update, speed test, Tailscale) waited for them to time out. QManager now notices when the first server does not answer and lists only the ones that do, then hands the list back when the carrier's servers work again.
- The Software Update page loads faster: its release list is now actually cached between visits instead of being fetched from GitHub on every load.
- Installing a version from Software Update → Version Management no longer jumps to a "Shutting down" countdown and signs you out while the router keeps running. Like a normal update, it now waits for the install to finish and shows **Reboot required** with a Reboot now button.
- The Software Update page no longer needs a manual refresh after an install. It used to reload itself 30 seconds into the install, which could land while QManager's web server was still restarting and leave a "can't connect" or idle page; it now keeps checking until the install finishes and shows **Reboot required** on its own. Opening or refreshing the page during an install picks the progress back up.
- Reboot history now labels a reboot from Software Update's **Reboot now** button as a user reboot, like the System menu Reboot. Before, that reboot was not logged, so the next boot could be labelled from an older entry (for example "scheduled" when Scheduled Reboot was off), especially when the router started with its default clock. Each logged reboot now labels only one boot; a reboot that logged nothing shows as unplanned.
- The Support page has **Report a Casa CFW-3212 problem** and **Casa CFW-3212 release notes** at the top of Get help, linking to this port's GitHub issues and releases. QManager's own links are now labelled as QManager's, so problems with installing, updating or anything Casa-specific come here instead of to the QManager author.
- The Donate dialog and the Support page have a separate row of **PayPal, Venmo and Cash App** buttons for supporting the CFW-3212 port (Joetooley), labelled as the port only. QManager itself is written by Rus, and his Wise, PayPal and GitHub Sponsors buttons are unchanged.
- The Home dashboard shows a photo of the CFW-3212's RG520N board instead of the generic device drawing (and the package is about 450 KB smaller).
- Uninstalling QManager now switches the Video Optimizer off first and removes its rules (including the Force-TCP QUIC block), so web and video traffic are not left redirected or blocked until the next reboot.
- The one-line uninstall command works again; it was downloading a package name that no longer exists on the release page.

- **Important: installing or updating QManager no longer risks crashing the router.** The CFW-3212 has very little free memory (often only 20-30 MB, less with Tailscale running), and QManager used to download and unpack its whole package (about 30 MB) into memory during an install or Software Update. That could run the router out of memory and reboot it in the middle of an update. The package is now downloaded and unpacked on the router's storage (`/usrdata`) instead, and deleted as soon as the install finishes, whether it succeeded or failed; anything left behind by an interrupted install is removed at the next boot. The installer checks there is enough free storage first (about 40 MB) and stops with a clear message if there is not. The offline install and uninstall commands now unpack only the one script they run.
- **Important: IP Passthrough is now turned off by default.** The CFW-3212 ships with IP Passthrough on. Depending on the mobile connection, passthrough either hands the device on the LAN port a real carrier IP address, or falls back to a placeholder address (192.0.0.2) and routes it through the router anyway. After the connection is re-established (switching between LTE and 5G, a brief loss of signal, turning passthrough on) it can get stuck in that placeholder mode, where small requests still work but many real connections silently fail - web pages and speed tests hang even though the router shows it is connected. In testing, over a third of new connections failed that way, and none with passthrough off. Installing this version turns IP Passthrough off once (your connection on the LAN port drops for a moment while it switches, and the device then gets a normal address from the router). If you need passthrough, turn it back on in Network > IP Passthrough; QManager will not change it again.
- Installing or updating QManager could randomly fail with `can't create /usrdata/bin/jq: Text file busy` if QManager happened to be using that tool at that moment. Files are now written to a new copy and swapped into place, so running tools and services are never overwritten mid-use.
- Moves the Casa build onto upstream QManager **v0.1.16** (upstream v0.1.13–v0.1.16 include a full UI redesign, translations, SMS forwarding, known-SIM tracking, alert routing, connection-scenario schedules and more). All existing Casa changes were carried over to the new UI.
- Software Update on the redesigned page keeps the Casa flow: installing restarts QManager services and then shows a **Reboot required** banner with a **Reboot now** button, and release notes still switch between Joetooley and upstream notes. Updates still come only from the Casa package repo.
- **Scheduled Reboot** now uses upstream's systemd timers instead of BusyBox `crond`, and still reboots through the Casa managed reboot path so the reason is recorded.
- The Watchdog's SIM failover tier stays disabled on the new Watchdog page because CFW-3212 has one SIM slot.
- The Watchdog's **Restart the radio** step is disabled on CFW-3212. The router's own connection manager controls the radio, so recovery goes from a reconnect through that manager straight to a managed reboot. The **Re-register** step is now labelled for what it does on this router: a reconnect through the connection manager.
- The Watchdog now waits 120 seconds (was 60) after a reconnect before deciding whether it worked. The CFW-3212's connection manager takes about 40 seconds to start a reconnect, so with 60 seconds the Watchdog could give up on a reconnect that was still in progress and move on to rebooting the router. Routers still on the old default of 60 are moved to 120 once when you install this update; a different value you chose is kept, and you can still change it on the Watchdog page.
- The optimizer tool (zapret `tpws`) is installed from the fixed, verified version v72.13 instead of whatever is newest, and now runs with the right permissions to read your targets list. An untouched old default targets list (which included speed-test sites) is replaced with the Casa video defaults; edited lists are kept.
- Uses upstream's new connectivity monitor (ping daemon) instead of the older Casa build, so Cellular Information can show whether traffic is flowing over IPv4 or IPv6. Existing ping settings are migrated to the new four-target format automatically.
- The IP Passthrough status now shows real values on Casa: the device passthrough is locked to, whether it sits behind an extra NAT (placeholder mode) or holds the carrier IP directly, and that the router answers its DNS.
- APN changes from SIM Profiles and the APN page now go through the CFW-3212's own connection manager instead of writing to the modem and forcing a raw detach/re-attach. Deactivating a profile restores the APN the router had before, instead of blanking it. Credentials saved on the APN page are kept in the router's profile so they are not lost on reconnect. (not tested yet with a real APN change)
- Reboots triggered by IMEI changes, MBN selection and the backup-IMEI check now use the router's managed reboot, like the Reboot button.
- Cellular Settings no longer offers a SIM Slot switch, since CFW-3212 has one SIM slot (switching to the empty slot would drop the connection).
- Connection details now show the correct carrier DNS servers. The CFW-3212 modem reports IPv4 and IPv6 details in a different layout, which made the page show the gateway as Primary DNS and a run-together string as Secondary DNS.
- Language packs download from the upstream QManager releases.
- Software Update now lists only the three newest Casa versions, and the release notes on the router show just the notes for that release.
- LAN DNS fallback is steadier: the router only switches LAN DNS to public DNS when carrier DNS keeps failing (two checks in a row) while public DNS still answers, which is the case the fallback exists for. During an outage, reboot or reconnect it no longer switches back and forth (each switch restarted dnsmasq), and it returns to carrier DNS as soon as that answers again. QManager no longer saves a `dnsmasq.conf` copy on every automatic DNS switch, and installing this update removes the copies older builds left behind (some routers had hundreds, eating into the small config storage). Saving Custom DNS now applies the right fallback immediately.
- Fixes name lookups failing on IP Passthrough setups (for example the CFW-3212 plugged into your own router), usually right after a reboot: websites would not load by name even though the connection was up. With passthrough on, the router's DNS can be left pointing only at the passthrough placeholder `192.0.0.1`, which refuses every query, and QManager did not notice because the carrier's other DNS servers (often the IPv6 ones) still answered. QManager now checks the DNS that devices and the router actually use. When it is broken it points it at the carrier DNS servers that do answer, or at public DNS (1.1.1.1 / 8.8.8.8) if none do, and hands it back to the router as soon as the router's own DNS works again. The router resets its DNS every time the mobile connection is re-established (switching between LTE and 5G, a brief loss of signal, a reboot), so QManager now watches for that and repairs DNS within a few seconds instead of up to a minute, before the devices behind it notice. This only changes a file in memory: no settings are saved to flash and the DNS service is not restarted. The router's own downloads (Software Update, Tailscale, Email Alerts setup) use the repaired DNS too. Uninstalling QManager now removes this automatic DNS repair even without `--purge` and puts back the router's own DNS list, including its IPv6 DNS servers.
- After a reboot or reconnect with IP Passthrough off, QManager now gives the router's own DNS up to 45 seconds to start answering before it steps in. On a cold boot the router sets up its DNS a few seconds after the connection comes up, and QManager used to take over DNS for about 40 seconds in that gap for no reason (checks made while the connection was still down were counted as DNS failures). With IP Passthrough on, broken DNS is still repaired right away.
- New upstream helper scripts are pointed at Casa's `/usrdata` locations, including the Entware tools they need.
- **Install msmtp** on the Alerts page (Email channel) works on Casa again. It downloads msmtp from Entware without `opkg`, which CFW-3212 does not have, keeps the router's own system libraries in place, and sets up msmtp so email alerts can actually send. The health check reports the msmtp version correctly.
- Turning the **Watchdog** off no longer hangs for about 10 seconds or leaves its service marked as failed. The watchdog process ignored the stop request, so the system had to wait and then force-kill it (an upstream QManager bug, fixed here). The Watchdog page also shows it as disabled right away instead of still "monitoring".
- The **System Health Check** DNS test now works whatever LAN address your router uses (it only recognised 192.168.x.x addresses before).
- The **Time zone** setting in System Settings now actually changes the router clock. CFW-3212 only has its own short list of zones, so QManager picks the matching one (for example America/New_York uses US/Eastern) and applies it through the router's own time zone setting, which survives reboots. Scheduled Reboot, logs and alert times then use local time instead of UTC.
- Updating QManager now keeps **Scheduled Reboot** and the Tower Lock schedule armed. They are re-created from your saved settings on every install, including schedules saved on older builds, which showed as Armed but never ran after the upgrade.
- Uninstall now stops every QManager service it removes, including ones added in newer versions (SMS forwarding, SMS storage, schedules), so nothing keeps running until the next reboot, and also removes the `qcmd_test` helper it used to leave in `/usrdata/bin`.
- Background services such as **SMS forwarding**, tower failover, the Tower Lock schedule and the backup-IMEI check can now find the tools they need on CFW-3212. Before, they could quietly treat their saved settings as off or empty.
- The **port firewall** that limits the QManager web UI (ports 9000/9080) to the LAN, Ethernet and Tailscale interfaces starts again. Earlier v0.1.16 test builds gave QManager services a tool path that left out `/usr/sbin`, where CFW-3212 keeps `iptables`, so the firewall service failed at boot and the web UI ports were left unfiltered.
- **Tailscale** now installs Tiny Tailscale 1.102.4, built with Tailscale's DNS support kept. The earlier 1.98.3 tiny build left DNS out, so it crashed and restarted every few seconds as soon as anything asked it a MagicDNS question. Tailscale is still optional and separate from QManager: updating QManager never installs or changes it. The Tailscale page now has a **Check for updates** button that looks up the newest Tiny Tailscale release, and an **Update Tiny Tailscale** button that updates it in place, keeping your login, device name and tailnet address (Tailscale restarts for about 15 seconds, and the old version is put back if the new one does not start). If your router still has an older build than the one this QManager version installs (such as 1.98.3), the page offers the update without you having to check. Every Tiny Tailscale download is checked against the SHA-256 checksum GitHub publishes for it, and a download that does not match is refused.
- **Connect** on the Tailscale page no longer reports a timeout when the router is already logged in. Newer Tailscale versions reconnect quietly without printing anything, which QManager used to wait 15 seconds for and then show as a failure even though the connection worked. A real connect failure now shows Tailscale's own error message.
- Uninstalling QManager (without `--purge`) leaves Tailscale installed and running, so the router stays reachable on your tailnet, but there is no QManager page left to manage it. To remove Tailscale too, use **Uninstall** in the **Remove Tailscale** card at the bottom of the Tailscale page first, or uninstall with `--purge`.
- The Tailscale page's **Or install from a shell** command is now `/usrdata/bin/qmanager_tailscale_mgr install`, which works in an SSH session on the CFW-3212. It used to show `sudo qmanager_tailscale_mgr install` with an explanation sentence in front, which failed with "sudo: not found", and the copy button copied the sentence too.
- The Tailscale install log no longer shows a harmless `ln: /usr/bin/tailscale: Read-only file system` error. The `tailscale` command link is created under `/usrdata` only, since `/usr/bin` is read-only on the CFW-3212.

## v0.1.12-cfw3212.22 (not released on its own; these changes ship in v0.1.16-cfw3212.1)

- QManager's web server (`qmanager-lighttpd`) now writes errors to a RAM-only log at `/tmp/qmanager-lighttpd-error.log` instead of leaving logging unset. HTTP access logging stays off on Casa so routine UI traffic does not churn flash. The `qmanager-lighttpd` service also sends stdout/stderr to the system journal for same-session diagnostics. These logs are cleared on reboot — they are for troubleshooting while the router is running, not for post-reboot forensics.
- Tightens the sudo rules for the web UI: instead of allowing any `iptables` / `ip6tables` command, the UI may only run two small helper programs (`qmanager_iptables` and `qmanager_ip6tables`) that apply or read TTL/HL mangle rules on the cellular interface. The port firewall (`qmanager-firewall`) still runs as root via systemd and is unchanged. This closes a broad privilege hole without affecting normal TTL settings or the web UI firewall.
- Tightens Tailscale sudo access from the web UI. The UI no longer gets blanket permission to run the Tailscale binary as root; it now goes through a small helper that only allows the Tailscale actions QManager uses, such as status, connect, disconnect, logout, and the Tailscale SSH toggle.
- The Terminals sidebar dropdown now explicitly shows both **AT Terminal** and **Web Console**. Previously AT Terminal was hidden behind the parent "Terminals" row, which made it look like the AT Terminal page had disappeared.
- Fixes **System Settings → Scheduled Reboot** on Casa. Saving the reboot schedule now makes sure the cron spool exists before writing the root cron entry, fails with a real error instead of silently pretending success if the cron file cannot be written, and ensures BusyBox `crond` is running so the scheduled reboot job can actually fire.
- Scheduled Reboot times now follow the **System Settings timezone** (the same timezone selector on that page). BusyBox `crond` is started and reloaded with QManager's configured `TZ` after each schedule save, so a reboot set for `10:33` fires at 10:33 local time instead of being interpreted as UTC.
- Scheduled Reboot now actually fires at the set time. Earlier builds wrote a correct schedule, but BusyBox `crond` quietly refused to run it because the cron file was owned by the web-server user instead of `root`. The schedule is now stored on persistent `/usrdata` storage and kept `root`-owned (migrated automatically from the old location on upgrade), so the scheduled reboot runs reliably and survives reboots.
- A scheduled reboot now uses the same managed reboot path as the System menu **Reboot** button, so it is recorded with a proper reboot reason instead of showing up as a generic warm restart.
- The Watchdog status is clearer when its ping monitor is unavailable. If the ping cache is missing, stale, or invalid, Watchdog now reports that degraded ping state instead of looking like normal monitoring, restarts the QManager ping service a limited number of times, and still avoids modem recovery actions unless real connectivity loss is confirmed. Disabling Watchdog now also leaves the status file showing disabled instead of the last old monitor state.
- The SIM Profiles page now has an **ICCID auto-apply** switch. When enabled, a saved profile whose ICCID matches the current SIM can be applied automatically at boot and after user SIM-switch actions. The setting is stored on the router and remains off by default.
- Watchdog backup-SIM recovery is disabled on Casa CFW-3212 because this hardware has only one SIM slot. The Watchdog service ignores Tier 3 even if stale config says it is enabled, clears stale SIM-failover state, and the Watchdog settings UI no longer offers a backup-SIM switch.
- SSH password changes (onboarding and System Settings) now use **SHA512-crypt** (`openssl passwd -6`) instead of the older MD5-crypt hash.

## v0.1.12-cfw3212.21

- Band Locking now sticks across a reboot. On this hardware, saving a band selection (including "Select all") applied right away, but after a reboot any bands the carrier profile keeps hidden came back unselected — so your saved choice didn't fully survive the reboot. Saving bands in QManager (or completing the first-run setup's band step) now makes your selection the one the modem keeps after rebooting, instead of the carrier's hidden-band policy re-applying on the next boot. QManager owns the band set on this device once you save; the modem's hardware still decides which bands are actually available, and Band Failover still protects you if a locked band loses service.
- Cellular → Radio Information now lets you keep multiple Active Cellular Bands expanded at the same time, so you can compare signal details across carriers without one row closing another.
- After a Software Update install, if the browser session drops while QManager's web server restarts, the page now reloads the **Software Update** page instead of jumping to the dashboard/home page, so you land back on the install status (and any "reboot required" prompt) where you started.
- Fixes the Custom DNS page wrongly warning that "IP Passthrough is bypassing dnsmasq." On Casa, IP Passthrough is a routed handover — the downstream device still gets the modem as its DNS server and routes lookups through the modem's dnsmasq — so Custom DNS *does* apply to passthrough clients. The page no longer shows the misleading bypass notice.
- Fixes IP Passthrough not actually engaging after it had been turned off and on again. The toggle now keeps Casa's service-level handover flag (`service.ip_handover.enable`, which the stock QCMAP engine reads) in sync — enabling sets it on so the carrier IP is handed to your downstream device, instead of only flipping the per-profile flag and leaving passthrough silently inactive (dashboard showing "IPPT On" while the device still got a normal LAN IP).
- The `--purge` uninstall now also removes QManager's DNS changes from the router's persistent dnsmasq config (`/etc/data/dnsmasq.conf`) — both the Custom DNS upstreams and the automatic public-DNS fallback block (`1.1.1.1` / `8.8.8.8`) the IP Passthrough reconciler adds when carrier DNS is down — and restarts dnsmasq so the router/LAN resolver reverts to stock/carrier DNS. A plain uninstall still leaves these in place (alongside other preserved config) for reinstall.
- Fixes the first-run setup wizard not applying its **default** network/band choices. Choosing **Automatic** on the "Preferred network" step now actually sets the modem to automatic RAT (LTE + 5G, SA and NSA) instead of skipping the step, and choosing **All bands (default)** on the band step now clears any existing band lock instead of leaving it in place. Previously these defaults were treated as "do nothing," so if the modem still carried a network-mode or band lock from earlier use, the wizard's "Automatic"/"All bands" left that old setting active. Picking a non-default option already worked; this only changes the default choices.
- The installer no longer tries to create a root-level `/opt → /usrdata/opt` symlink. Entware and QManager already run from explicit `/usrdata/opt` paths (bundled `sudo` is pre-patched at build time), so the install no longer remounts `/` read-write just to add a legacy shortcut.
- Fixes the background poller's boot-time modem identity reads on Casa. The converter now emits the correct shell escaping for those AT-response checks, so About Device and dashboard identity fields populate reliably after boot instead of intermittently failing the parse step.

Uninstall/`--purge` cleanup, on top of the above — closes the remaining "restore to stock" gaps so a `--purge` uninstall leaves the router the way it shipped:

- The uninstaller now tears down QManager's firewall rules immediately and synchronously, instead of asking the firewall service to stop in the background and then deleting its helper script. Previously the firewall rules (the QManager web-UI port protections) could stay active until the next reboot.
- The IP Passthrough DNS reconciler's scheduled timer is now fully removed on uninstall. Before, only its service file was cleaned up, so a stale timer entry was left behind.
- `--purge` now also removes the dnsmasq backup snapshots QManager's DNS helpers had saved next to the router's persistent dnsmasq config, and the purge step itself no longer writes a new backup file there (its safety copy goes to RAM instead, sparing flash).
- `--purge` now removes the Entware startup unit (`rc.unslung.service`) along with the Entware tree it pointed at, instead of leaving a broken service entry behind.
- Uninstall now clears all of the Software Update check's temporary cache files in `/tmp`, not just two of them.

## v0.1.12-cfw3212.20

This is the first public release since `.19`. It rolls up all of the stock-UI coexistence, IP Passthrough DNS, dashboard, and security/flash-health work that was previously only sideloaded for testing.

**Stock UI coexistence**

- QManager now uses its own `qmanager-lighttpd` service for the QManager web UI on ports `9080` and `9000`, instead of taking over Casa's generic `lighttpd` service name. This lets Casa's stock web UI stay on its normal port `80` path while QManager runs beside it.
- Upgrading from earlier builds removes the old QManager-owned `lighttpd.service` override, restores Casa's masked `lighttpd` state, and starts the stock `turbontc` web UI service when it is present.
- The optional QManager web console now uses an internal backend on `9081` instead of `8080`, because Casa's stock UI also uses `8080` while starting its normal web service.
- System Health Check now reports QManager's web service as `qmanager-lighttpd.service`, so the service check matches the new coexistence layout.

**IP Passthrough DNS and dashboard**

- Keeps Casa's router/LAN DNS working automatically under IP Passthrough. A background reconciler checks every 30 seconds whether the router/LAN resolver can reach real carrier DNS and corrects it — it restores carrier DNS when IP Passthrough is turned off and only falls back to public DNS when no carrier resolver answers.
- The reconciler is probe-based: it treats carrier DNS as working if any carrier nameserver (IPv4 or IPv6) actually answers, instead of assuming DNS is broken just because the IP Passthrough placeholder `192.0.0.1` is present in `resolv.conf`. It only rewrites the dnsmasq config when something needs to change, so it adds no steady-state flash wear.
- Fixes the dashboard Online/Offline badge falsely showing Offline (DNS) under IP Passthrough while the internet actually works. The connectivity probe now uses the normal system resolver (which includes the carrier IPv6 nameservers that answer under IPPT) instead of assuming the IPv4 handover placeholder `192.0.0.1` means DNS is down.
- Adds two small status badges next to the dashboard Online/Offline badge: one shows whether IP Passthrough is On or Off, and one shows where the router/LAN DNS is currently coming from — Carrier, your QManager Custom DNS, or a public fallback. The DNS-source badge describes the router/LAN resolver only; a device in IP Passthrough mode still receives DNS straight from the carrier, which the router cannot report on.

**System Health Check fixes**

- Fixes a sudoers false failure. On Casa, QManager's sudo helper rules live under `/usrdata/opt/etc/sudoers.d/qmanager`; the health check now treats that installed helper file as valid instead of failing because the Casa sudo shim does not print a normal `sudo -l` listing.
- Fixes a DNS (`net.dns`) false failure on routers with IP Passthrough active. Casa leaves `192.0.0.1` in `/etc/resolv.conf`, which does not answer DNS even though dnsmasq on the LAN bridge still resolves correctly; the health check now queries the bridge LAN resolver instead of the poisoned nameserver.

**Flash-health and security hardening**

- Reduces flash wear from the data-usage counter. The poller now keeps the every-few-seconds hot counter state in `/tmp` and flushes the durable `/usrdata/qmanager/data_used.json` copy on a bounded cadence and important events instead of rewriting persistent flash every poll cycle.
- Turns off QManager's syslog forwarding by default on Casa, because Casa stores syslog under `/usrdata/log/messages`. The normal capped QManager log stays in `/tmp`.
- Hardens CGI handling by failing closed if the auth library is unavailable and by rejecting oversized POST bodies before reading them into memory.
- Adds the `Secure` attribute to QManager login cookies and removes wildcard CORS headers from CGI responses; the UI and API are served from the same HTTPS origin.
- Removes the old world-writable cron spool setup behavior while preserving QManager's current schedule writers, and tightens `/etc/qmanager` file and directory permissions.
- Narrows QManager sudo helpers to known `qmanager-*`, `tailscaled`, and `dnsmasq_service@0.service` units instead of allowing any `systemctl` target, aligns the Custom DNS sudo rules with the Casa `/tmp` staging file and `systemctl` dnsmasq reload path, and drops the unused broad `crontab` sudo rule.
- The installer now protects already-Casa `/usrdata/opt/...` paths during its install-time path normalization, preventing repeated `/usrdata` prefixes in installed helper scripts.

## v0.1.12-cfw3212.19

- The dashboard/status IP Passthrough fields now follow Casa's real IP handover state instead of always showing disabled. This matches the Local Network → IP Passthrough settings page, which was already reading Casa's RDB state correctly.
- The upstream Quectel MPDN/QMAP/USB-mode IP Passthrough probes remain blocked on Casa; this change only reads Casa's safe RDB status keys for display.

## v0.1.12-cfw3212.18

- Software Update restores the **Current Release Notes** card (Joetooley / Rus | Ame toggle) and **Version Management** dropdown from one check on page load, like build `.16`. **Check for Updates** forces a fresh GitHub pull.
- Software Update caches GitHub release and changelog responses on the router so repeat visits are much faster than a cold check.
- Software Update → Version Management no longer shows a duplicate **Install Now** in the staged-ready banner; install or reinstall from the version dropdown row.
- Dev sideload builds (`.dev` tag) show release notes by falling back to this build’s changelog when the dev tag is not published on the package repo.

## v0.1.12-cfw3212.17

- Software Update → Version Management works with the router's bundled `jq` build again. The `.16` rollback-history filter used a regex helper that is not available on the router, which could leave the version dropdown empty. The filter now uses a compatible literal split instead.
- Uninstall cleanup now restores Casa's stock masked `lighttpd` state after removing the QManager web service override.
- `--purge` cleanup now removes QManager-owned sudoers include residue and removes `/opt` only when it is the QManager-created shortcut to `/usrdata/opt`.
- Installs now start the Casa firewall service immediately, so curl installs, offline installs, and in-UI updates all finish in the same ready state without waiting for a reboot.

## v0.1.12-cfw3212.16

- Software Update → Version Management lists older releases again, so you can roll back to a previous build from the UI. Build .15 changed the package filename to include the full build number, but the in-UI version list only recognized that new naming — so right after the change only the newest build (.15) showed up and there was nothing to roll back to. The version list, the size shown for each version, and the rollback download now accept both filename styles (the new full-build-number name and the older upstream-only name), so the full history of installable builds appears again. Note: a router only shows this restored history once it's running a build that includes this fix (.16 or later); an older install still reaches .16 by a one-line/offline install first.

## v0.1.12-cfw3212.15

- Offline install on a clean stock router now works end to end. Previously, installing without internet ("Method 2") would stop early with `Could not resolve host: bin.entware.net`, because the web server (`lighttpd`), `sudo`, and their support libraries were downloaded during install rather than shipped in the package — only `jq` was bundled. The package now carries the full set of these components inside it, so a router with no SIM/WAN can install completely. Routers that do have internet still work the same way, falling back to downloading only if a bundled piece is somehow missing.
- QManager no longer needs a writable root filesystem (no pivot/overlay/"rooting" prep). The web server starts from explicit `/usrdata` paths (its modules are loaded from `/usrdata/opt` and it no longer comes up masked), and privileged actions in the UI now work directly, so the install comes up functional on a clean stock box.
- About Device now shows the modem's identity (Model, Firmware, Build Date, IMEI, Manufacturer) even with no SIM inserted. Previously the poller bundled the SIM reads (`CIMI`/`QCCID`/`CNUM`) into the same query as the modem identity, so on a SIM-less modem the SIM commands errored and wiped out the whole response — leaving every field blank until a SIM was present. The SIM reads are now a separate, best-effort step, so the always-available identity fields fill in regardless of SIM.
- The downloadable package file now includes the full build number in its name (for example `qmanager-cfw3212-v0.1.12-cfw3212.15.tar.gz` instead of `qmanager-cfw3212-v0.1.12.tar.gz`). Previously every build of the same upstream version downloaded with the same filename, so a new download landed next to an old one as `… (1).tar.gz` and the offline install command could pick up the wrong (older) file. Each build now has a unique filename. Note: because of this rename, reaching this build from an older install is a fresh one-line/offline install rather than an in-app Software Update.

## v0.1.12-cfw3212.14

- The "Reboot required" reminder after a software update now stays put until you actually reboot. After an install finishes, the Software Update page shows a "Reboot required" badge and an "Installation complete — Reboot when ready" notice with a Reboot Now button. Previously, if you navigated away from that page and came back (or reloaded it), the reminder disappeared, even though the device still needed a reboot to finish applying the update. The page now re-checks the pending-reboot state every time you open it, so the reminder and the Reboot Now button stay visible until the reboot is done. It clears on its own once the device reboots.
- Full uninstall is now complete: the `--purge` uninstall also removes the Email Alerts helper (`msmtp`), which a previous purge could leave behind. The normal (non-purge) uninstall is unchanged and still keeps your `/etc/qmanager` settings so a later reinstall picks them back up.

## v0.1.12-cfw3212.13

- Running the System Health Check no longer leaves the background data poller stopped. The health check briefly pauses the poller so it can talk to the modem without contention, then resumes it when it finishes. Previously it paused the poller by stopping the service and counting on a cleanup step to start it again — but if the health check got cut off partway (for example the page was closed, the connection dropped, or the router was low on memory), that cleanup could be skipped and the poller was left off. Because the poller is set to only auto-restart after a crash (not after a normal stop), it then stayed off until something started it again, which is why the next Health Check showed `qmanager-poller` as inactive with a warning and the dashboard metrics went stale. The health check now pauses the poller with the same safe flag the Speedtest already uses: the poller keeps running and just skips its modem polling while paused, and it clears a stale pause on its own after a few minutes — so an interrupted health check can no longer take the poller down.

## v0.1.12-cfw3212.12

- The QManager HTTPS certificate is now generated correctly so browsers accept it. The previous build produced a certificate with a duplicate setting that newer Chrome/Edge rejected outright (`NET::ERR_CERT_INVALID`, with no way to continue). The certificate is now built cleanly with a Subject Alternative Name and proper server settings, so reaching the QManager UI over HTTPS shows the normal, click-through-able warning. Existing installs are upgraded automatically on the next install.

## v0.1.12-cfw3212.11

- Software Update now reliably finds the newest available version. Once the Casa build number reached double digits (for example `.10` and up), the update check could miss it and report "up to date," because it was trusting the package host's release ordering instead of comparing build numbers directly. The check now sorts candidates by their actual version and build number, so the newest build is always detected regardless of how the host lists them.

## v0.1.12-cfw3212.10

- Software Update → Version Management install confirmations no longer say the device will reboot automatically. All three "Install Now" / "Reinstall Now" dialogs now match the Update Status card: QManager restarts its services after installation and then asks you to reboot when ready.
- The QManager HTTPS certificate is now a proper server certificate with a Subject Alternative Name (covering localhost, the router's LAN IP, and — when Tailscale is up — its Tailscale IP/name). Older builds shipped a certificate that newer iPhone/Safari and Firefox versions refused to open (the browser warning had no "continue anyway" option). Reaching the QManager UI over HTTPS (including over Tailscale) now shows a normal, acceptable certificate warning you can click through. Existing installs that still have the old certificate are upgraded automatically on the next install.

## v0.1.12-cfw3212.9

- Tailscale "Connect" / login now works from the UI on the Tiny Tailscale build. The previous build left out the component that hands the login link back to the browser, so clicking Connect timed out waiting for a sign-in link. The Tiny Tailscale build used here restores that, so you can connect and sign in from the UI normally — while keeping the lower memory use.

## v0.1.12-cfw3212.8

- Tailscale install reliability fixes for the Tiny Tailscale build introduced in `.7`:
  - The download now follows GitHub redirects, so installing Tailscale from the UI no longer fails partway with an extraction error.
  - The Tailscale service now starts correctly. On the lighter build the daemon was actually running but the service was being reported as "Failed to start" / Stopped; the Service status and Start on Boot now reflect the real state, and you can connect normally.

## v0.1.12-cfw3212.7

- Custom DNS changes now take effect immediately. Previously, enabling, changing, or disabling custom DNS only fully applied after the next router reboot, because the DNS service was sent a reload signal that does not re-read its configuration on this platform. The setting is now applied right away by restarting the DNS service.
- The Tailscale install from the QManager UI now uses Tiny Tailscale, a smaller, lighter Tailscale build (v1.98.3), instead of the full official package. It installs and runs the same way from the UI, but uses noticeably less memory on the router — helpful on this hardware where RAM is tight. To upgrade Tailscale later, uninstall and reinstall it from the UI rather than using an in-place update.

## v0.1.12-cfw3212.6

- No functional changes from `v0.1.12-cfw3212.5`. This release is a clean rebuild on top of `.5` to validate the deterministic frontend build ID end-to-end on a live router — installing `.5 → .6` should now rewrite only the small number of files that actually differ between the two builds, instead of the ~80% of the frontend tree that older Casa releases rewrote on every backend-only update.

## v0.1.12-cfw3212.5

- Casa package builds now use a deterministic frontend build ID based on frontend source inputs. This prevents backend-only Casa releases from changing hundreds of exported Next.js files just because the build ID changed, which should greatly reduce flash writes, CPU load, and swap pressure during normal QManager updates.

## v0.1.12-cfw3212.4

- Software Update install progress now explicitly reports `Restarting QManager services...` while the Casa installer is bringing QManager/lighttpd services back up. This makes the two-step download/install flow clearer and no longer depends on the browser seeing a temporary reconnect failure to show a services-restarting message.

## v0.1.12-cfw3212.3

- **Orientation probe gated off for Casa CFW-3212.** The upstream v0.1.12 Cloudflare download probe (~5 MB, up to 90 s timeout) that tries to detect flipped upload/download counters on some Quectel firmwares is now disabled at the converter level for CFW-3212/RG520N-NA builds. Our upload/download counters are not flipped in normal use, and the probe caused unnecessary CPU/network contention around install and first WAN-up.
- The probe's fallback defaults (field 2 = download, field 10 = upload) match the correct CFW-3212 behavior, so upload/download display is unchanged.

## v0.1.12-cfw3212.2

- Installer cleanup: optional Ookla Speedtest helper download failures are now handled as best-effort, so a temporary internet/CDN problem should no longer make the whole QManager install report failure after the new version has already been installed.

## v0.1.12-cfw3212.1

- Ookla Speedtest dashboard no longer crashes when the test result is missing Download or Upload latency stats (which Ookla omits when packet loss is high enough that those numbers wouldn't be meaningful). The DL Latency and UL Latency fields now render `—` instead of throwing a JavaScript error that took the dashboard down.
- First Casa build on top of upstream QManager v0.1.12. Notable upstream changes you'll see on the router:
  - **Upload/Download orientation auto-probe** at first boot: QManager runs a small (5 MB) outbound probe and uses the result to map rmnet rx/tx to "upload" vs "download" the right way on Casa. Older builds sometimes had these swapped.
  - **Storage row** is now part of the Device Metrics dashboard, showing `/usrdata` usage.
  - **Live Traffic widget** has been removed. The kernel counters it relied on read near-zero because the Casa IPA hardware offload bypasses them, so the widget was misleading. Throughput numbers from Ookla Speedtest are still accurate.
  - **IP Passthrough Apply & Reboot** now actually reboots. Previously, on Casa, pressing Apply could update the profile without triggering the reboot — you now go through the standard reboot countdown screen.
  - **OTA reboot pages** no longer show a blank screen between "rebooting" and "back online". All reboot flows wait for the page to be ready before redirecting.
- All CFW-3212 patches from v0.1.11 carry forward: Casa paths, health-check, watchcat tiers, Ookla speedtest poller pause, Custom DNS, IP Passthrough cleanup, Version Management Install fix.

## v0.1.11-cfw3212.8

- Ookla Speedtest now pauses QManager's modem poller while the test is running. This prevents the poller from issuing modem AT reads during the test and keeps Speedtest-created latency or packet-loss spikes out of Recent Network Events.
- Speedtest now stores its Ookla config under `/tmp/qmanager-ookla-home` on Casa, avoiding the read-only `/home/root` path.

## v0.1.11-cfw3212.7

- Watchcat (the automatic recovery daemon) now uses the same Casa-friendly paths the manual UI buttons use. Tier 1 "re-register to network" asks Casa's connection manager via `link.profile.1.writeflag` / `link.policy.1.trigger_connect` instead of forcing the modem through `AT+COPS=2/0`. Tier 4 "reboot device" goes through `service.system.reset` instead of a bare `reboot`. Both still fall back to the legacy behavior if the Casa RDB keys aren't available, so non-Casa builds are unaffected.

## v0.1.11-cfw3212.6

- Version Management now shows a "Staged and ready to install" banner with **Install Now** and **Discard** buttons whenever a downloaded package is sitting on the router. You can drop the staged tarball without being forced to install it first if you change your mind about a downgrade.
- The router reboot countdown screen now waits 120 seconds before declaring the reboot stuck, up from 70 seconds, so slower Casa reboots don't trip the "still rebooting?" warning prematurely.

## v0.1.11-cfw3212.5

- Software Update → Version Management now finishes the install flow on Casa. Previously, picking an older version downloaded it but the page snapped back to "Up to date" and never offered an Install button, so the staged tarball just sat in /tmp. The button now transitions to "Install Now" once the download is verified, calls the staged-install flow, and reboots into the selected version.

## v0.1.11-cfw3212.4

- Reconnect Network now asks Casa's own connection manager to refresh the cellular session instead of forcing the modem through a hard deregister/re-register cycle. This should make that menu action much gentler on the router.
- Reconnect Network now shows a progress window after you confirm the action. It watches QManager's modem status cache and shows elapsed time, cellular registration, WAN IP, and internet reachability instead of closing immediately while the reconnect continues in the background.

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
- Manual SIM Profile save, apply, delete, and deactivate works on Casa, including APN, TTL/HL, IMEI, and the modem reboot apply step. ICCID auto-apply is safety-limited and now requires the explicit SIM Profiles page toggle.
- Casa/RG520N ICCID handling was cleaned up so SIM Profiles do not show false SIM mismatch warnings from a missing trailing padding nibble.
- Dashboard freshness checks tolerate Casa boxes with a wrong wall clock as long as the router status timestamp keeps advancing.
- Web Console, Software Update Casa notes, Email Alerts `msmtp` install/remove, Discord Bot backend install, Tailscale, and Ookla Speedtest support were added or tightened during the v0.1.10 Casa series.
- Installs and GUI updates were made gentler on router flash: fewer unnecessary file writes, no duplicate full tarball extraction during online install/update, and GUI updates end in a reboot-required state instead of rebooting automatically.
- Casa package safety limits stayed in place around USB composition, upstream IP Passthrough modem writes, and automatic SIM Profile apply behavior.

## Earlier Highlights

- Casa package releases go out through the two-repo builder/package flow, with protected prerelease publishing and a router-verified mark on releases.
- Cut down on router flash churn: skip frontend payloads that haven't changed, compare before copying, pace fresh installs, and don't extract the tarball twice during online installs/updates.
- GUI updates now end in a reboot-required state instead of rebooting on their own. You decide when the reboot happens.
- QManager install paths are mapped to Casa's writable storage at `/usrdata` and `/etc/systemd/system`, with lighttpd on HTTP `9080` and HTTPS `9000`.
- Kept the Casa safety lines drawn around USB composition, upstream IP Passthrough modem writes, and automatic SIM Profile apply behavior.
