# QManager Casa CFW-3212 Package Releases

Ready-to-install Casa CFW-3212 builds of QManager are published on this repo's
GitHub Releases page.

## Install Or Update

Use one of these two methods. Most Windows users should use PowerShell.

### Method 1: Router Has Internet

SSH into the router from Windows PowerShell:

```powershell
ssh root@192.168.1.1
```

Then run this on the router:

```sh
curl -fsSL https://github.com/Joetooley28/qmanager-casa-cfw3212-package/releases/download/v0.1.10-cfw3212.2/install-qmanager-cfw3212.sh | sh
```

If `curl` fails, use `wget` instead:

```sh
wget -qO- https://github.com/Joetooley28/qmanager-casa-cfw3212-package/releases/download/v0.1.10-cfw3212.2/install-qmanager-cfw3212.sh | sh
```

This downloads the package, verifies the checksum, extracts it, and runs the
Casa installer. It works for both fresh install and update.

### Method 2: Router Has No Internet

Use this path when the router does not have working internet yet. On your
Windows computer, download this release asset:

- `qmanager-cfw3212-v0.1.10.tar.gz`

Do not extract the `.tar.gz` on Windows. If Windows already opened/extracted it
into a folder, go back to the folder that contains the original `.tar.gz` file.

Then run these two commands from Windows PowerShell in that folder:

```powershell
scp -O .\qmanager-cfw3212-v0.1.10.tar.gz root@192.168.1.1:/tmp/qmanager.tar.gz
ssh root@192.168.1.1 "rm -rf /tmp/qmanager_install && tar xzf /tmp/qmanager.tar.gz -C /tmp && sh /tmp/qmanager_install/install_cfw3212.sh"
```

The `-O` flag uses legacy SCP mode, which is needed by some Casa SSH setups.

If you prefer Linux/WSL, use the same two-step flow:

```sh
scp -O qmanager-cfw3212-v0.1.10.tar.gz root@192.168.1.1:/tmp/qmanager.tar.gz
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

SSH into the router from Windows PowerShell:

```powershell
ssh root@192.168.1.1
```

Then run this on the router:

```sh
curl -fsSL https://github.com/Joetooley28/qmanager-casa-cfw3212-package/releases/download/v0.1.10-cfw3212.2/uninstall-qmanager-cfw3212.sh | sh
```

### Offline Uninstall

If the router has no internet, use the same downloaded `.tar.gz` and run these
two commands from Windows PowerShell:

```powershell
scp -O .\qmanager-cfw3212-v0.1.10.tar.gz root@192.168.1.1:/tmp/qmanager.tar.gz
ssh root@192.168.1.1 "rm -rf /tmp/qmanager_install && tar xzf /tmp/qmanager.tar.gz -C /tmp && sh /tmp/qmanager_install/uninstall_cfw3212.sh --force --no-reboot"
```

Linux/WSL:

```sh
scp -O qmanager-cfw3212-v0.1.10.tar.gz root@192.168.1.1:/tmp/qmanager.tar.gz
ssh root@192.168.1.1 'rm -rf /tmp/qmanager_install && tar xzf /tmp/qmanager.tar.gz -C /tmp && sh /tmp/qmanager_install/uninstall_cfw3212.sh --force --no-reboot'
```

Default uninstall removes QManager services, `/usrdata/qmanager`, and
QManager-installed binaries under `/usrdata/bin`. It preserves `/etc/qmanager`
and `/usrdata/opt` so config and Entware payloads are not destroyed casually.

For a deeper cleanup, add `--purge` to the uninstall command:

```powershell
ssh root@192.168.1.1 "rm -rf /tmp/qmanager_install && tar xzf /tmp/qmanager.tar.gz -C /tmp && sh /tmp/qmanager_install/uninstall_cfw3212.sh --force --no-reboot --purge"
```

For online purge, SSH into the router and run:

```sh
curl -fsSL https://github.com/Joetooley28/qmanager-casa-cfw3212-package/releases/download/v0.1.10-cfw3212.2/uninstall-qmanager-cfw3212.sh | sh -s -- --purge
```

`--purge` removes `/etc/qmanager` and `/usrdata/opt` too. Use it only when you
really want to discard QManager config and bundled Entware state.

## Optional Checksum

The online installer checks the package automatically. For offline Windows
installs, you can verify the downloaded tarball in PowerShell:

```powershell
Get-FileHash .\qmanager-cfw3212-v0.1.10.tar.gz -Algorithm SHA256
```

Expected SHA-256 for `v0.1.10-cfw3212.2`:

```text
5ce7c8959d19db6fc6a0dd596f0994d223947f066c6cf1f4c82003465d24e5c3
```

## Versioning

Release tags follow this pattern:

```text
<upstream-qmanager-version>-cfw3212.<casa-build-number>
```

Example: upstream QManager `v0.1.9` becomes `v0.1.9-cfw3212.1` for the first
Casa CFW-3212 package build.

When upstream publishes a new QManager release, run the conversion workflow and
publish a new GitHub Release with the converted Casa package assets.

## Casa Safety Scope

The Casa package keeps these CFW-3212 safety constraints:

- installs under `/usrdata` and writable `/etc/systemd/system`
- uses HTTP `9080` and HTTPS `9000`
- keeps `/dev/smd11` and bundled `atcli_smd11`
- disables upstream OTA update paths
- blocks upstream USB composition / ECM / MBIM / RNDIS exposure
- blocks blind SIM profile auto-apply
- maps IP Passthrough to Casa-safe Ethernet enable/disable behavior
