#!/usr/bin/env bash
# Build dos slides — Banco de Dados FAESA
# 1) Renderiza diagramas Mermaid (.mmd -> .svg) ao lado do fonte
# 2) Renderiza os decks Marp (.md -> .html) ao lado do fonte, com o tema FAESA
#
# Uso:  ./build.sh            (renderiza tudo)
#       ./build.sh caminho.md (renderiza um deck específico + seus diagramas)
#
# Requisitos: @marp-team/marp-cli (marp) e @mermaid-js/mermaid-cli (mmdc)
set -euo pipefail
cd "$(dirname "$0")"
THEME="themes/faesa.css"

render_mmd () { # $1 = arquivo .mmd
  local out="${1%.mmd}.svg"
  echo "  mmd → svg: $1"
  mmdc -i "$1" -o "$out" -t neutral -b transparent -q >/dev/null 2>&1
}
render_md () { # $1 = arquivo .md
  local out="${1%.md}.html"
  echo "  md  → html: $1"
  marp "$1" --theme "$THEME" --html --allow-local-files -o "$out"
}

if [ "${1:-}" != "" ]; then
  # deck específico: renderiza os .mmd da pasta assets vizinha e o próprio deck
  dir="$(dirname "$1")"
  [ -d "$dir/assets" ] && find "$dir/assets" -name '*.mmd' -print0 | while IFS= read -r -d '' f; do render_mmd "$f"; done
  render_md "$1"
else
  echo "== Diagramas Mermaid =="
  find unidades _template -name '*.mmd' -print0 2>/dev/null | while IFS= read -r -d '' f; do render_mmd "$f"; done
  echo "== Decks Marp =="
  find unidades _template -name '*.md' -print0 2>/dev/null | while IFS= read -r -d '' f; do render_md "$f"; done
fi
echo "OK."
