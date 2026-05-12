# QManager Casa CFW-3212 Package Releases

Ready-to-install Casa CFW-3212 builds of QManager are published on this repo's
GitHub Releases page.

## Download

Open the Releases page and download the newest Casa asset pair:

- `qmanager-cfw3212-<version>.tar.gz`
- `qmanager-cfw3212-<version>.sha256`

The current release is `v0.1.9-cfw3212.1`.

## Fresh Install

Copy the tarball to the router as `/tmp/qmanager.tar.gz`, then run this on the
router as root:

```sh
cd /tmp
tar xzf /tmp/qmanager.tar.gz
sh /tmp/qmanager_install/install_cfw3212.sh
```

After install, open QManager at:

```text
https://<router-lan-ip>:9000/
```

## Update Existing Casa QManager

For a normal update from an older Casa QManager package, use the same command as
a fresh install:

```sh
cd /tmp
rm -rf /tmp/qmanager_install
tar xzf /tmp/qmanager.tar.gz
sh /tmp/qmanager_install/install_cfw3212.sh
```

The installer overwrites QManager web files, CGI scripts, daemons, service
units, and Casa-safe runtime patches. It preserves existing `/etc/qmanager`
configuration files when possible, including login/config data and TLS certs.

If the previous install is badly broken or from an early experimental build,
run the uninstall command first, then install again.

## Uninstall

The uninstall script is inside the release tarball. Extract the same package and
run:

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
a220946e7c0b67a2f0987343235a6045c28393b0f3d794aa3f73a10f657b9a74
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
