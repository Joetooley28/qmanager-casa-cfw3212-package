# QManager Casa CFW-3212 Package Releases

Ready-to-install Casa CFW-3212 builds of QManager are published on this repo's
[GitHub Releases page](https://github.com/Joetooley28/qmanager-casa-cfw3212-package/releases).

Casa-specific notes are tracked in the
[Casa CFW-3212 changelog](CFW3212_JTOOLEY_CHANGELOG.md). The router Software
Update page also shows these notes inside QManager.

## Credit

QManager is built and maintained by **Rus | Ame** (`misuzu__` on Discord),
GitHub **[dr-dolomite](https://github.com/dr-dolomite)**. Huge thanks to Rus
for all the hard work building, maintaining, and sharing QManager with the
community. The upstream project is
**[dr-dolomite/QManager-RM520N](https://github.com/dr-dolomite/QManager-RM520N)**.

Joetooley built only the Casa CFW-3212 converter/package flow and small UI
compatibility changes needed to make QManager installable and usable on the
Casa CFW-3212.

Most users should use the prebuilt, ready-to-install package from the latest
GitHub Release. The release page includes version-specific install commands and
download assets, so you usually do not need to build anything yourself.

This repository is intentionally release-only. The public builder/converter
source and GitHub Actions workflow live in:

```text
Joetooley28/qmanager-casa-cfw3212-builder
```

Published release assets are still hosted here, and router install/update flows
should continue to use this package repo.

## Install Or Update

There are three ways to install or update, easiest first:

- **From the router UI (easiest).** Open QManager and go to **Software Update**,
  then install the latest version from there. The router fetches the current
  package on its own — you do not need any of the commands below.
- **Windows PowerShell / SSH, router has internet** — Method 1 below.
- **Offline, router has no internet** — Method 2 below.

> The commands in this README use `<RELEASE_TAG>` (for example
> `v0.1.12-cfw3212.13`) and `<VERSION>` (for example `v0.1.12`) as placeholders.
> Every [GitHub Release](https://github.com/Joetooley28/qmanager-casa-cfw3212-package/releases)
> page already shows ready-to-paste install/uninstall commands that are
> auto-generated with that release's exact version. The simplest path is to copy
> the commands straight from the latest release; otherwise replace the
> placeholders below with the version you want.

### Method 1: Router Has Internet

The release page commands are generated with that release's version tag. If you
copy commands from this README instead, change the release tag to the version
you want. Also change `192.168.1.1` anywhere it appears if your router LAN IP is
not stock.

SSH into the router from Windows PowerShell:

```powershell
ssh root@192.168.1.1
```

Then run this on the router:

```sh
curl -fsSL https://github.com/Joetooley28/qmanager-casa-cfw3212-package/releases/download/<RELEASE_TAG>/install-qmanager-cfw3212.sh | sh
```

If `curl` fails, use `wget` instead:

```sh
wget -qO- https://github.com/Joetooley28/qmanager-casa-cfw3212-package/releases/download/<RELEASE_TAG>/install-qmanager-cfw3212.sh | sh
```

This downloads the package, verifies the checksum, extracts it, and runs the
Casa installer. It works for both fresh install and update.

### Method 2: Router Has No Internet

The release page commands and asset names are generated for that release. If
you copy commands from this README instead, change the version in the filename
and release tag to the package you downloaded. Also change `192.168.1.1` if your
router LAN IP is not stock.

Use this path when the router does not have working internet yet. On your
Windows computer, download this release asset:

- `qmanager-cfw3212-<VERSION>.tar.gz`

Do not extract the `.tar.gz` on Windows. If Windows already opened/extracted it
into a folder, go back to the folder that contains the original `.tar.gz` file.

Then run these two commands from Windows PowerShell in that folder:

```powershell
scp -O .\qmanager-cfw3212-<VERSION>.tar.gz root@192.168.1.1:/tmp/qmanager.tar.gz
ssh root@192.168.1.1 "rm -rf /tmp/qmanager_install && tar xzf /tmp/qmanager.tar.gz -C /tmp && sh /tmp/qmanager_install/install_cfw3212.sh"
```

The `-O` flag uses legacy SCP mode, which is needed by some Casa SSH setups.

If you prefer Linux/WSL, use the same two-step flow:

```sh
scp -O qmanager-cfw3212-<VERSION>.tar.gz root@192.168.1.1:/tmp/qmanager.tar.gz
ssh root@192.168.1.1 'rm -rf /tmp/qmanager_install && tar xzf /tmp/qmanager.tar.gz -C /tmp && sh /tmp/qmanager_install/install_cfw3212.sh'
```

After install, open QManager at:

```text
https://<router-lan-ip>:9000/
```

The installer overwrites QManager web files, CGI scripts, daemons, service
units, and Casa-safe runtime patches. It preserves existing `/etc/qmanager`
configuration files when possible, including login/config data and TLS certs.

## Uninstall

### Online Uninstall

The release page commands are generated with that release's version tag. If you
copy commands from this README instead, change the release tag to the version
you want. Also change `192.168.1.1` anywhere it appears if your router LAN IP is
not stock.

SSH into the router from Windows PowerShell:

```powershell
ssh root@192.168.1.1
```

Then run this on the router:

```sh
curl -fsSL https://github.com/Joetooley28/qmanager-casa-cfw3212-package/releases/download/<RELEASE_TAG>/uninstall-qmanager-cfw3212.sh | sh
```

If `curl` fails, use `wget` instead:

```sh
wget -qO- https://github.com/Joetooley28/qmanager-casa-cfw3212-package/releases/download/<RELEASE_TAG>/uninstall-qmanager-cfw3212.sh | sh
```

### Offline Uninstall

The release page commands and asset names are generated for that release. If
you copy commands from this README instead, change the version in the filename
and release tag to the package you downloaded. Also change `192.168.1.1` if your
router LAN IP is not stock.

If the router has no internet, use the same downloaded `.tar.gz` and run these
two commands from Windows PowerShell:

```powershell
scp -O .\qmanager-cfw3212-<VERSION>.tar.gz root@192.168.1.1:/tmp/qmanager.tar.gz
ssh root@192.168.1.1 "rm -rf /tmp/qmanager_install && tar xzf /tmp/qmanager.tar.gz -C /tmp && sh /tmp/qmanager_install/uninstall_cfw3212.sh --force --no-reboot"
```

Linux/WSL:

```sh
scp -O qmanager-cfw3212-<VERSION>.tar.gz root@192.168.1.1:/tmp/qmanager.tar.gz
ssh root@192.168.1.1 'rm -rf /tmp/qmanager_install && tar xzf /tmp/qmanager.tar.gz -C /tmp && sh /tmp/qmanager_install/uninstall_cfw3212.sh --force --no-reboot'
```

Default uninstall removes QManager services, `/usrdata/qmanager`, and
QManager-installed binaries under `/usrdata/bin`. It preserves `/etc/qmanager`
and `/usrdata/opt` so config and Entware payloads are not destroyed casually.
The online uninstall wrapper verifies the release tarball but extracts only the
Casa uninstaller script, avoiding a full package expansion during uninstall.

For a deeper cleanup, add `--purge` to the uninstall command:

```powershell
ssh root@192.168.1.1 "rm -rf /tmp/qmanager_install && tar xzf /tmp/qmanager.tar.gz -C /tmp && sh /tmp/qmanager_install/uninstall_cfw3212.sh --force --no-reboot --purge"
```

For online purge, SSH into the router and run:

```sh
curl -fsSL https://github.com/Joetooley28/qmanager-casa-cfw3212-package/releases/download/<RELEASE_TAG>/uninstall-qmanager-cfw3212.sh | sh -s -- --purge
```

Or with `wget`:

```sh
wget -qO- https://github.com/Joetooley28/qmanager-casa-cfw3212-package/releases/download/<RELEASE_TAG>/uninstall-qmanager-cfw3212.sh | sh -s -- --purge
```

`--purge` removes `/etc/qmanager`, `/usrdata/opt`, QManager-owned runtime temp
files, QManager sudoers drop-ins, QManager-installed Tailscale service/state
and symlinks, root Ookla CLI config, the Email Alerts `msmtp` helper, and transient Tailscale logs too. Use it
only when you really want to discard QManager config, bundled Entware state,
and optional QManager-installed tools.

## Optional Checksum

The online installer checks the package automatically. For offline Windows
installs, you can verify the downloaded tarball in PowerShell:

```powershell
Get-FileHash .\qmanager-cfw3212-<VERSION>.tar.gz -Algorithm SHA256
```

Then compare the output against the `qmanager-cfw3212-<VERSION>.tar.gz.sha256`
checksum asset published next to the package on its release page.

## Versioning

Release tags follow this pattern:

```text
<upstream-qmanager-version>-cfw3212.<casa-build-number>
```

Example: upstream QManager `v0.1.9` becomes `v0.1.9-cfw3212.1` for the first
Casa CFW-3212 package build.

When upstream publishes a new QManager release, run the conversion workflow from
the builder repo and publish a new GitHub Release here with the converted Casa
package assets.

## Casa Safety Scope

The Casa package keeps these CFW-3212 safety constraints:

- installs under `/usrdata` and writable `/etc/systemd/system`
- uses HTTP `9080` and HTTPS `9000`
- keeps `/dev/smd11` and bundled `atcli_smd11` (Rust)
- blocks upstream USB composition / ECM / MBIM / RNDIS exposure
- blocks blind SIM profile auto-apply
- maps IP Passthrough to Casa-safe Ethernet enable/disable behavior
