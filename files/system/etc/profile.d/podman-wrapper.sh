# Wrap podman with systemd-run to escape NoNewPrivileges constraints
# inherited from applications like VS Code (Electron sets NNP on itself,
# which propagates to all child processes including the integrated terminal).
podman() {
    systemd-run --user --wait --pipe --quiet -p NoNewPrivileges=no -- /usr/bin/podman "$@"
}
export -f podman
