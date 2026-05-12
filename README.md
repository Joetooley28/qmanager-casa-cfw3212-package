# QManager Casa CFW-3212 Package Releases

Ready-to-install Casa CFW-3212 builds of QManager are published on this repo's
GitHub Releases page.

## One-Line Online Install

SSH into the rooted Casa CFW-3212 as root, then run one of these commands on the
router.

With `curl`:

```sh
curl -fsSL https://github.com/Joetooley28/qmanager-casa-cfw3212-package/releases/download/v0.1.9-cfw3212.1/install-qmanager-cfw3212.sh | sh
```

With `wget`:

```sh
wget -qO- https://github.com/Joetooley28/qmanager-casa-cfw3212-package/releases/download/v0.1.9-cfw3212.1/install-qmanager-cfw3212.sh | sh
```

This downloads the package, verifies the checksum, extracts it, and runs the
Casa installer.

## Offline / No-Router-Internet Install

Use this path when the router does not have working internet yet.

Open the Releases page and download the newest Casa asset pair:

- `qmanager-cfw3212-<version>.tar.gz`
- `qmanager-cfw3212-<version>.sha256`

The current release is `v0.1.9-cfw3212.1`.

Copy the tarball to the router as `/tmp/qmanager.tar.gz`, SSH into the router
as root, then run:

```sh
cd /tmp
rm -rf /tmp/qmanager_install
tar xzf /tmp/qmanager.tar.gz
sh /tmp/qmanager_install/install_cfw3212.sh
```

After install, open QManager at:

```text
https://<router-lan-ip>:9000/
```

## Update Existing Casa QManager

For a normal update from an older Casa QManager package, use the same install
command. The installer overwrites QManager web files, CGI scripts, daemons,
service units, and Casa-safe runtime patches. It preserves existing
`/etc/qmanager` configuration files when possible, including login/config data
and TLS certs.

Online:

```sh
curl -fsSL https://github.com/Joetooley28/qmanager-casa-cfw3212-package/releases/download/v0.1.9-cfw3212.1/install-qmanager-cfw3212.sh | sh
```

Offline: copy the tarball to `/tmp/qmanager.tar.gz`, then run the offline
install commands above.

If the previous install is badly broken or from an early experimental build,
run the uninstall command first, then install again.

## Uninstall

Online uninstall:

```sh
curl -fsSL https://github.com/Joetooley28/qmanager-casa-cfw3212-package/releases/download/v0.1.9-cfw3212.1/uninstall-qmanager-cfw3212.sh | sh
```

Offline uninstall: copy the same tarball to `/tmp/qmanager.tar.gz`, then run:

```sh
cd /tmp
rm -rf /tmp/qmanager_install
tar xzf /tmp/qmanager.tar.gz
sh /tmp/qmanager_install/uninstall_cfw3212.sh --force --no-reboot
```

Default uninstall removes QManager services, `/usrdata/qmanager`, and
QManager-installed binaries under `/usrdata/bin`. It preserves `/etc/qmanager`
and `/usrdata/opt` so config and Entware payloads are not destroyed casually.

For a deeper cleanup, add `--purge`:

```sh
sh /tmp/qmanager_install/uninstall_cfw3212.sh --force --no-reboot --purge
```

Online purge:

```sh
curl -fsSL https://github.com/Joetooley28/qmanager-casa-cfw3212-package/releases/download/v0.1.9-cfw3212.1/uninstall-qmanager-cfw3212.sh | sh -s -- --purge
```

`--purge` removes `/etc/qmanager` and `/usrdata/opt` too. Use it only when you
really want to discard QManager config and bundled Entware state.

## Verify Checksum

On a Linux/macOS/WSL shell, place the `.tar.gz` and `.sha256` files in the same
folder, then run:

```sh
sha256sum -c qmanager-cfw3212-v0.1.9.sha256
```

Expected SHA-256 for `v0.1.9-cfw3212.1`:

```text
d1c1d824694bb5359dabd2964000435af70d34d402c9962ca022ef01b48f3ec1
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
