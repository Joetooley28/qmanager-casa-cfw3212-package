# QManager Casa CFW-3212 Package Releases

Ready-to-install Casa CFW-3212 builds of QManager are published on this repo's
GitHub Releases page.

## Download

Open the Releases page and download the newest Casa asset pair:

- `qmanager-cfw3212-<version>.tar.gz`
- `qmanager-cfw3212-<version>.sha256`

The current release is `v0.1.9-cfw3212.1`.

## Install

Copy the tarball to the router as `/tmp/qmanager.tar.gz`, then run this on the
router:

```sh
cd /tmp
tar xzf /tmp/qmanager.tar.gz
sh /tmp/qmanager_install/install_cfw3212.sh
```

After install, open QManager at:

```text
https://<router-lan-ip>:9000/
```

## Verify Checksum

On a Linux/macOS/WSL shell, place the `.tar.gz` and `.sha256` files in the same
folder, then run:

```sh
sha256sum -c qmanager-cfw3212-v0.1.9.sha256
```

Expected SHA-256 for `v0.1.9-cfw3212.1`:

```text
f54daaf5d84f855f343f84b2932e3f89ecd248b0302dc0ec170414b8787bd7da
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
