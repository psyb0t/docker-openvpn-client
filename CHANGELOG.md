# Changelog

All notable changes per release. Versions follow [semver](https://semver.org).

## v0.1.5 — 2026-08-01

CI only — no image changes. The published image is identical to v0.1.4.

- Added `.github/workflows/mirror-and-archive.yml`: pushes are mirrored to GitLab and Codeberg, and the default branch plus tags are archived to the Wayback Machine and Software Heritage. Feature-branch pushes skip the archive because it is rate-limited. Gitee mirroring is present but disabled — it silently creates the repo private unless the account has a mobile number bound.
- Added `.github/workflows/issue-pull.yml`: issues opened on the GitLab and Codeberg mirrors are pulled back into this repo every six hours. The schedule is staggered per repo and jitters on top of that, since GitHub fires an account's crons at the same instant; a manual `workflow_dispatch` run skips the jitter.

## v0.1.4 — 2026-07-27

- Added a GitHub Actions CI status badge to the README.

## v0.1.3 — 2026-07-27

Add README status badges.

- Added self-hosted version and license badges (rendered as SVGs on the `badges` branch by the `create-badges` CI job, no third-party render service) plus a Docker Hub pulls badge. Wired a badges job into pipeline.yml.
