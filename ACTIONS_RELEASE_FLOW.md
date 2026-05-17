# Casa Package Release Flow

This repo is the official Casa CFW-3212 QManager package/download repo. The
router should only install assets from this package repo, never raw upstream
`dr-dolomite/QManager-RM520N` packages.

The builder/converter source and GitHub Actions workflow live in the public
builder repo:

```text
Joetooley28/qmanager-casa-cfw3212-builder
```

The builder workflow checks `dr-dolomite/QManager-RM520N` releases and only
accepts real app releases: tags matching `vX.Y.Z` that contain both
`qmanager.tar.gz` and `sha256sum.txt`. That filters out non-app releases such
as `language-packs`. It converts the selected app release and stages Casa
package assets named:

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

Builder workflow manual runs default to:

```text
upstream_version=latest
casa_build=1
dry_run=true
force=false
create_release=false
```

The workflow no longer exposes a `prerelease` input. Automation only publishes
prereleases; stable promotion remains a manual GitHub release operation after
live-router testing.

Those defaults build and upload a workflow artifact only. They do not create or
modify GitHub Releases.

The scheduled run checks every 6 hours. It resolves the newest upstream app
release, checks whether any valid Casa package release already exists for that
upstream tag, and stops early when nothing changed:

```text
No new QManager release out yet. Latest upstream app release is still vX.Y.Z,
and a Casa package already exists.
```

When a new upstream app release appears, the scheduled run continues as a safe
dry run. It can build and upload a workflow artifact for review, but it will not
publish release assets.

## Dry Run

Use these settings to test the full conversion without publishing:

```text
upstream_version=latest
casa_build=1
dry_run=true
force=false
create_release=false
```

The run uploads a workflow artifact containing the staged `.tar.gz` and
`.sha256` files. The publish bundle artifact also includes the generated
release notes and one-line install/uninstall scripts, but no GitHub Release is
created or modified during a dry run.

## Create A Prerelease

After reviewing a dry-run artifact, use:

```text
upstream_version=latest
casa_build=1
dry_run=false
force=false
create_release=true
```

This requests a protected publish job. The job waits for approval on the
`official-package-release` GitHub Actions environment, then creates a GitHub
prerelease in `Joetooley28/qmanager-casa-cfw3212-package`, for example
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

The publish job re-checks whether the tag exists after protected-environment
approval, creates new package releases through the GitHub Releases API as
prereleases, and uploads assets with `gh release upload` so GitHub's release
asset upload URL handling is used. If a tag appears between build and approval,
`force=false` still refuses to replace assets.

The builder stages the publish bundle as one flat artifact directory containing
the tarball, checksum, release notes, and one-line install/uninstall scripts.
The publish job validates those files before creating a release and prints the
downloaded bundle contents if anything is missing.

The generated release body must continue to include the upstream release-note
link, SHA-256, router-has-internet install command, no-internet/manual install
commands, Casa safety scope, and a clear `Actions-built prerelease. Not yet
live-router verified by JTooley.` note.

Automation titles new prereleases as:

```text
QManager vX.Y.Z-cfw3212.N for Casa CFW-3212 (Actions-built, unverified)
```

After live-router testing passes, run the builder repo workflow
`Mark Casa package release verified` with the Casa release tag. It keeps the
same tested release assets and edits only the release title/body, changing the
title label from `(Actions-built, unverified)` to `router-verified by JTooley`
and changing the body status line to say the package has been live-router
verified.

## Stable Releases

The workflow does not expose stable-release publishing. Automation only creates
or updates prereleases. Stable promotion should remain a manual GitHub release
operation after live-router testing.

Normal router updater flows should ignore prereleases unless a future GUI option
explicitly opts into prerelease checks.

## Permissions

The builder workflow uses read-only default permissions. It can build artifacts
without any package repo write token.

The protected publish job uses this builder repo environment:

```text
official-package-release
```

Configure that environment with:

- required reviewer: the repo owner
- environment secret: `PACKAGE_RELEASE_TOKEN`

```text
PACKAGE_RELEASE_TOKEN
```

Use a fine-grained token with `Contents: read and write` access only to:

```text
Joetooley28/qmanager-casa-cfw3212-package
```

No converter checkout token is required anymore because all converter and
builder files live in the public builder repo.
