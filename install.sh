cat > install.sh <<'SH'
#!/usr/bin/env sh
set -eu
REPO_OWNER="elvmp"
REPO_NAME="matomo-upgrader"
BIN_NAME="matomo-upgrader"
PREFIX="${PREFIX:-/usr/local}"
BINDIR="$PREFIX/bin"
TMPDIR="$(mktemp -d)"
cleanup() { rm -rf "$TMPDIR"; }
trap cleanup EXIT INT TERM

echo "Downloading…"
curl -fsSL "https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/main/$BIN_NAME" -o "$TMPDIR/$BIN_NAME"
curl -fsSL "https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/main/$BIN_NAME.sha256" -o "$TMPDIR/$BIN_NAME.sha256"

echo "Verifying…"
( cd "$TMPDIR" && sha256sum -c "$BIN_NAME.sha256" )

echo "Installing to $BINDIR…"
install -d "$BINDIR"
install -m 0755 "$TMPDIR/$BIN_NAME" "$BINDIR/$BIN_NAME"

echo "Done. Try: $BIN_NAME --help"
SH
chmod +x install.sh
sed -i 's/\r$//' install.sh
