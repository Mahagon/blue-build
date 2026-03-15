# blue-build &nbsp; [![build](https://github.com/mahagon/blue-build/actions/workflows/build.yml/badge.svg)](https://github.com/mahagon/blue-build/actions/workflows/build.yml)

Personal [BlueBuild](https://blue-build.org) repository that produces two custom Fedora Atomic OCI images.

| Image                                 | Base                    | Desktop  | Use         |
| ------------------------------------- | ----------------------- | -------- | ----------- |
| `ghcr.io/mahagon/work-cosmic-desktop` | Fedora COSMIC Atomic 43 | COSMIC   | Work laptop |
| `ghcr.io/mahagon/gaming-desktop`      | Bazzite (stable)        | KDE      | Gaming PC   |

Images are built automatically via GitHub Actions on every relevant push and on a daily schedule. Only the image(s) affected by changed files are rebuilt on push.

## Installation

> [!WARNING]
> [This is an experimental feature](https://www.fedoraproject.org/wiki/Changes/OstreeNativeContainerStable), try at your own discretion.

Replace `<image>` with `work-cosmic-desktop` or `gaming-desktop`.

**Step 1** - rebase to the unsigned image to get signing keys installed:

```shell
rpm-ostree rebase ostree-unverified-registry:ghcr.io/mahagon/<image>:latest
systemctl reboot
```

**Step 2** - rebase to the signed image:

```shell
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/mahagon/<image>:latest
systemctl reboot
```

## Verification

Images are signed with [cosign](https://github.com/sigstore/cosign). Verify with:

```shell
cosign verify --key cosign.pub ghcr.io/mahagon/<image>
```

## ISO

If running on Fedora Atomic, you can generate an offline ISO using the instructions [here](https://blue-build.org/learn/universal-blue/#fresh-install-from-an-iso).
