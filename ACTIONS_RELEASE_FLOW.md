# GitHub Actions Release Flow

This repo publishes Casa CFW-3212 converted QManager packages. The router should
only install assets from this package repo, never raw upstream
`dr-dolomite/QManager-RM520N` packages.

The workflow is:

```text
.github/workflows/build-casa-release.yml
```

It checks `dr-dolomite/QManager-RM520N` releases and only accepts real app
releases: tags matching `vX.Y.Z` that contain both `qmanager.tar.gz` and
`sha256sum.txt`. That filters out non-app releases such as `language-packs`.
It converts the selected app release and stages Casa package assets named:

```text
qmanager-cfw3212-vX.Y.Z.tar.gz
qmanager-cfw3212-vX.Y.Z.sha256
```

Casa release tags use:

```text
vX.Y.Z-cfw3212.N
```

For example, upstream `v0.1.10` with Casa build `1` becomes
`v0.1.10-cfw3212.1`.

## Safe Defaults

Manual runs default to:

```text
upstream_version=latest
casa_build=1
prerelease=true
dry_run=true
force=false
create_release=false
```

Those defaults build and upload a workflow artifact only. They do not create or
modify GitHub Releases.

The scheduled run checks every 6 hours and also uses safe dry-run behavior. It
can detect and build a new upstream app release, but it will not publish assets.

## Dry Run

Use these settings to test the full conversion without publishing:

```text
upstream_version=latest
casa_build=1
prerelease=true
dry_run=true
force=false
create_release=false
```

The run uploads a workflow artifact containing the staged `.tar.gz` and
`.sha256` files. The one-line install/uninstall scripts are generated later for
published GitHub Releases and are not part of the dry-run artifact.

## Create A Prerelease

After reviewing a dry-run artifact, use:

```text
upstream_version=latest
casa_build=1
prerelease=true
dry_run=false
force=false
create_release=true
```

This creates a GitHub prerelease in
`Joetooley28/qmanager-casa-cfw3212-package`, for example
`v0.1.10-cfw3212.1`.

Published prereleases upload four assets:

```text
qmanager-cfw3212-vX.Y.Z.tar.gz
qmanager-cfw3212-vX.Y.Z.sha256
install-qmanager-cfw3212.sh
uninstall-qmanager-cfw3212.sh
```

If that tag already exists, the workflow refuses to upload or replace assets
unless `force=true` is set. Use `force=true` only after explicitly deciding to
replace existing release assets.

## Stable Releases

The workflow refuses `prerelease=false`. Stable promotion should remain a manual
GitHub release operation after live-router testing.

Normal router updater flows should ignore prereleases unless a future GUI option
explicitly opts into prerelease checks.

## Permissions

The workflow uses the built-in `GITHUB_TOKEN` with `contents: write` to create
package repo releases.

Repository settings must allow GitHub Actions to create releases with the
workflow token.

Because the converter repo is private, add this package repo secret:

```text
CONVERTER_REPO_TOKEN
```

Use a fine-grained token with read-only `Contents` access to:

```text
Joetooley28/qmanager-casa-conversion-cfw3212-gui-ota
```

No extra secret is required for public upstream release checks.
