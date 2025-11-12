#!/usr/bin/env sh
set -eu

REPO="elvmp/matomo-upgrader"   # <-- your GitHub repo
BIN="upgradescript"

tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT

# Pick install prefix: /usr/local/bin if writable, else ~/.local/bin
prefix="/usr/local"
dest="$prefix/bin/$BIN"
if ! [ -w "$prefix/bin" ]; then
  prefix="$HOME/.local"
  mkdir -p "$prefix/bin"
  dest="$prefix/bin/$BIN"
fi

echo "-> Downloading $BIN ..."
curl -fsSL "https://raw.githubusercontent.com/$REPO/main/$BIN" -o "$tmp/$BIN"

# If you keep a checksum file, verify it; ignore if missing.
if curl -fsSL "https://raw.githubusercontent.com/$REPO/main/${BIN}.sha256" -o "$tmp/${BIN}.sha256"; then
  (cd "$tmp" && sha256sum -c "${BIN}.sha256")
fi

echo "-> Installing to $dest ..."
install -m 0755 "$tmp/$BIN" "$dest"

echo "Installed: $dest"
case ":$PATH:" in
  *":$prefix/bin:"*) ;;
  *) echo "Add to PATH and re-open your shell:"
     echo "    export PATH=\"$prefix/bin:\$PATH\""
     ;;
esac
